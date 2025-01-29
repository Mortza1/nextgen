#!/usr/bin/env python
from app import app

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="localhost", port=8000)
    # uvicorn.run(app, host="localhost", port=8080)