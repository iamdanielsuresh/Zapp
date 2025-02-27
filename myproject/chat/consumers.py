import json
import redis
from channels.generic.websocket import AsyncWebsocketConsumer

# Store active WebSocket connections
active_users = {}  # Format: {user_id: channel_name}

# Initialize Redis connection
redis_client = redis.Redis(host='localhost', port=6379, db=0, decode_responses=True)

class ChatConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        self.user_id = self.scope["url_route"]["kwargs"]["user_id"]
        self.channel_name = self.channel_name  # Unique channel for each WebSocket

        # Store user connection
        active_users[self.user_id] = self.channel_name

        await self.accept()
        print(f"✅ User {self.user_id} connected. Active users: {active_users}")

        # Send stored messages from Redis when user comes online
        await self.send_stored_messages()

    async def disconnect(self, close_code):
        # Remove user from active connections
        if self.user_id in active_users:    
            del active_users[self.user_id]
        print(f"❌ User {self.user_id} disconnected. Active users: {active_users}")

    async def receive(self, text_data):
        data = json.loads(text_data)
        message = data.get("message")
        sender = str(data.get("sender"))  # Convert sender to string
        recipient = str(data.get("recipient"))  # Convert recipient to string

        print(f"📩 Received message from {sender} to {recipient}: {message}")

        # Check if recipient is online
        if recipient in active_users:
            recipient_channel = active_users[recipient]

            # Send the message to the recipient
            await self.channel_layer.send(
                recipient_channel,
                {
                    "type": "chat_message",
                    "message": message,
                    "sender": sender
                }
            )
            print(f"✅ Message sent to {recipient} via {recipient_channel}")
        else:
            # Receiver is offline, store the message in Redis
            redis_client.rpush(f"offline_messages:{recipient}", json.dumps({"sender": sender, "message": message}))
            print(f"💾 Message stored in Redis for offline user {recipient}")

    async def chat_message(self, event):
        await self.send(text_data=json.dumps({
            "message": event["message"],
            "sender": event["sender"],
        }))

    async def send_stored_messages(self):
        """Send stored messages from Redis when a user comes online."""
        offline_messages_key = f"offline_messages:{self.user_id}"
        stored_messages = redis_client.lrange(offline_messages_key, 0, -1)

        if stored_messages:
            print(f"📤 Sending {len(stored_messages)} stored messages to {self.user_id}")

            for message_json in stored_messages:
                message_data = json.loads(message_json)
                await self.send(text_data=json.dumps(message_data))

            # Clear the stored messages after sending
            redis_client.delete(offline_messages_key)
            print(f"🗑️ Cleared stored messages for {self.user_id}")
