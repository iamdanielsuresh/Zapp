from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import OTPVerification
import random

class SendOTPView(APIView):
    def post(self, request):
        phone_number = request.data.get("phone_number")
        otp_code = str(random.randint(100000, 999999))
        OTPVerification.objects.update_or_create(phone_number=phone_number, defaults={"otp_code": otp_code})
        return Response({"message": f"OTP sent to {phone_number}"}, status=status.HTTP_200_OK)
