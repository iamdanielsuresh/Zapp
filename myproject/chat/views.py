from django.http import JsonResponse
from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync

def check_online_users(request, room_name):
    channel_layer = get_channel_layer()
    group_name = f"chat_{room_name}"
    
    active_users = async_to_sync(channel_layer.group_channels)(group_name)
    return JsonResponse({"active_users": list(active_users)})
