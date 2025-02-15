import json
from channels.generic.websocket import AsyncWebsocketConsumer
import redis

# Connect to Redis
redis_client = redis.StrictRedis(host="127.0.0.1", port=6379, db=1, decode_responses=True)

class ChatConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        self.room_name = self.scope["url_route"]["kwargs"]["room_name"]
        self.room_group_name = f"chat_{self.room_name}"

        await self.channel_layer.group_add(self.room_group_name, self.channel_name)
        await self.accept()

        messages = redis_client.lrange(self.room_group_name, 0, -1)
        for message in messages:
            await self.send(text_data=message)
        redis_client.delete(self.room_group_name)

    async def disconnect(self, close_code):
        await self.channel_layer.group_discard(self.room_group_name, self.channel_name)

    async def receive(self, text_data):
        data = json.loads(text_data)
        message = data["message"]
        sender = data["sender"]

        response = json.dumps({"sender": sender, "message": message})

        group_users = await self.channel_layer.group_channels(self.room_group_name)
        if group_users:
            await self.channel_layer.group_send(
                self.room_group_name, {"type": "chat_message", "message": response}
            )
        else:
            redis_client.rpush(self.room_group_name, response)

    async def chat_message(self, event):
        message = event["message"]
        await self.send(text_data=message)
