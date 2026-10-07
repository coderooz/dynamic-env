import { Db, MongoClient } from "mongodb";

interface CachedConnection {
  client: MongoClient;
  db: Db;
}

/** Reads and validates MONGODB_URI at call time (fails fast on first use). */
function getMongoUri(): string {
  const uri = process.env.MONGODB_URI;
  if (!uri) {
    throw new Error(
      "Missing environment variable: MONGODB_URI. Copy .env.example to .env.local and set it."
    );
  }
  return uri;
}

/**
 * Cache the MongoClient promise across hot reloads in development so a new
 * connection pool is not created on every module evaluation.
 */
const globalWithMongo = globalThis as typeof globalThis & {
  _mongo?: CachedConnection;
};

async function connectToDatabase(): Promise<CachedConnection> {
  if (globalWithMongo._mongo) {
    return globalWithMongo._mongo;
  }

  const client = new MongoClient(getMongoUri());
  await client.connect();

  const connection: CachedConnection = {
    client,
    db: client.db(),
  };

  globalWithMongo._mongo = connection;
  return connection;
}

/** Returns the shared MongoDB database instance. */
export async function getDatabase(): Promise<Db> {
  const { db } = await connectToDatabase();
  return db;
}
