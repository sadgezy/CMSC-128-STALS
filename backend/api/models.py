from django.db import models as models_django
from django.contrib.auth.base_user import BaseUserManager
from django.contrib.auth.models import AbstractUser
from djongo import models as models_djongo
from rest_framework.authtoken.models import Token

# Create your models here.

class CustomUserManager(BaseUserManager):
    def create_user(self,email,first_name,last_name,middle_initial,suffix,phone_no,username,verified,id_type,id_picture,id_number,archived,tickets,user_type,establishments,reviews,favorites,password,**extra_fields):
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
            user_type=user_type,
            establishments=establishments,
            reviews = reviews,
            favorites = favorites,
            password = password,
            **extra_fields
        )

        user.set_password(password)
        user.save()

        return user

    def create_superuser(self,email,username,password,**extra_fields):
        extra_fields.setdefault("is_staff", True)
        extra_fields.setdefault("is_superuser", True)

        if extra_fields.get("is_staff") is not True:
            raise ValueError("Superuser has to have is_staff being True")

        if extra_fields.get("is_superuser") is not True:
            raise ValueError("Superuser has to have is_superuser being True")

        user=self.model(
            email = email,
            username=username,
            user_type="admin",
            **extra_fields
        )

        user.set_password(password)
        user.save()

        Token.objects.create(user=user)

        return user

class User(AbstractUser):
    _id = models_djongo.ObjectIdField()
    email=models_django.CharField(max_length=80,unique=True)
    first_name = models_djongo.CharField(max_length=100)
    last_name = models_django.CharField(max_length=100)
    middle_initial = models_django.CharField(max_length=100)
    suffix = models_django.CharField(max_length=10)
    phone_no = models_django.CharField(max_length=15)
    username=models_django.CharField(max_length=45)
    verified = models_django.BooleanField(default=False)
    id_type = models_django.CharField(max_length=50)
    id_picture = models_django.CharField(max_length=9999999)
    id_number = models_django.CharField(max_length=50)
    archived = models_django.BooleanField(default=False)
    tickets = models_djongo.JSONField(default=list)
    user_type = models_django.CharField(max_length=50)
    establishments = models_djongo.JSONField(default=list)
    reviews = models_djongo.JSONField(default=list)
    favorites = models_djongo.JSONField(default=list) 


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
    

class ReviewManager(models_django.Manager):
    def create_review(self,userID,establishmentID,dateSubmitted,title,rating,archived,body):
        # email=self.normalize_email(email)

        review=self.model(
            # _id=_id,
            userID=userID,
            establishmentID=establishmentID,
            dateSubmitted=dateSubmitted,
            title=title,
            rating=rating,
            archived=archived,
            body=body,
        )

        # I think it says in the docs that this isn't necessary when you're using a manager 
        review.save()

        return review

class Review(models_django.Model):
    # commented until functional
    _id = models_djongo.ObjectIdField()
    userID = models_django.CharField(max_length=25)
    establishmentID = models_django.CharField(max_length=25)
    dateSubmited = models_django.DateTimeField(auto_now_add=True)
    title = models_django.CharField(max_length=255)
    rating = models_django.IntegerField()
    archived = models_django.BooleanField(default=False)
    body = models_django.TextField()

    objects = ReviewManager()

    def __str__(self):
        return self.title


class EstablishmentManager(models_django.Manager):
    def create_establishment(self,name,owner,location_exact,location_approx,establishment_type,tenant_type,description,utilities,loc_picture,proof_type,proof_number,proof_picture,reviews,verified,archived,accommodations):
        # email=self.normalize_email(email)

        establishment=self.model(
            owner = owner,
            name = name,
            location_exact = location_exact,
            location_approx = location_approx,
            establishment_type = establishment_type,
            tenant_type = tenant_type,
            utilities = utilities,
            description = description,
            loc_picture = loc_picture,
            proof_type = proof_type,
            proof_number = proof_number,
            proof_picture = proof_picture,
            reviews = reviews,
            verified = verified,
            archived = archived,
            accommodations = accommodations
        )

        # I think it says in the docs that this isn't necessary when you're using a manager 
        establishment.save()

        return establishment


class Establishment(models_django.Model):
    # commented until functional
    # _id = models_djongo.ObjectIdField()
    # 
    # utilities 
    # photos
    _id = models_djongo.ObjectIdField()
    owner = models_django.CharField(max_length=25)
    name = models_django.CharField(max_length=255)
    location_exact = models_django.CharField(max_length=255)
    location_approx = models_django.CharField(max_length=255)
    establishment_type = models_django.CharField(max_length=255)
    tenant_type = models_django.CharField(max_length=255)
    utilities = models_djongo.JSONField(default=list)
    description = models_django.TextField()
    loc_picture = models_django.CharField(max_length=9999999)
    proof_type = models_django.CharField(max_length=255)
    proof_number = models_django.CharField(max_length=255)
    proof_picture = models_django.CharField(max_length=9999999)
    reviews = models_djongo.JSONField(default=list)
    verified = models_django.BooleanField(default=False)
    archived = models_django.BooleanField(default=False)
    accommodations = models_djongo.JSONField(default=list)

    objects = EstablishmentManager()

    def __str__(self):
        return self.name

class TicketManager(models_django.Manager):
    def create_ticket(self,user_id,establishment_id,date_submitted,tags,description,resolved):
        # email=self.normalize_email(email)

        ticket=self.model(
            user_id = user_id,
            establishment_id = establishment_id,
            date_submitted=date_submitted,
            tags = tags,
            description=description,
            resolved=resolved,
        )

        # I think it says in the docs that this isn't necessary when you're using a manager 
        ticket.save()

        return ticket

class Ticket(models_django.Model):
    _id = models_djongo.ObjectIdField()
    user_id = models_django.CharField(max_length=25)
    establishment_id = models_django.CharField(max_length=25)
    date_submitted = models_django.DateTimeField(auto_now_add=True)
    tags = models_djongo.JSONField(default=list)
    description = models_django.TextField()
    resolved = models_django.BooleanField(default=False)

    objects = TicketManager()

    def __str__(self):
        return self.description
    
class RoomManager(models_django.Manager):
    def create_room(self,availability,price_lower,price_upper,capacity,establishment_id):
        room=self.model(
            availability = availability,
            price_lower = price_lower,
            price_upper = price_upper,
            capacity = capacity,
            establishment_id = establishment_id
        )

        room.save()

        return room
    
class Room(models_django.Model):
    _id = models_djongo.ObjectIdField()
    availability = models_django.BooleanField()
    price_lower = models_django.IntegerField()
    price_upper = models_django.IntegerField()
    capacity = models_django.PositiveIntegerField()
    establishment_id = models_django.CharField(max_length=25)



# class Location(models.Model):
#     exact = models.CharField(max_length=255)
#     approx = models.CharField(max_length=255)

# class PriceRange(models.Model):
#     lower_bound = models.IntegerField()
#     upper_bound = models.IntegerField()

# class OwnershipProof(models.Model):
#     proof_type = models.CharField(max_length=255)
#     proof_number = models.CharField(max_length=255)
#     proof_picture = models.URLField()

# These two are supposed to be in arrayfield in establishment
# class Utility(models_django.Model):
#     name = models_django.CharField(max_length=255)
#     establishment = models_django.ForeignKey('establishment', on_delete=models_django.CASCADE, related_name='utilities')

# class Photo(models_django.Model):
#     url = models_django.URLField()
#     establishment = models_django.ForeignKey('establishment', on_delete=models_django.CASCADE, related_name='photos')

# class Review(models_django.Model):
#     # commented until functional
#     # _id = models_djongo.ObjectIdField()
#     # userID = models_django.ForeignKey('User', on_delete=models_django.CASCADE)
#     # establishmentID = models_django.ForeignKey('establishment', on_delete=models_django.CASCADE)
#     dateSubmitted = models_django.DateTimeField()
#     title = models_django.CharField(max_length=255)
#     rating = models_django.IntegerField()
#     archived = models_django.BooleanField()
#     body = models_django.TextField()