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
# --- block to keep the bot running and to log crashes ---
if __name__ == "__main__":
    import logging, traceback
    logging.basicConfig(level=logging.INFO)
    try:
        # Telethon client example
        if 'client' in globals():
            logging.info("Starting Telethon client...")
            client.start()
            logging.info("Telethon client started; blocking until disconnected")
            client.run_until_disconnected()

        # python-telegram-bot example
        elif 'updater' in globals():
            logging.info("Starting python-telegram-bot updater...")
            updater.start_polling()
            logging.info("Started polling for Telegram updates")
            updater.idle()

        else:
            logging.warning("No 'client' or 'updater' object found in globals(); exiting.")
    except Exception:
        logging.exception("Bot crashed")
        print(traceback.format_exc())
        raise

# اضافه کن در پایینِ bot.py
if __name__ == "__main__":
    import logging, os, asyncio
    logging.basicConfig(level=logging.INFO)
    try:
        # اگر Telethon client در فایل تعریف شده باشد
        if 'client' in globals():
            logging.info("Starting Telethon client...")
            # اگر client از Telethon است:
            try:
                client.start(bot_token=os.getenv("BOT_TOKEN"))
                client.run_until_disconnected()
            except Exception:
                # fallback async start
                asyncio.run(client.start(bot_token=os.getenv("BOT_TOKEN")))
                asyncio.run(client.run_until_disconnected())
        # اگر python-telegram-bot 'updater' یا Application موجود باشد
        elif 'updater' in globals():
            logging.info("Starting python-telegram-bot updater...")
            updater.start_polling()
            updater.idle()
        elif 'Application' in globals() or 'application' in globals():
            logging.info("Starting PTB Application...")
            app = globals().get('application') or globals().get('Application')
            try:
                app.run_polling()
            except Exception:
                logging.warning("Application found but run_polling failed.")
        else:
            logging.warning("No 'client' or 'updater' object found in globals(); exiting.")
    except Exception:
        logging.exception("Bot crashed")
