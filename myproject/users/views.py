from django.shortcuts import get_object_or_404
from django.contrib.auth.models import User
from rest_framework.response import Response
from rest_framework.decorators import api_view
from django.conf import settings
import requests
import random

otp_storage = {}  # Temporary in-memory storage for OTPs

EXOTEL_SID = "cusat2"
EXOTEL_TOKEN = "your_exotel_token"
EXOTEL_SENDER_ID = "your_exotel_sender_id"  # Your Exotel approved sender ID

@api_view(["POST"])
def send_otp(request):
    phone_number = request.data.get("phone")
    
    if not phone_number.startswith("+91"):
        phone_number = "+91" + phone_number.lstrip("0")

    otp = random.randint(100000, 999999)
    otp_storage[phone_number] = otp

    # Exotel API URL
    url = f"https://api.exotel.com/v1/Accounts/{EXOTEL_SID}/Sms/send"

    payload = {
        "From": EXOTEL_SENDER_ID,
        "To": phone_number,
        "Body": f"Your OTP is {otp}. Please do not share it."
    }

    response = requests.post(url, data=payload, auth=(EXOTEL_SID, EXOTEL_TOKEN))
    
    if response.status_code == 200:
        return Response({"message": "OTP sent successfully"})
    else:
        return Response({"error": "Failed to send OTP", "details": response.json()}, status=500)

@api_view(["POST"])
def verify_otp(request):
    phone_number = request.data.get("phone")
    otp = request.data.get("otp")

    if otp_storage.get(phone_number) == int(otp):
        otp_storage.pop(phone_number)  # Remove OTP after successful verification
        return Response({"message": "OTP verified successfully", "token": "dummy_jwt_token"})
    return Response({"error": "Invalid OTP"}, status=400)
