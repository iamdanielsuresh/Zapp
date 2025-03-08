import jwt
from datetime import datetime, timedelta
from django.conf import settings

def generate_jwt_token(user):
    # Access Token (short-lived)
    access_payload = {
        "user_id": user.id,
        "exp": datetime.utcnow() + timedelta(minutes=15),  # Short expiration
        "iat": datetime.utcnow(),
    }
    access_token = jwt.encode(access_payload, settings.SECRET_KEY, algorithm="HS256")

    # Refresh Token (longer-lived)
    refresh_payload = {
        "user_id": user.id,
        "exp": datetime.utcnow() + timedelta(days=7),  # Longer expiration
        "iat": datetime.utcnow(),
    }
    refresh_token = jwt.encode(refresh_payload, settings.SECRET_KEY, algorithm="HS256")

    return {
        "access_token": access_token,
        "refresh_token": refresh_token
    }
