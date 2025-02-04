from django.urls import path
from .views import send_otp, verify_otp,update_user_details 

urlpatterns = [
    path('send-otp/', send_otp, name='send_otp'),
    path('verify-otp/', verify_otp, name='verify_otp'),
    path('update-user/', update_user_details, name="update_user_details"),
]