<#
.SYNOPSIS
  Seeds the initial issue backlog for Dynamic-Env and assigns milestones.

.DESCRIPTION
  Creates the project's founding issues (if they do not already exist) and
  links each to the milestone defined in .github/milestones.json.
  Safe to re-run: issues whose title already exists are skipped.

.EXAMPLE
  ./scripts/seed-issues.ps1
#>
[CmdletBinding()]
param(
  [string]$Owner = "coderooz",
  [string]$Repo  = "dynamic-env"
)

$ErrorActionPreference = "Stop"

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
  throw "GitHub CLI (gh) is required. Install: https://cli.github.com/"
}

$repoRef = "$Owner/$Repo"

# --- Resolve milestone numbers (match by title length; titles are defined in
#     .github/milestones.json and contain a multi-byte em dash) -------------
$msRaw = gh api "repos/$repoRef/milestones?state=all" --jq '.[] | [(.title|length), .number] | @tsv'
$msByLength = @{}
foreach ($line in $msRaw) {
  $parts = $line -split "`t"
  $msByLength[[int]$parts[0]] = [int]$parts[1]
}
# Title lengths: 31 = v0.1.0 scaffolding, 25 = v0.2.0 core, 24 = v1.0.0 validation
$msScaffold = $msByLength[31]
$msCore     = $msByLength[25]
$msLive     = $msByLength[24]
if (-not ($msScaffold -and $msCore -and $msLive)) {
  throw "Milestones not found. Run scripts/setup-github.ps1 first."
}

$existing = @(gh issue list --repo $repoRef --state all --limit 100 --json title | ConvertFrom-Json | ForEach-Object { $_.title })

function Create-SeedIssue {
  param([string]$Title, [string]$Body, [string[]]$Labels, [int]$Milestone, [switch]$Close)

  if ($script:existing -contains $Title) {
    Write-Output "  skip (exists): $Title"
    return
  }

  $ghArgs = @("issue", "create", "--repo", $repoRef, "--title", $Title, "--body", $Body)
  foreach ($label in $Labels) { $ghArgs += @("--label", $label) }

  $url = & gh @ghArgs
  if ($LASTEXITCODE -ne 0) { throw "Failed to create issue: $Title" }

  $number = [int](($url -split "/")[-1])
  gh api -X PATCH "repos/$repoRef/issues/$number" -f milestone=$Milestone | Out-Null

  if ($Close) { gh issue close $number --repo $repoRef | Out-Null }

  Write-Output "  created #$number ($($Labels -join ', ')): $Title"
}

Write-Host "==> Seeding issues for $repoRef (milestones: $msScaffold/$msCore/$msLive)"

# --- v0.1.0 — Repository Scaffolding (closed) ----------------------------
Create-SeedIssue `
  -Title "chore: scaffold professional repository setup" `
  -Body @'
Initial repository hardening delivered:

- Governance docs: README, MIT LICENSE, CONTRIBUTING, CODE_OF_CONDUCT, SECURITY, CHANGELOG
- CI workflow (lint, typecheck, build) on push/PR to main
- Issue forms, PR template, Dependabot, CODEOWNERS, FUNDING
- Shared VS Code settings, launch configs and extension recommendations
- Label + milestone definitions with an idempotent sync script
- MongoDB driver and cached connection helper

Acceptance:

- [x] lint / typecheck / build all pass locally
- [x] labels and milestones synced to GitHub
- [x] repository pushed to origin/main
'@ `
  -Labels @("documentation", "ci") `
  -Milestone $msScaffold `
  -Close

# --- v0.2.0 — Dynamic Key Core (open) ------------------------------------
Create-SeedIssue `
  -Title "feat: define MongoDB schema for project API keys" `
  -Body @'
Design the collection/model for storing per-project API keys: key name, encrypted value, environment, timestamps, audit fields. Decide on encryption-at-rest approach before writing any routes.

Acceptance: schema documented, indexes defined, types exported from lib/.
'@ `
  -Labels @("enhancement") `
  -Milestone $msCore

Create-SeedIssue `
  -Title "feat: add key management API routes (create, read, rotate, revoke)" `
  -Body @'
Implement the CRUD surface for dynamic keys under app/api/. Rotate must invalidate the previous value; revoke must remove access immediately.

Acceptance: routes documented in README, validated inputs, no secrets echoed in responses.
'@ `
  -Labels @("enhancement") `
  -Milestone $msCore

Create-SeedIssue `
  -Title "feat: implement runtime key resolution helper" `
  -Body @'
Build the resolver that a deployed app calls to obtain an API key at runtime (cache, TTL, fallback to process env). This is the core experiment: keys change without a rebuild.

Acceptance: helper unit-testable, cache invalidation on rotation, clear failure mode when a key is missing.
'@ `
  -Labels @("enhancement") `
  -Milestone $msCore

Create-SeedIssue `
  -Title "feat: build key management dashboard UI" `
  -Body @'
Minimal dashboard to list, add, rotate and revoke keys per environment using the management API.

Acceptance: works on mobile widths, uses Tailwind v4 tokens, follows existing app styling.
'@ `
  -Labels @("enhancement", "good first issue") `
  -Milestone $msCore

# --- v1.0.0 — Live Validation (open) -------------------------------------
Create-SeedIssue `
  -Title "test: deploy to Vercel and verify dynamic key injection" `
  -Body @'
Deploy the app, configure MONGODB_URI in Vercel, and confirm a key added through the API is reachable from the deployed runtime.

Acceptance: live URL recorded, steps documented.
'@ `
  -Labels @("experiment") `
  -Milestone $msLive

Create-SeedIssue `
  -Title "test: e2e - add a key without redeploy and confirm runtime pickup" `
  -Body @'
The core hypothesis of this project: add a key to an already-deployed instance and confirm it is picked up without triggering a new build or deployment.

Acceptance: before/after deployment IDs unchanged, key value observable at runtime.
'@ `
  -Labels @("experiment") `
  -Milestone $msLive

Create-SeedIssue `
  -Title "docs: write deployment and dynamic environment guide" `
  -Body @'
End-to-end guide: local setup, Vercel deployment, adding the first key, rotation policy, and revocation.

Acceptance: linked from README.
'@ `
  -Labels @("documentation") `
  -Milestone $msLive

Create-SeedIssue `
  -Title "ci: add automated test job to the workflow" `
  -Body @'
Extend .github/workflows/ci.yml with a test job once a test runner is adopted (vitest recommended for Next.js 16).

Acceptance: tests gate PRs alongside lint/typecheck/build.
'@ `
  -Labels @("ci") `
  -Milestone $msLive

Write-Host "==> Issue seeding complete."
