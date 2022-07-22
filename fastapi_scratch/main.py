from fastapi import FastAPI

app = FastAPI()


@app.get("/", responses={404: {"response": "not found"}})
async def hello():
    return {"response": "hello world!"}
