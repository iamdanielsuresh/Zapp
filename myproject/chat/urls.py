from django.urls import path
from .views import check_online_users,get_offline_messages 

urlpatterns = [
    path("check-online/<str:room_name>/", check_online_users, name="check_online"),
    path('get-messages/<str:room_name>/', get_offline_messages, name='get_offline_messages'),
]
