#!/usr/bin/env bash
set -e
python -m venv venv
source venv/bin/activate
pip install --upgrade pip
if [ -f requirements.txt ]; then pip install -r requirements.txt; fi
echo "Done. Copy .env.example to .env and fill values."
