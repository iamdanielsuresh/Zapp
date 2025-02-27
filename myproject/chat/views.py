from django.http import JsonResponse
from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync
import redis
import json 
from django.http import HttpResponse

def check_online_users(request, room_name):
    channel_layer = get_channel_layer()
    group_name = f"chat_{room_name}"
    
    active_users = async_to_sync(channel_layer.group_channels)(group_name)
    return JsonResponse({"active_users": list(active_users)})

def get_offline_messages(request, room_name):
    redis_client = redis.Redis(host="127.0.0.1", port=6379, db=1, decode_responses=True)
    room_key = f"chat_{room_name}"
    messages = redis_client.lrange(room_key, 0, -1)
    return JsonResponse({"messages": [json.loads(msg) for msg in messages]})

