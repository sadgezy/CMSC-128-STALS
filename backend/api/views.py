from django.shortcuts import render
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from django.contrib.auth import authenticate
from .serializers import *
from .models import *
from http import HTTPStatus
from rest_framework.authtoken.models import Token
from bson import ObjectId
from rest_framework import status

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
            'Endpoint' : '/signup/',
            'method' : 'GET',
            'body' : None,
            'description' : 'Creates a user that will be put in the database'
        },
         {
            'Endpoint' : '/login/',
            'method' : 'GET',
            'body' : None,
            'description' : 'Logins a user that exists in the database'
        },
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
            'Endpoint' : '/ticketdetails/',
            'method' : 'GET',
            'body' : None,
            'description' : 'Returns an array of tickets details'
        },
        {
            'Endpoint' : '/verifyuser/<str:pk>/',
            'method' : 'PUT',
            'body' : None,
            'description' : 'Changes the verification status of the user to true'
        },
        {
            'Endpoint' : '/unverifyuser/<str:pk>/',
            'method' : 'PUT',
            'body' : None,
            'description' : 'Changes the verification status of the user to false'
        },
        {
            'Endpoint' : '/deleteuser/<str:pk>/',
            'method' : 'DELETE',
            'body' : None,
            'description' : 'Changes the verification status of the user to false'
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

@api_view(['GET'])
def getticketdetails(request):
    ticket = Ticket.objects.all()
    serializer = ticketSerializer(ticket, many=True)
    return Response(serializer.data)

# @api_view(['GET'])
# def getaccommodationdetails(request):
#     accommodation = Accommodation.objects.all()
#     serializer = accommodationSerializer(accommodation, many=True)
#     return Response(serializer.data)

@api_view(['PUT'])
def adminverifyuser(request, pk):
    user = User.objects.get(pk=ObjectId(pk))
    user.verified = True  # Set the is_verified field to True
    user.save()  # Save the updated user instance to the database

    return Response(data={"message": "Successfully verified user"})

@api_view(['PUT'])
def adminunverifyuser(request, pk):
    user = User.objects.get(pk=ObjectId(pk))
    user.verified = False  # Set the is_verified field to True
    user.save()  # Save the updated user instance to the database

    return Response(data={"message": "Successfully unverified user"})

@api_view(['DELETE'])
def deleteuser(request, pk):
    user = User.objects.get(pk=ObjectId(pk))
    user.delete()
    
    return Response(data={"message": "Successfully deleted user"})

####################################################################

@api_view(['GET'])
def view_all_accommodation(request):
    accommodations = Accommodation.objects.all()
    serializer = AccommodationSerializer(accommodations, many=True)
    return Response(serializer.data)


@api_view(['GET'])
def view_accommodation(request, pk):
    try:
        accommodation = Accommodation.objects.get(pk=ObjectId(pk))
    except Accommodation.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    serializer = AccommodationSerializer(accommodation)
    return Response(serializer.data)


@api_view(['POST'])
def create_accommodation(request):

    serializer = AccommodationSerializer(data=request.data)

    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=201)
    
    return Response(data={"message": "Successfully created accommodation"})


@api_view(['DELETE'])
def delete_accommodation(request, pk):
    print("HELLO")
    try:
        accommodation = Accommodation.objects.get(pk=ObjectId(pk))
    except Accommodation.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    
    #if request.user != accommodation.owner:
    #    return Response({'error': '?'}, status=status.HTTP_401_UNAUTHORIZED)

    accommodation.delete()

    return Response(data={"message": "Successfully deleted accommodation"})


#--------------------------------------------------------------
#delete and move to different db na lang (?)                    #still doesnt work
@api_view(['PATCH'])                                            #PUT  
def archive_accommodation(request, pk):
    
    try:
        accommodation = Accommodation.objects.get(pk=ObjectId(pk))

        accommodation.is_archived = True
        accommodation.save()

        serializer = AccommodationSerializer(accommodation)
        return Response(serializer.data)

    except Accommodation.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    
    #accommodation = Accommodation.objects.get(pk=pk)
#--------------------------------------------------------------
