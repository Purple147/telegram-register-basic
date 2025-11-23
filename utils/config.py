# utils/config.py
import os
from dotenv import load_dotenv

load_dotenv()

def get_env(key, default=None, cast=str, required=False):
    v = os.getenv(key, default)
    if required and v is None:
        raise RuntimeError(f"Environment variable {key} is required but not set.")
    if v is None:
        return v
    if cast and cast is not str:
        try:
            return cast(v)
        except Exception:
            return v
    return v

API_ID = get_env("API_ID")
API_HASH = get_env("API_HASH")
BOT_TOKEN = get_env("BOT_TOKEN")
TELEGRAM_SESSION = get_env("TELEGRAM_SESSION")
NAME_FILE = get_env("NAME_FILE", "name.txt")
PROXY_LIST_PATH = get_env("PROXY_LIST_PATH", "proxies.txt")