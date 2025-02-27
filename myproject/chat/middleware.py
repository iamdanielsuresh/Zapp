from channels.middleware import BaseMiddleware
import asyncio

class NoAuthMiddleware(BaseMiddleware):
    async def __call__(self, scope, receive, send):
        scope["user"] = None  # Temporarily disable authentication
        return await super().__call__(scope, receive, send)
