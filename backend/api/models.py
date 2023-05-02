from django.db import models as models_django
from django.contrib.auth.base_user import BaseUserManager
from django.contrib.auth.models import AbstractUser
from djongo import models as models_djongo

# Create your models here.

class CustomUserManager(BaseUserManager):
    def create_user(self,email,first_name,last_name,middle_initial,suffix,phone_no,username,verified,id_type,id_picture,id_number,archived,tickets,type,accommodations,password,**extra_fields):
        email=self.normalize_email(email)

        user=self.model(
            #_id=_id,
            email=email,
            first_name=first_name,
            last_name=last_name,
            middle_initial=middle_initial,
            suffix=suffix,
            username=username,
            phone_no=phone_no,
            verified=verified,
            id_type=id_type,
            id_picture=id_picture,
            id_number=id_number,
            archived=archived,
            tickets=tickets,
            type=type,
            accommodations=accommodations,
            **extra_fields
        )

        user.set_password(password)
        user.save()

        return user

    def create_superuser(self,username,password,**extra_fields):
        extra_fields.setdefault("is_staff", True)
        extra_fields.setdefault("is_superuser", True)

        if extra_fields.get("is_staff") is not True:
            raise ValueError("Superuser has to have is_staff being True")

        if extra_fields.get("is_superuser") is not True:
            raise ValueError("Superuser has to have is_superuser being True")

        user=self.model(
            username=username,
            type="admin",
            **extra_fields
        )

        user.set_password(password)
        user.save()

        return user

class User(AbstractUser):
    #_id = models_djongo.ObjectIdField()
    email=models_django.CharField(max_length=80,unique=True)
    first_name = models_djongo.CharField(max_length=100)
    last_name = models_django.CharField(max_length=100)
    middle_initial = models_django.CharField(max_length=1)
    suffix = models_django.CharField(max_length=10)
    phone_no = models_django.CharField(max_length=15)
    username=models_django.CharField(max_length=45)
    verified = models_django.BooleanField(default=False)
    id_type = models_django.CharField(max_length=50)
    id_picture = models_django.URLField()
    id_number = models_django.CharField(max_length=50)
    archived = models_django.BooleanField(default=False)
    tickets = models_djongo.JSONField(default=list)
    type = models_django.CharField(max_length=50)
    accommodations = models_djongo.JSONField(default=list)

    objects = CustomUserManager()
    USERNAME_FIELD = "email"
    REQUIRED_FIELDS = ["username"]


    def __str__(self):
        return self.username

class Admin(models_django.Model):
    username = models_django.CharField(max_length=255)
    password = models_django.CharField(max_length=255)
    def str(self):
        return self.username

class Review(models_django.Model):
    _id = models_djongo.ObjectIdField()
    userID = models_djongo.ForeignKey(User, on_delete=models_djongo.CASCADE)
    # accomodationID = models.ForeignKey(Accommodation, on_delete=models.CASCADE)
    dateSubmited = models_django.DateTimeField()
    title = models_django.CharField(max_length=255)
    rating = models_django.IntegerField()
    archived = models_django.BooleanField()
    body = models_django.TextField()

