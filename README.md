# Telegram Register — Basic (Demo)

نسخهٔ دموی سادهٔ ربات ثبت‌نام تلگرام (برای تست و نمایش)
این نسخه شامل یک اسکریپت ساده `bot.py` است که:
- پرسش دو سوال از کاربر
- ذخیرهٔ پاسخ‌ها در فایل JSON
- دستور admin ساده برای export

## الزامات
- Python 3.11+
- pip

## راه‌اندازی سریع (لوکال)
1. کپی `.env.example` به `.env` و توکن ربات را پر کن
2. نصب وابستگی‌ها:
   ```bash
   python -m venv .venv
   source .venv/bin/activate
   pip install -r requirements.txt
