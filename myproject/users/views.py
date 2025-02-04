from rest_framework import status
from django.conf import settings
from rest_framework.decorators import api_view
from rest_framework.response import Response
from twilio.rest import Client
import random
from django.shortcuts import get_object_or_404
from .models import User  # Import your User model
from .utils import generate_jwt_token  # A function to generate JWT tokens

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

    # Check if OTP is correct
    if otp_storage.get(phone_number) == int(otp):
        otp_storage.pop(phone_number)  # Remove OTP after successful verification
        
        # Check if the user exists in PostgreSQL
        user = User.objects.filter(phone_number=phone_number).first()


        if user:  # User exists, log them in
            token = generate_jwt_token(user)  # Generate JWT token
            return Response({"exists":True,"message": "User exists, logged in", "token": token}, status=status.HTTP_200_OK)

        # User does not exist, register them
        user = User.objects.create(phone_number=phone_number)
        token = generate_jwt_token(user)  # Generate JWT token after registration

        return Response({"exists":False,"message": "User registered successfully", "token": token}, status=status.HTTP_201_CREATED)
    
    return Response({"error": "Invalid OTP"}, status=status.HTTP_400_BAD_REQUEST)
