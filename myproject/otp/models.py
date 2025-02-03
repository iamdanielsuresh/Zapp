from django.db import models

class OTPVerification(models.Model):
    phone_number = models.CharField(max_length=15, unique=True)
    otp_code = models.CharField(max_length=6)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.phone_number} - {self.otp_code}"
