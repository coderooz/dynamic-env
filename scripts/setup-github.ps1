<#
.SYNOPSIS
  Syncs GitHub labels and milestones for this repository from .github definitions.

.DESCRIPTION
  Idempotent: safe to re-run. Labels are created/updated from .github/labels.json
  (gh label create --force), milestones from .github/milestones.json
  (create if missing, update state/description if present).

.EXAMPLE
  ./scripts/setup-github.ps1
  ./scripts/setup-github.ps1 -Owner coderooz -Repo dynamic-env
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
if (-not (gh repo view $repoRef --json name 2>$null)) {
  throw "Repository '$repoRef' not found or not accessible."
}

# --- Labels ---------------------------------------------------------------
$githubDir = Join-Path (Join-Path $PSScriptRoot "..") ".github"
$labelsPath = Join-Path $githubDir "labels.json"
$labels = Get-Content $labelsPath -Raw -Encoding UTF8 | ConvertFrom-Json

Write-Host "==> Syncing labels to $repoRef"
foreach ($label in $labels) {
  gh label create "$($label.name)" `
    --repo $repoRef `
    --color "$($label.color)" `
    --description "$($label.description)" `
    --force | Out-Null
  if ($LASTEXITCODE -ne 0) { throw "Failed to sync label '$($label.name)'." }
  Write-Host "    label: $($label.name)"
}

# --- Milestones -----------------------------------------------------------
$milestonesPath = Join-Path $githubDir "milestones.json"
$milestones = Get-Content $milestonesPath -Raw -Encoding UTF8 | ConvertFrom-Json
$existing = @(gh api "repos/$repoRef/milestones?state=all&per_page=100" | ConvertFrom-Json)

Write-Host "==> Syncing milestones to $repoRef"
foreach ($milestone in $milestones) {
  $match = $existing | Where-Object { $_.title -eq $milestone.title } | Select-Object -First 1
  if ($match) {
    gh api -X PATCH "repos/$repoRef/milestones/$($match.number)" `
      -f "title=$($milestone.title)" `
      -f "description=$($milestone.description)" `
      -f "state=$($milestone.state)" | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "Failed to update milestone '$($milestone.title)'." }
    $action = "updated"
  } else {
    gh api -X POST "repos/$repoRef/milestones" `
      -f "title=$($milestone.title)" `
      -f "description=$($milestone.description)" `
      -f "state=$($milestone.state)" | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "Failed to create milestone '$($milestone.title)'." }
    $action = "created"
  }
  Write-Host "    milestone ($action): $($milestone.title)"
}

Write-Host "==> Label & milestone sync complete."
