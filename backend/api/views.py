from django.shortcuts import render
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from django.contrib.auth import authenticate
from .serializers import *
from .models import *
from http import HTTPStatus
from rest_framework.authtoken.models import Token

# Create your views here.
@api_view(['POST'])
def signup(request):
    print(request.user)
    
    serializer = SignUpSerializer(data=request.data, many=False)
    
    if serializer.is_valid():
        serializer.save()

        response = {"message": "User Created Successfully", "data": serializer.data}

        return Response(data=response, status=HTTPStatus.CREATED)

    return Response(data=serializer.errors, status=HTTPStatus.BAD_REQUEST)

@api_view(['POST'])
def login(request):
    email = request.data['email']
    password = request.data['password']

    user=authenticate(email=email, password=password)
  
    if user is not None:
        #Token.objects.create(user=user)
        response = {
            "message": "Login Succesful",
            "token": user.auth_token.key
        }
        print("Login Successful")

        return Response(data=response, status=HTTPStatus.OK)

    else:
        return Response(data={"message": "Invalid email or password"})
    
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def check_authenticated(request):

    return Response(data={"message":"isAuthenticated"})

@api_view(['GET'])
def getRoutes(request):
    routes = [
        {
            'Endpoint' : '/admindetails/',
            'method' : 'GET',
            'body' : None,
            'description' : 'Returns an array of admin details'
        },
        {
            'Endpoint' : '/userdetails/',
            'method' : 'GET',
            'body' : None,
            'description' : 'Returns an array of user details'
        },
        {
            'Endpoint' : '/reviewdetails/',
            'method' : 'GET',
            'body' : None,
            'description' : 'Returns an array of review details'
        },
        {
            'Endpoint' : '/verifyuser/<str:pk>/update/',
            'method' : 'GET',
            'body' : None,
            'description' : 'Changes the verification status of the user'
        },
    ]
    return Response(routes)

@api_view(['GET'])
def getadmindetails(request):
    notes = User.objects.filter(type="admin").values()
    return Response(notes)

@api_view(['GET'])
def getuserdetails(request):
    user = User.objects.filter(type="user")
    serializer = userSerializer(user, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def getreviewdetails(request):
    review = Review.objects.all()
    serializer = reviewSerializer(review, many=True)
    return Response(serializer.data)


# not working as intended
@api_view(['PUT'])
def adminverifyuser(request, pk):
    user = User.objects.get(id=pk)
    user.verified = True  # Set the is_verified field to True
    user.save()  # Save the updated user instance to the database

    serializer = userSerializer(user)
    return Response(serializer.data)
