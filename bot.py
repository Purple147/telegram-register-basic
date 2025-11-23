# اضافه کن در بالای bot.py
import os, sys, time, logging
logging.basicConfig(stream=sys.stdout, level=logging.DEBUG, format="%(asctime)s %(levelname)s %(message)s")
logging.info("Starting bot.py")
logging.info(f"ENV BOT_TOKEN present: {'BOT_TOKEN' in os.environ or os.path.exists('.env')}")
# اگر از python-dotenv استفاده شده، force load it:
try:
    from dotenv import load_dotenv
    load_dotenv()
    logging.info("Loaded .env")
except Exception as e:
    logging.exception("dotenv load error")
