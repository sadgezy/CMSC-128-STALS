from rest_framework import serializers
from .models import *
from rest_framework.validators import ValidationError
from rest_framework.authtoken.models import Token

class SignUpSerializer(serializers.ModelSerializer):
    email = serializers.CharField(max_length=80)
    password = serializers.CharField(min_length=8, write_only=True)
    first_name = serializers.CharField(max_length=100)
    last_name = serializers.CharField(max_length=100)
    middle_initial = serializers.CharField(max_length=1, required=False)
    suffix = serializers.CharField(max_length=10, required=False)
    phone_no = serializers.CharField(max_length=15)
    username=serializers.CharField(max_length=45)
    verified = serializers.BooleanField(default=False)
    id_type = serializers.CharField(max_length=50, required=False)
    id_picture = serializers.URLField(required=False)
    id_number = serializers.CharField(max_length=50, required=False)
    archived = serializers.BooleanField(default=False)
    tickets = serializers.JSONField(default=list)
    type = serializers.CharField(max_length=50)
    accommodations = serializers.JSONField(default=list)

    class Meta:
        model = User
        fields = ["email", "username", "password","first_name","last_name","middle_initial","suffix","phone_no","verified","id_type","id_picture","id_number", "archived", "tickets", "type", "accommodations"]

    def validate(self, attrs):

        email_exists = User.objects.filter(email=attrs["email"]).exists()

        if email_exists:
            raise ValidationError("Email has already been used")

        return super().validate(attrs)

    def create(self, validated_data):
        password = validated_data.pop("password")

        user = super().create(validated_data)

        user.set_password(password)

        user.save()

        Token.objects.create(user=user)

        return user

class userSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = '__all__'

class reviewSerializer(serializers.ModelSerializer):
    class Meta:
        model = Review
        fields = '__all__'