#!/usr/bin/env bash
# scripts/check_repo.sh
# اجرا: chmod +x scripts/check_repo.sh && ./scripts/check_repo.sh
set -euo pipefail

LOG="checks_report.txt"
echo "Repository check report" > "$LOG"
echo "Repo: $(basename $(pwd))" >> "$LOG"
echo "Date: $(date --iso-8601=seconds)" >> "$LOG"
echo >> "$LOG"

echo "== Python & venv ==" >> "$LOG"
python --version >> "$LOG" 2>&1 || echo "python not found" >> "$LOG"
# create venv
python -m venv .ci-venv >> "$LOG" 2>&1 || true
# activate (POSIX)
source .ci-venv/bin/activate || true
python -m pip install --upgrade pip setuptools wheel >> "$LOG" 2>&1 || true
echo >> "$LOG"

echo "== Install requirements ==" >> "$LOG"
if [ -f requirements.txt ]; then
  pip install -r requirements.txt >> "$LOG" 2>&1 || echo "pip install had errors (see above)" >> "$LOG"
else
  echo "No requirements.txt found" >> "$LOG"
fi
echo >> "$LOG"

echo "== Static syntax check (compileall) ==" >> "$LOG"
python -m compileall -q . >> "$LOG" 2>&1 || echo "compileall reported issues (see above)" >> "$LOG"
echo >> "$LOG"

echo "== Lint (pylint) ==" >> "$LOG"
pip install pylint >/dev/null 2>&1 || true
PY_FILES=$(git ls-files '*.py' || find . -name '*.py' | sed 's|^\./||')
if [ -n "$PY_FILES" ]; then
  echo "Running pylint on found python files..." >> "$LOG"
  pylint $PY_FILES >> "$LOG" 2>&1 || echo "pylint finished with issues (see above)" >> "$LOG"
else
  echo "No python files found for lint." >> "$LOG"
fi
echo >> "$LOG"

echo "== Security scan (bandit) ==" >> "$LOG"
pip install bandit >/dev/null 2>&1 || true
bandit -r . -q >> "$LOG" 2>&1 || echo "bandit finished (check above for issues)" >> "$LOG"
echo >> "$LOG"

echo "== Type checking (mypy) (optional) ==" >> "$LOG"
pip install mypy >/dev/null 2>&1 || true
mypy . >> "$LOG" 2>&1 || echo "mypy finished (or not configured)" >> "$LOG"
echo >> "$LOG"

echo "== Tests (pytest) ==" >> "$LOG"
pip install pytest >/dev/null 2>&1 || true
if [ -d tests ] || git ls-files '*test*.py' | grep -q 'test'; then
  pytest -q >> "$LOG" 2>&1 || echo "pytest had failures (see above)" >> "$LOG"
else
  echo "No tests found" >> "$LOG"
fi
echo >> "$LOG"

echo "== Try run entrypoints (non-destructive) ==" >> "$LOG"
# try common entrypoints
for f in main.py bot.py run.py app.py; do
  if [ -f "$f" ]; then
    echo "Trying: python $f --help" >> "$LOG"
    python "$f" --help >> "$LOG" 2>&1 || echo "running $f --help returned non-zero (may be OK)" >> "$LOG"
    echo >> "$LOG"
  fi
done

echo "== Secret scan in files ==" >> "$LOG"
# grep for common secret patterns
grep -nRIE "ghp_|api_key|API_KEY|api_hash|API_HASH|SECRET|PASSWORD|BOT_TOKEN|TOKEN" . || true
echo >> "$LOG"

echo "== Git history quick check for common PAT prefix (if this is a git repo) ==" >> "$LOG"
if [ -d .git ]; then
  git --no-pager log --all --grep='ghp_' -n 20 >> "$LOG" 2>&1 || true
  # Also search entire history for typical token strings (slow)
  # echo "Searching object history for 'ghp_' (this can take a while)..." >> "$LOG"
  # git rev-list --all | while read rev; do git grep -n 'ghp_' $rev || true; done >> "$LOG"
else
  echo "Not a git repo (skip git-history checks)" >> "$LOG"
fi
echo >> "$LOG"

echo "== Final notes ==" >> "$LOG"
echo "If any 'ERROR', 'Traceback' or 'FAILED' lines appear above, copy those sections and send to your reviewer." >> "$LOG"
echo "Report saved to: $PWD/$LOG"
echo "END" >> "$LOG"

# print short summary to terminal
echo "Checks finished. Report -> $LOG"
