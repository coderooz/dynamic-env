# Dynamic-Env

[![CI](https://github.com/coderooz/dynamic-env/actions/workflows/ci.yml/badge.svg)](https://github.com/coderooz/dynamic-env/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Next.js](https://img.shields.io/badge/Next.js-16-black?logo=next.js)](https://nextjs.org)
[![Tailwind CSS](https://img.shields.io/badge/Tailwind_CSS-v4-38bdf8?logo=tailwindcss&logoColor=white)](https://tailwindcss.com)
[![MongoDB](https://img.shields.io/badge/MongoDB-8-47A248?logo=mongodb&logoColor=white)](https://www.mongodb.com)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

> Experimental harness for **dynamically injecting API keys into already-deployed projects** — no rebuild, no redeploy.

**Dynamic-Env** explores a system where API keys for a deployed application are stored in MongoDB and resolved at runtime, so keys can be added, rotated, or revoked without triggering a new build or touching static environment variables.

---

## Features (planned / in progress)

- 🗃️ MongoDB-backed store for project API keys
- ⚡ Runtime key resolution — no rebuild required to add or rotate keys
- 🔌 Simple API routes for managing keys against a deployed instance
- 🧪 Focused testbed for validating dynamic configuration on live apps

## Tech Stack

| Layer | Technology |
| --- | --- |
| Framework | [Next.js 16](https://nextjs.org) (App Router, Turbopack) |
| UI | [React 19](https://react.dev), [Tailwind CSS v4](https://tailwindcss.com) |
| Language | [TypeScript 5](https://www.typescriptlang.org) (strict) |
| Database | [MongoDB](https://www.mongodb.com) (native driver) |
| Linting | [ESLint 9](https://eslint.org) (flat config, `eslint-config-next`) |
| CI | [GitHub Actions](https://github.com/features/actions) |
| Deployment | [Vercel](https://vercel.com) |

## Getting Started

### Prerequisites

- Node.js 20.9+ (22 LTS recommended)
- npm 10+
- A MongoDB connection string (local or [Atlas](https://www.mongodb.com/cloud/atlas))

### Setup

```bash
# 1. Clone the repository
git clone https://github.com/coderooz/dynamic-env.git
cd dynamic-env

# 2. Install dependencies
npm install

# 3. Configure environment variables
cp .env.example .env.local
# Edit .env.local and set MONGODB_URI

# 4. Start the development server
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) to view the app.

## Scripts

| Command | Description |
| --- | --- |
| `npm run dev` | Start the development server (Turbopack) |
| `npm run build` | Create a production build |
| `npm run start` | Serve the production build |
| `npm run lint` | Run ESLint |
| `npm run typecheck` | Run the TypeScript compiler in no-emit mode |

## Environment Variables

| Variable | Required | Description |
| --- | --- | --- |
| `MONGODB_URI` | Yes | MongoDB connection string used to store dynamic API keys |
| `NEXT_PUBLIC_APP_URL` | No | Public URL of the deployed application |

See [`.env.example`](.env.example) for a copyable template. **Never commit `.env.local`.**

## Project Structure

```
dynamic-env/
├── app/                  # Next.js App Router (routes, layouts, pages)
├── lib/                  # Shared helpers (e.g. MongoDB connection)
├── public/               # Static assets
├── scripts/              # Repo automation (GitHub setup sync)
├── .github/              # Workflows, issue/PR templates, labels, funding
├── .vscode/              # Shared editor settings, launch configs, extensions
└── .workspace/           # Local dev workspace (gitignored, except PRI/LFI)
```

## CI

Every push and pull request to [`main`](https://github.com/coderooz/dynamic-env/tree/main) runs the [CI workflow](.github/workflows/ci.yml): **lint → typecheck → build**.

## Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) and the [Code of Conduct](CODE_OF_CONDUCT.md) before opening a pull request.

## Security

To report a vulnerability, see [SECURITY.md](SECURITY.md). **Do not open a public issue for security reports.**

## License

Licensed under the [MIT License](LICENSE) © Ranit Saha ([Coderooz](https://coderooz.in)).

## Author

**Ranit Saha** (Coderooz) — [github.com/coderooz](https://github.com/coderooz) · [coderooz.in](https://coderooz.in) · [contact@coderooz.in](mailto:contact@coderooz.in)
