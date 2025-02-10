from pathlib import Path
import dj_database_url
import os
<<<<<<< HEAD
=======
from dotenv import load_dotenv

# Load environment variables
load_dotenv()
>>>>>>> daniel

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent

<<<<<<< HEAD
# Quick-start development settings - unsuitable for production
SECRET_KEY = 'django-insecure-6d8noc3dg%uq+o6+=d0+=yy&ebqmrbl+jyj#o8c&v159(3$(ta'
DEBUG = True
ALLOWED_HOSTS = ['192.168.226.219', 'localhost', '127.0.0.1', 'zap-849e3236293c.herokuapp.com']
=======
# Security settings
SECRET_KEY = os.getenv("SECRET_KEY")
DEBUG = os.getenv("DEBUG", "False") == "True"

# Allowed hosts
ALLOWED_HOSTS = os.getenv("ALLOWED_HOSTS").split(',')
>>>>>>> daniel

# Application definition
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'rest_framework',
    'corsheaders',
<<<<<<< HEAD
    'users',  
=======
    'users',
>>>>>>> daniel
    'otp'
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'corsheaders.middleware.CorsMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'whitenoise.middleware.WhiteNoiseMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'myproject.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'myproject.wsgi.application'

# Database configuration
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
<<<<<<< HEAD
        'NAME': 'zapp',
        'USER': 'postgres',
        'PASSWORD': 'code293b88',
        'HOST': 'localhost',
        'PORT': '5432',
    }


# DATABASES = {
#     'default': dj_database_url.config(
#         default='postgres://USER:PASSWORD@HOST:PORT/NAME'
#     )
# }    
}

=======
        'NAME': os.getenv("DATABASE_NAME"),
        'USER': os.getenv("DATABASE_USER"),
        'PASSWORD': os.getenv("DATABASE_PASSWORD"),
        'HOST': os.getenv("DATABASE_HOST"),
        'PORT': os.getenv("DATABASE_PORT"),
    }
}

# Alternative: Load from DATABASE_URL if provided
DATABASE_URL = os.getenv("DATABASE_URL")
if DATABASE_URL:
    DATABASES["default"] = dj_database_url.config(default=DATABASE_URL)

>>>>>>> daniel
# Password validation
AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]

# Internationalization settings
LANGUAGE_CODE = 'en-us'
TIME_ZONE = 'UTC'
USE_I18N = True
USE_TZ = True

# Static files settings
STATIC_URL = 'static/'

<<<<<<< HEAD
=======

# Media files (for future photo sharing)
MEDIA_URL = '/media/'
MEDIA_ROOT = os.path.join(BASE_DIR, 'media')

>>>>>>> daniel
# Default primary key field type
DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

# REST framework settings
REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework_simplejwt.authentication.JWTAuthentication',
    ),
}

<<<<<<< HEAD
TWILIO_ACCOUNT_SID = "AC6285dffec21e89056d743e5cf964e0ed"
TWILIO_AUTH_TOKEN = "ceb1d0e434b99d9ce251586d5dba4a48"
TWILIO_PHONE_NUMBER = "+18452534972"
=======
# Twilio settings
TWILIO_ACCOUNT_SID = os.getenv("TWILIO_ACCOUNT_SID")
TWILIO_AUTH_TOKEN = os.getenv("TWILIO_AUTH_TOKEN")
TWILIO_PHONE_NUMBER = os.getenv("TWILIO_PHONE_NUMBER")


>>>>>>> daniel



# CORS settings for Flutter app
<<<<<<< HEAD
CORS_ALLOW_ALL_ORIGINS = True  # For development purposes; restrict in production

# Heroku settings
# STATIC_ROOT = BASE_DIR / 'staticfiles'
# STATIC_URL = '/static/'
# STATICFILES_STORAGE = 'whitenoise.storage.CompressedManifestStaticFilesStorage'
=======
CORS_ALLOW_ALL_ORIGINS = True  # For development purposes; restrict in production
>>>>>>> daniel
