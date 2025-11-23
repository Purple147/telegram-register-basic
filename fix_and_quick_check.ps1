# fix_and_quick_check.ps1
# Put this in the parent folder that contains:
# pr-assistant-standard, pr-assistant-pro, telegram-register-basic
# Run in PowerShell: Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass; .\fix_and_quick_check.ps1

$Repos = @("pr-assistant-standard","pr-assistant-pro","telegram-register-basic")
$Root = Get-Location

foreach ($r in $Repos) {
  $repoPath = Join-Path $Root $r
  if (-not (Test-Path $repoPath)) {
    Write-Output "SKIP: $r not found"
    continue
  }
  Set-Location $repoPath
  $report = Join-Path $Root "$r-quick-report.txt"
  "=== Quick report for $r ===" | Out-File $report -Encoding utf8
  ("Path: " + $repoPath) | Out-File $report -Append

  # remove existing venv if any
  if (Test-Path ".venv") {
    "Removing existing .venv ..." | Out-File $report -Append
    Remove-Item -Recurse -Force .venv -ErrorAction SilentlyContinue
  }

  # create venv (try with --upgrade-deps, fallback to ensurepip)
  "Creating venv..." | Out-File $report -Append
  $py = "python"
  & $py -m venv .venv --upgrade-deps 2>&1 | Out-File $report -Append
  if (-not (Test-Path ".venv\Scripts\python.exe")) {
    "Fallback venv creation..." | Out-File $report -Append
    & $py -m venv .venv 2>&1 | Out-File $report -Append
    & .\.venv\Scripts\python.exe -m ensurepip --upgrade 2>&1 | Out-File $report -Append
  }

  # activate and install tools
  try {
    . .\.venv\Scripts\Activate.ps1
  } catch {
    "Could not run Activate.ps1 (continuing with direct python calls)" | Out-File $report -Append
  }

  $vpy = Join-Path (Join-Path $repoPath ".venv\Scripts") "python.exe"
  "$vpy -m pip install --upgrade pip setuptools wheel" | Out-File $report -Append
  & $vpy -m pip install --upgrade pip setuptools wheel 2>&1 | Out-File $report -Append

  "$vpy -m pip install pip-audit bandit pytest safety" | Out-File $report -Append
  & $vpy -m pip install pip-audit bandit pytest safety 2>&1 | Out-File $report -Append

  if (Test-Path "requirements.txt") {
    "$vpy -m pip install -r requirements.txt" | Out-File $report -Append
    & $vpy -m pip install -r requirements.txt 2>&1 | Out-File $report -Append
  } else {
    "No requirements.txt" | Out-File $report -Append
  }

  # run checks
  "== pip-audit ==" | Out-File $report -Append
  & $vpy -m pip_audit --progress-spinner off 2>&1 | Out-File $report -Append

  "== bandit ==" | Out-File $report -Append
  & $vpy -m bandit -r . -ll 2>&1 | Out-File $report -Append

  "== compileall (syntax) ==" | Out-File $report -Append
  & $vpy -m compileall . 2>&1 | Out-File $report -Append

  "== smoke import check ==" | Out-File $report -Append
  if (Test-Path "smoke_imports.py") {
    & $vpy smoke_imports.py 2>&1 | Out-File $report -Append
  } else {
    "smoke_imports.py not found — skipping" | Out-File $report -Append
  }

  "Report saved: $report" | Out-File $report -Append

  # try to deactivate
  try { deactivate } catch {}
  Set-Location $Root
}
"All repos processed." | Out-File (Join-Path $Root "fix_all_log.txt") -Append
