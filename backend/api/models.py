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
    _id = models_djongo.ObjectIdField()
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
    

class ReviewManager(models_django.Manager):
    def create_review(self,dateSubmited,title,rating,archived,body):
        # email=self.normalize_email(email)

        review=self.model(
            #_id=_id,
            dateSubmited=dateSubmited,
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
    # _id = models_djongo.ObjectIdField()
    # userID = models_djongo.ForeignKey(User, on_delete=models_djongo.CASCADE)
    # accomodationID = models.ForeignKey(Accommodation, on_delete=models.CASCADE)
    dateSubmited = models_django.DateTimeField()
    title = models_django.CharField(max_length=255)
    rating = models_django.IntegerField()
    archived = models_django.BooleanField()
    body = models_django.TextField()

    objects = ReviewManager()

    def __str__(self):
        return self.title

    


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

# These two are supposed to be in arrayfield in accommodation
# class Utility(models_django.Model):
#     name = models_django.CharField(max_length=255)
#     accommodation = models_django.ForeignKey('Accommodation', on_delete=models_django.CASCADE, related_name='utilities')

# class Photo(models_django.Model):
#     url = models_django.URLField()
#     accommodation = models_django.ForeignKey('Accommodation', on_delete=models_django.CASCADE, related_name='photos')

# class Review(models_django.Model):
#     # commented until functional
#     # _id = models_djongo.ObjectIdField()
#     # userID = models_django.ForeignKey('User', on_delete=models_django.CASCADE)
#     # accommodationID = models_django.ForeignKey('Accommodation', on_delete=models_django.CASCADE)
#     dateSubmited = models_django.DateTimeField()
#     title = models_django.CharField(max_length=255)
#     rating = models_django.IntegerField()
#     archived = models_django.BooleanField()
#     body = models_django.TextField()


class AccommodationManager(models_django.Manager):
    def create_accommodation(self,name,exact,approx,accommodation_type,tenant_type,lower_bound,upper_bound,capacity,description,proof_type,proof_number,proof_picture,verified,archived):
        # email=self.normalize_email(email)

        accommodation=self.model(
            name = name,
            exact = exact,
            approx = approx,
            accommodation_type = accommodation_type,
            tenant_type = tenant_type,
            lower_bound = lower_bound,
            upper_bound = upper_bound,
            capacity = capacity,
            description = description,
            proof_type = proof_type,
            proof_number = proof_number,
            proof_picture = proof_picture,
            verified = verified,
            archived = archived,
        )

        # I think it says in the docs that this isn't necessary when you're using a manager 
        accommodation.save()

        return accommodation

class Accommodation(models_django.Model):
    # commented until functional
    # _id = models_djongo.ObjectIdField()
    # owner = models_django.ForeignKey('User', on_delete=models_django.CASCADE)
    name = models_django.CharField(max_length=255)
    # location = models.OneToOneField(Location, on_delete=models.CASCADE)
    exact = models_django.CharField(max_length=255)
    approx = models_django.CharField(max_length=255)
    accommodation_type = models_django.CharField(max_length=255)
    tenant_type = models_django.CharField(max_length=255)
    # price_range = models.OneToOneField(PriceRange, on_delete=models.CASCADE)
    lower_bound = models_django.IntegerField()
    upper_bound = models_django.IntegerField()
    capacity = models_django.PositiveIntegerField()
    description = models_django.TextField()
    # ownership_proof = models.OneToOneField(OwnershipProof, on_delete=models.CASCADE)\
    proof_type = models_django.CharField(max_length=255)
    proof_number = models_django.CharField(max_length=255)
    proof_picture = models_django.URLField()
    verified = models_django.BooleanField()
    archived = models_django.BooleanField()

    objects = AccommodationManager()

    def __str__(self):
        return self.name

class TicketManager(models_django.Manager):
    def create_ticket(self,date_submitted,description,resolved):
        # email=self.normalize_email(email)

        ticket=self.model(
            date_submitted=date_submitted,
            description=description,
            resolved=resolved,
        )

        # I think it says in the docs that this isn't necessary when you're using a manager 
        ticket.save()

        return ticket

class Ticket(models_django.Model):
    # commented until functional
    # _id = models_djongo.ObjectIdField()
    # user_id = models_django.ForeignKey('User', on_delete=models_django.CASCADE)
    date_submitted = models_django.DateTimeField(auto_now_add=True)
    # tags = models_djongo.ArrayField(models_django.CharField(max_length=255))
    description = models_django.TextField()
    resolved = models_django.BooleanField()

    objects = TicketManager()

    def __str__(self):
        return self.description