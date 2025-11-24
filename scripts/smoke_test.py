# scripts/smoke_test.py
import importlib, sys
print("Python:", sys.version.splitlines()[0])

pkgs = ["telethon", "pyrogram", "requests", "aiohttp", "dotenv"]
for p in pkgs:
    try:
        m = importlib.import_module(p)
        ver = getattr(m, "__version__", getattr(m, "__VERSION__", None))
        print(f"{p}: OK (version: {ver})")
    except Exception as e:
        print(f"{p}: IMPORT ERROR -> {e}")
