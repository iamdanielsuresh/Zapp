import jwt
from datetime import datetime, timedelta
from django.conf import settings
from .models import User  # Import your User model

def generate_jwt_token(user):
    payload = {
        "user_id": user.id,
        "exp": datetime.utcnow() + timedelta(days=7),
        "iat": datetime.utcnow(),
    }
    token = jwt.encode(payload, settings.SECRET_KEY, algorithm="HS256")
    return token
