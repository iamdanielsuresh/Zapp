from django.db import models

class User(models.Model):
    phone_number = models.CharField(max_length=15, unique=True)  # Store phone number
    name = models.CharField(max_length=100, blank=True, null=True)
    email = models.EmailField(unique=True, blank=True, null=True)
    description = models.TextField(blank=True, null=True)
    profile_image = models.ImageField(upload_to="profile_images/", blank=True, null=True)

    def __str__(self):
        return self.phone_number
