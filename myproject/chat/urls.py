from django.urls import path
from .views import check_online_users

urlpatterns = [
    path("check-online/<str:room_name>/", check_online_users, name="check_online"),
]
