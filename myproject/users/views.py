from django.conf import settings
from rest_framework.decorators import api_view
from rest_framework.response import Response
from twilio.rest import Client
import random

otp_storage = {}  # Temporary in-memory storage for OTPs

@api_view(["POST"])
def send_otp(request):
    phone_number = request.data.get("phone")
    
    if not phone_number:
        return Response({"error": "Phone number is required"}, status=400)
    
    phone_number = phone_number.strip()

    if not phone_number.startswith("+91"):
        phone_number = "+91" + phone_number.lstrip("0")  # Ensure +91

    otp = random.randint(100000, 999999)
    otp_storage[phone_number] = otp

    try:
        client = Client(settings.TWILIO_ACCOUNT_SID, settings.TWILIO_AUTH_TOKEN)
        message = client.messages.create(
            body=f"Your OTP is {otp}",
            from_=settings.TWILIO_PHONE_NUMBER,
            to=phone_number
        )
        return Response({"message": "OTP sent successfully", "otp": otp})  # Include OTP for testing (remove in prod)
    
    except Exception as e:
        return Response({"error": str(e)}, status=500)


@api_view(["POST"])
def verify_otp(request):
    phone_number = request.data.get("phone")
    otp = request.data.get("otp")

    if otp_storage.get(phone_number) == int(otp):
        otp_storage.pop(phone_number)  # Remove OTP after successful verification
        return Response({"message": "OTP verified successfully", "token": "dummy_jwt_token"})
    return Response({"error": "Invalid OTP"}, status=400)
