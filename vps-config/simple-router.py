import uvicorn
from fastapi import FastAPI, Request
from fastapi.responses import StreamingResponse
import httpx

app = FastAPI()

# Routed directly to the loopback interface for the secure reverse SSH tunnel
MAC_IP = "127.0.0.1" 
MAC_URL = f"http://{MAC_IP}:11434"

@app.api_route("/{path:path}", methods=["GET", "POST", "PUT", "DELETE"])
async def proxy(path: str, request: Request):
    target_url = f"{MAC_URL}/{path}"
    body_content = await request.body()

    async def stream_content():
        async with httpx.AsyncClient(timeout=None) as client:
            req = client.build_request(
                method=request.method,
                url=target_url,
                headers=request.headers.raw,
                content=body_content
            )
            res = await client.send(req, stream=True)
            async for chunk in res.aiter_raw():
                yield chunk

    return StreamingResponse(stream_content())

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=4000)
