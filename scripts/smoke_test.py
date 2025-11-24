# scripts/smoke_test.py
import importlib, sys, platform

print("Python:", sys.version.splitlines()[0])
print("Platform:", platform.platform())

# Windows: set selector event loop policy for compatibility on some Python versions
try:
    if sys.platform.startswith("win"):
        import asyncio
        try:
            asyncio.set_event_loop_policy(asyncio.WindowsSelectorEventLoopPolicy())
            print("Set WindowsSelectorEventLoopPolicy()")
        except Exception as e:
            print("Could not set WindowsSelectorEventLoopPolicy():", e)
except Exception as e:
    print("Event loop policy check error:", e)

pkgs = ["telethon", "pyrogram", "tgcrypto", "requests", "aiohttp", "dotenv"]
for p in pkgs:
    try:
        m = importlib.import_module(p)
        ver = getattr(m, "__version__", getattr(m, "__VERSION__", None))
        print(f"{p}: OK (version: {ver})")
    except Exception as e:
        print(f"{p}: IMPORT ERROR -> {e}")
