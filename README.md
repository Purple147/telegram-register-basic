# Telegram Register — Basic (Demo)

نسخهٔ دموی سادهٔ ربات ثبت‌نام تلگرام.

## قابلیت‌ها
- پرسش چند سوال ساده از کاربر
- ذخیرهٔ پاسخ‌ها در `data.json`
- export ساده با دستور admin

## الزامات
- Python 3.11+
- Docker (اختیاری)

## راه‌اندازی سریع (لوکال)
1. کپی `.env.example` به `.env` و `BOT_TOKEN` را قرار بده.
2. نصب و اجرا:
   ```bash
   # بدون داکر
   python -m venv .venv
   source .venv/bin/activate
   pip install -r requirements.txt
   python bot.py

   # با داکر
   docker-compose up --build -d


   # در شاخه repo
docker-compose up --build
# یا لوکال بدون داکر
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python bot.py



## Windows Quickstart

# Quickstart (Windows)
python -m venv .venv
# in Git Bash:
source .venv/Scripts/activate
# in PowerShell:
# .\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
cp .env.example .env
# edit .env to put BOT_TOKEN and other values
python bot.py


## Windows Quickstart

# Quickstart (Windows)
python -m venv .venv
# in Git Bash:
source .venv/Scripts/activate
# in PowerShell:
# .\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
cp .env.example .env
# edit .env to put BOT_TOKEN and other values
python bot.py


## Windows Quickstart

# Quickstart (Windows)
python -m venv .venv
# in Git Bash:
source .venv/Scripts/activate
# in PowerShell:
# .\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
cp .env.example .env
# edit .env to put BOT_TOKEN and other values
python bot.py
