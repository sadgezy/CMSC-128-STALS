from django.db import models as models_django
from djongo import models as models_djongo
from django.core.validators import MinValueValidator, MaxValueValidator

# Create your models here.
class Admin(models_django.Model):
    _id = models_djongo.ObjectIdField()
    username = models_django.CharField(max_length=255)
    password = models_django.CharField(max_length=255)
    # other fields of your model
    def str(self):
        return self.username

# class user(models_django.Model):
#     _id = models_djongo.ObjectIdField()
#     name = models_django.CharField(max_length=255)
#     verified = models_django.BooleanField(default=False)

class Name(models_django.Model):
    first_name = models_django.CharField(max_length=100)
    last_name = models_django.CharField(max_length=100)
    middle_initial = models_django.CharField(max_length=1)
    suffix = models_django.CharField(max_length=10)

class ContactDetails(models_django.Model):
    phone_no = models_django.CharField(max_length=15)
    email = models_django.EmailField(help_text="Please enter a valid email address")

class IDVerification(models_django.Model):
    id_type = models_django.CharField(max_length=50)
    id_picture = models_django.URLField()
    id_number = models_django.CharField(max_length=50)

class UserType(models_django.Model):
    type = models_django.CharField(max_length=50)
    accommodations = models_djongo.JSONField()

class User(models_django.Model):
    _id = models_djongo.ObjectIdField()
    name = models_django.OneToOneField(Name, on_delete=models_djongo.CASCADE)
    username = models_django.CharField(max_length=50)
    password = models_django.CharField(max_length=50)
    contact_details = models_django.OneToOneField(ContactDetails, on_delete=models_djongo.CASCADE)
    verified = models_django.BooleanField()
    id_verification = models_django.OneToOneField(IDVerification, on_delete=models_djongo.CASCADE)
    archived = models_django.BooleanField()
    tickets = models_djongo.JSONField()
    user_type = models_django.OneToOneField(UserType, on_delete=models_djongo.CASCADE)

class Review(models_django.Model):
    _id = models_djongo.ObjectIdField()
    userID = models_djongo.ForeignKey(User, on_delete=models_djongo.CASCADE)
    # accomodationID = models.ForeignKey(Accommodation, on_delete=models.CASCADE)
    dateSubmited = models_django.DateTimeField()
    title = models_django.CharField(max_length=255)
    rating = models_django.IntegerField()
    archived = models_django.BooleanField()
    body = models_django.TextField()

#################################################################
