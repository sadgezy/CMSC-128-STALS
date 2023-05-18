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
from decimal import Decimal
from rest_framework import status

# Create your views here.

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

#ADMIN ACTIONS

@api_view(['GET'])
def getadmindetails(request):
    notes = User.objects.filter(type="admin").values()
    return Response(notes)

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

#USER ACTIONS

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
    
@api_view(['PUT'])
def editProfile(request, pk):

    user = User.objects.get(pk=ObjectId(pk))
    user.first_name = request.data['first_name']
    user.last_name = request.data['last_name']
    user.middle_initial = request.data['middle_initial']
    user.suffix = request.data['suffix']
    user.phone_no = request.data['phone_no']
    user.username = request.data['username'] # Set the is_verified field to True
    user.save()

    return Response(data={"message": "Successfully edited user profile"})
    
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def check_authenticated(request):

    return Response(data={"message":"isAuthenticated"})


@api_view(['GET'])
def getuserdetails(request):
    user = User.objects.filter(type="user")
    serializer = userSerializer(user, many=True)
    return Response(serializer.data)


# @api_view(['GET'])
# def getestablishmentdetails(request):
#     establishment = establishment.objects.all()
#     serializer = establishmentSerializer(establishment, many=True)
#     return Response(serializer.data)


####################################################################
# ESTABLISHMENT ACTIONS

@api_view(['GET'])
def view_all_establishment(request):
    establishments = Establishment.objects.all()
    serializer = EstablishmentSerializer(establishments, many=True)
    return Response(serializer.data)


@api_view(['GET'])
def view_establishment(request, pk):
    try:
        establishment = establishment.objects.get(pk=ObjectId(pk))
    except establishment.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    serializer = EstablishmentSerializer(establishment)
    return Response(serializer.data)


@api_view(['POST'])
def create_establishment(request):

    serializer = EstablishmentSerializer(data=request.data)

    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=201)
    
    return Response(data={"message": "Failed creating establishment"})


@api_view(['DELETE'])
def delete_establishment(request, pk):
    try:
        establishment = Establishment.objects.get(pk=ObjectId(pk))
    except Establishment.DoesNotExist:
        return Response(data={"message": "Establishment not found"}, status=status.HTTP_404_NOT_FOUND)

    
    #if request.user != establishment.owner:
    #    return Response({'error': '?'}, status=status.HTTP_401_UNAUTHORIZED)

    establishment.delete()

    return Response(data={"message": "Successfully deleted establishment"})


@api_view(['PUT'])
def verify_establishment(request, pk):

    try:
        accom = Establishment.objects.get(pk=ObjectId(pk))
    except Establishment.DoesNotExist:
         return Response(data={"message": "Establishment not found"}, status=status.HTTP_404_NOT_FOUND)
    
    accom.verified = True
    accom.save()

    return Response(data={"message": "Successfully verified establishment"})

@api_view(['PUT'])
def archive_establishment(request, pk):   

    try:
        accom = Establishment.objects.get(pk=ObjectId(pk))
    except Establishment.DoesNotExist:
         return Response(data={"message": "Establishment not found"}, status=status.HTTP_404_NOT_FOUND)
        
    
    #Establishment.price = Decimal(str(Establishment.price))

    accom.archived = True
    accom.save()

    return Response(data={"message": "Successfully archived establishment"})

# ROOM ACTIONS

@api_view(['POST'])
def add_room_to_establishment(request):

    serializer = RoomSerializer(data=request.data)

    if serializer.is_valid():
        try:
            serializer.save()
            estab = Establishment.objects.get(pk=ObjectId(serializer.data['establishment_id']))
        except Establishment.DoesNotExist:
            room = Room.objects.get(pk=ObjectId(serializer.data['_id']))
            room.delete()
            return Response(data={"message": "Establishment not found"}, status=status.HTTP_404_NOT_FOUND)
        
        estab.accommodations.append(serializer.data['_id'])
        estab.save()

        #serializer2 = EstablishmentSerializer(estab)
        #return Response(data={"message": "Successfully added room to establishment", "room": serializer.data, "establishment": serializer2.data})
        return Response(data={"message": "Successfully added room to establishment"}, status=201)
    
    return Response(data={"message": "Failed adding room to establishment"})

# TICKET ACTIONS

# REVIEW ACTIONS

# takes the list of reviews and requests them
@api_view(['GET'])
def getreviewdetails(request):
    review = Review.objects.all()
    serializer = reviewSerializer(review, many=True)
    return Response(serializer.data)

#writereview

#deletereview(on admin)

#writeticket

#flagticket(on admin) 
@api_view(['GET'])
def getticketdetails(request):
    ticket = Ticket.objects.all()
    serializer = ticketSerializer(ticket, many=True)
    return Response(serializer.data)
