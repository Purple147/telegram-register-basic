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
