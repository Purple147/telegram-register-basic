#!/usr/bin/env bash
# quick local run
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python bot.py
