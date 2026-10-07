# Security Policy

## Supported Versions

Security fixes are applied to the latest code on the `main` branch.

| Version | Supported |
| --- | --- |
| `main` (latest) | ✅ |
| Older releases / commits | ❌ |

## Reporting a Vulnerability

Please **do not** open a public GitHub issue for security vulnerabilities.

Instead, report them privately:

- **Email:** [contact@coderooz.in](mailto:contact@coderooz.in)
- **Subject line:** `[SECURITY] dynamic-env — <short description>`

Please include:

1. A description of the vulnerability and its potential impact.
2. Steps to reproduce (PoC, affected routes/endpoints if applicable).
3. Affected version(s) / commit SHA, if known.
4. Any suggested fix, if you have one.

## What to Expect

- **Acknowledgement** within **48 hours** of receipt.
- An initial assessment and remediation plan within **7 days**.
- Coordinated disclosure: once a fix is released, we are happy to credit you
  in the advisory/changelog (unless you prefer to remain anonymous).

## Scope

In scope:

- Vulnerabilities in this repository's application code (e.g. key handling,
  injection, auth bypass, secret exposure).
- Leaked credentials or API keys committed to this repository.

Out of scope:

- Vulnerabilities in third-party dependencies (report upstream; Dependabot
  alerts are enabled for this repository).
- Denial-of-service / volumetric attacks.
- Issues in the deployment platform (Vercel, MongoDB Atlas) itself.

## Secret Handling

- Never commit real API keys or connection strings — `.env*` files (except
  `.env.example`) are gitignored.
- If a secret is accidentally committed, rotate it immediately and report it
  per the process above.
