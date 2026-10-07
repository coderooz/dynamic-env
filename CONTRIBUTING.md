# Contributing to Dynamic-Env

Thanks for your interest in contributing! 🎉

This project is an experimental testbed, so contributions that improve the core dynamic-key mechanism, documentation, or test coverage are especially welcome.

## Getting Started

1. Fork the repository and create your branch from `main`:

   ```bash
   git checkout -b feature/my-change
   ```

2. Install dependencies and configure your environment:

   ```bash
   npm install
   cp .env.example .env.local
   ```

3. Make your changes.

4. Validate before pushing:

   ```bash
   npm run lint
   npm run typecheck
   npm run build
   ```

5. Open a pull request using the PR template.

## Branch Naming

| Prefix | Use |
| --- | --- |
| `feat/` | New features |
| `fix/` | Bug fixes |
| `docs/` | Documentation only |
| `chore/` | Tooling, CI, maintenance |
| `refactor/` | Code changes that fix no bugs and add no features |

## Commit Messages

This repository follows [Conventional Commits](https://www.conventionalcommits.org/):

```
type(scope): short description
```

Examples: `feat(api): add key rotation endpoint`, `chore(ci): pin action versions`.

## Pull Request Guidelines

- One change per PR; keep it focused.
- Fill out the PR template (what changed, why, how it was validated).
- CI must pass (lint → typecheck → build).
- Update documentation and `.env.example` when behavior or configuration changes.
- PRs targeting `main` require at least one approving review before merge.

## Reporting Issues

- **Bugs** → use the [Bug report](.github/ISSUE_TEMPLATE/bug_report.yml) template.
- **Features** → use the [Feature request](.github/ISSUE_TEMPLATE/feature_request.yml) template.
- **Security** → follow [SECURITY.md](SECURITY.md) instead of opening a public issue.

## Code Style

- TypeScript strict mode; prefer `interface` over `type` for object shapes.
- `const` over `let`, never `var`.
- Use optional chaining (`?.`) and nullish coalescing (`??`).
- ESLint flat config is authoritative — run `npm run lint` and fix all errors.

## License

By contributing, you agree that your contributions will be licensed under the [MIT License](LICENSE).
