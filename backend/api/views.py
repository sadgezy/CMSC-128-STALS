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
import json
from django.contrib.auth.hashers import check_password, make_password

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
    admin = User.objects.filter(user_type="admin")
    serializer = userSerializer(admin, many=True)
    return Response(serializer.data)


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
def admindeletereview(request, pk):
    review = Review.objects.get(pk=ObjectId(pk))
    review.delete()
    
    return Response(data={"message": "Successfully deleted review"})

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
        #print(serializer.data)
        #user = User.objects.get(pk=ObjectId(serializer.data["_id"]))
        #print(check_password(request.data['password'], user.password))

        response = {"message": "User Created Successfully", "data": serializer.data}

        return Response(data=response, status=HTTPStatus.CREATED)

    return Response(data=serializer.errors, status=HTTPStatus.BAD_REQUEST)

@api_view(['POST'])
def login(request):
    email = request.data['email']
    password = request.data['password']

    user = User.objects.get(email=email)
    if (not check_password(password, user.password)):
        user = None
    #user=authenticate(email=email, password=password)
    #user = User.objects.get(email=email)
    #if (user.password != password):
    #    user = None
    
  
    if user is not None:
        
        #Token.objects.create(user=user)
        response = {
            "message": "Login Successful",
            "token": user.auth_token.key
        }
        print("Login Successful")

        return Response(data=response, status=HTTPStatus.OK)

    else:
        return Response(data=request.data)
    
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
    user = User.objects.filter(user_type="user")
    serializer = userSerializer(user, many=True)
    return Response(serializer.data)

@api_view(['POST'])
def get_one_user(request):
    user = User.objects.filter(email=request.data['email'])
    serializer = LimitedUserSerializer(user, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def get_one_user_using_id(request, pk):
    user = User.objects.get(pk=ObjectId(pk))
    serializer = userSerializer(user, many=False)
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
        establishment = Establishment.objects.get(pk=ObjectId(pk))
    except Establishment.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND, data={"message": "Establishment not found"})
    serializer = EstablishmentSerializer(establishment)
    return Response(serializer.data)


@api_view(['POST'])
def create_establishment(request):

    serializer = EstablishmentSerializer(data=request.data)

    if serializer.is_valid():
        try:
            serializer.save()
            owner = User.objects.get(pk=ObjectId(serializer.data['owner']))
        except User.DoesNotExist:
            estab = Establishment.objects.get(pk=ObjectId(serializer.data['_id']))
            estab.delete()
            return Response(data={"message": "Owner not found"}, status=status.HTTP_404_NOT_FOUND)
        
        owner.establishments.append(serializer.data['_id'])
        owner.save()

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
    estab = EstablishmentSerializer(establishment)
    estab_json_accom = eval(estab.data['accommodations'])
    for i in estab_json_accom:
        try:
            room = Room.objects.get(pk=ObjectId(i))
            room.delete()
        except:
            return Response(data={"message":"Failure deleting a room"})

    owner = User.objects.get(pk=ObjectId(estab.data['owner']))
    owner.establishments.remove(estab.data['_id'])
    owner.save()

    establishment.delete()

    return Response(data={"message": "Successfully deleted establishment"})

@api_view(['PUT'])
def edit_establishment(request, pk):

    estab = Establishment.objects.get(pk=ObjectId(pk))
    estab.name = request.data['name']
    estab.location_exact = request.data['location_exact']
    estab.location_approx = request.data['location_approx']
    estab.establishment_type = request.data['establishment_type']
    estab.tenant_type = request.data['tenant_type']
    estab.description = request.data['description']
    estab.save()

    return Response(data={"message": "Successfully edited establishment"})

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
def unverify_establishment(request, pk):

    try:
        accom = Establishment.objects.get(pk=ObjectId(pk))
    except Establishment.DoesNotExist:
         return Response(data={"message": "Establishment not found"}, status=status.HTTP_404_NOT_FOUND)
    
    accom.verified = False
    accom.save()

    return Response(data={"message": "Successfully unverified establishment"})


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

@api_view(['PUT'])
def unarchive_establishment(request, pk):   

    try:
        accom = Establishment.objects.get(pk=ObjectId(pk))
    except Establishment.DoesNotExist:
         return Response(data={"message": "Establishment not found"}, status=status.HTTP_404_NOT_FOUND)
        
    
    #Establishment.price = Decimal(str(Establishment.price))

    accom.archived = False
    accom.save()

    return Response(data={"message": "Successfully unarchived establishment"})

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

@api_view(['PUT'])
def edit_room(request, pk):

    estab = Room.objects.get(pk=ObjectId(pk))
    estab.availability = request.data['availability']
    estab.price_lower = request.data['price_lower']
    estab.price_upper = request.data['price_upper']
    estab.capacity = request.data['capacity']
    estab.save()

    return Response(data={"message": "Successfully edited room"})

@api_view(['DELETE'])
def delete_room(request, pk):
    try:
        room = Room.objects.get(pk=ObjectId(pk))
    except Room.DoesNotExist:
        return Response(data={"message": "Room not found"}, status=status.HTTP_404_NOT_FOUND)

    room_serial = RoomSerializer(room)
    estab = Establishment.objects.get(pk=ObjectId(room_serial.data['establishment_id']))

    estab.accommodations.remove(room_serial.data["_id"])
    estab.save()
    #if request.user != establishment.owner:
    #    return Response({'error': '?'}, status=status.HTTP_401_UNAUTHORIZED)

    room.delete()

    return Response(data={"message": "Successfully deleted room"})

# TICKET ACTIONS

@api_view(['GET'])
def getticketdetails(request):
    ticket = Ticket.objects.all()
    serializer = ticketSerializer(ticket, many=True)
    return Response(serializer.data)

@api_view(['POST'])
def report_establishment(request): #can be used for other types of tickets
    serializer = ticketSerializer(data=request.data)

    if serializer.is_valid():
        try:
            serializer.save()
            user = User.objects.get(pk=ObjectId(serializer.data['user_id']))
            estab = Establishment.objects.get(pk=ObjectId(serializer.data['establishment_id']))
        except User.DoesNotExist or Establishment.DoesNotExist:
            ticket = Ticket.objects.get(pk=ObjectId(serializer.data['_id']))
            ticket.delete()
            return Response(data={"message": "User or establishment not found"}, status=status.HTTP_404_NOT_FOUND)

        user.tickets.append(serializer.data['_id'])
        user.save()

        return Response(serializer.data, status=201)

    return Response(data={"message": "Failed creating ticket"})

# REVIEW ACTIONS

# takes the list of reviews and requests them
@api_view(['GET'])
def getreviewdetails(request):
    review = Review.objects.all()
    serializer = reviewSerializer(review, many=True)
    return Response(serializer.data)

#writereview
@api_view(['POST'])
def review_establishment(request):
    serializer = reviewSerializer(data = request.data)
    if serializer.is_valid():
        try:
            serializer.save()
            estab = Establishment.objects.get(pk=ObjectId(serializer.data['establishment_id']))
        except Establishment.DoesNotExist:
            review = Review.objects.get(pk=ObjectId(serializer.data['review_id']))
            review.delete()
            return Response(data={"message": "Establishment not found"}, status=status.HTTP_404_NOT_FOUND)
        
        estab.append(serializer.data['_id'])
        estab.save()

        return Response(serializer.data, status=201)
    return Response(data={"message": "Failed creating a review"})

@api_view(['POST'])
def view_all_user_favorites(request):
    try:
        user = User.objects.filter(email=request.data['email'])
        serializer = userSerializer(user, many=True)
        return Response(serializer.data[0]['favorites'])
    except:
        return Response(data={"message": "Failed getting user favorites"})

@api_view(['POST'])
def add_room_to_user_favorites(request):
    try:
        user = User.objects.get(email=request.data['email'])
        User_serializer = userSerializer(user)
        user.favorites.append(request.data['ticket_id'])
        user.save()  # Make sure you're saving an instance of User model, not a regular user object
        return Response(data={"message": "Successfully added to user favorites"})
    except User.DoesNotExist:
        # Handle the case when the user doesn't exist
        return Response("User not found", status=status.HTTP_404_NOT_FOUND)
    
    # return Response(user)
    # except:
    #     return Response(data={"message": "Error adding to user favorites"})

#deletereview(on admin)

#----------------------------------------------------------------------------------------------
@api_view(['POST'])
def search_room(request):
    establishment_id = request.data.get('establishment_id')
    price_lower = request.data.get('price_lower')
    price_upper = request.data.get('price_upper')
    capacity = request.data.get('capacity')

    rooms = Room.objects.all()

    if establishment_id:
        rooms = rooms.filter(establishment_id=establishment_id)
    if price_lower:
            rooms = rooms.filter(price_lower__gte=price_lower)              #recheck gte or lte
    if price_upper:
            rooms = rooms.filter(price_upper__lte=price_upper)
    if capacity:
        rooms = rooms.filter(capacity=capacity)

    serializer = RoomSerializer(rooms, many=True)

    available = [d for d in serializer.data if d['availability'] == True]
    return Response(available)

#----------------------------------------------------------------------------------------------
@api_view(['POST'])
def search_establishment(request):
    print(request.data)
    name = request.data.get('name', None)
    location_exact = request.data.get('location_exact', None)
    location_approx = request.data.get('location_approx')
    establishment_type = request.data.get('establishment_type', None)
    tenant_type = request.data.get('tenant_type', None)
    if (location_exact == ''):
        location_exact = None
    if (location_approx == ''):
        location_approx = None
    if (establishment_type == ''):
        establishment_type = None
    if (tenant_type == ''):
        tenant_type = None

    #print(name,location_exact,location_approx,establishment_type,tenant_type)
    establishments = Establishment.objects.all()
    establishments_copy = establishments

    if name:
        establishments = establishments.filter(name__icontains=name)
        
    if location_approx:
        establishments = establishments.filter(location_approx=location_approx)

    if location_exact:
        establishments = establishments.filter(location_exact__icontains=location_exact)

    if establishment_type:
        establishments = establishments.filter(establishment_type__icontains=establishment_type)

    if tenant_type:
        establishments = establishments.filter(tenant_type__icontains=tenant_type)

    serializer_estab = EstablishmentSerializer(establishments, many=True)
    serializer_estab_full = EstablishmentSerializer(establishments_copy, many=True)

    not_archived = [d for d in serializer_estab.data if d['archived'] == False]
    verified = [d for d in not_archived if d['verified'] == True]
    valid_estab_criteria = [d['_id'] for d in verified]
    
    price_lower = request.data.get('price_lower')
    price_upper = request.data.get('price_upper')
    capacity = request.data.get('capacity')

    if (price_lower ==  ''):
        price_lower = None
    if (price_upper == ''):
        price_upper = None
    if (capacity == ''):
        capacity = None
    

    rooms = Room.objects.all()
    
    if price_lower:
        price_lower = eval(price_lower)
        rooms = rooms.filter(price_lower__gte=price_lower)              #recheck gte or lte
    if price_upper:
        price_upper = eval(price_upper)
        rooms = rooms.filter(price_upper__lte=price_upper)
    if capacity:
        capacity = eval(capacity)
        rooms = rooms.filter(capacity=capacity)

    serializer_room = RoomSerializer(rooms, many=True)
    print(serializer_room.data)
    estab_ids = [d["establishment_id"] for d in serializer_room.data if d['availability'] == True and d['establishment_id'] in valid_estab_criteria]
    unique_estab_ids = list(dict.fromkeys(estab_ids))
    
    actual_estab_results = [d for d in serializer_estab_full.data if str(d['_id']) in unique_estab_ids]
    
    return Response(actual_estab_results)
    

@api_view(['GET'])
# @permission_classes([IsAuthenticated])
def view_all_users(request):
    user = User.objects.all()
    serializer = userSerializer(user, many=True)
    return Response(serializer.data)

@api_view(['GET'])
# @permission_classes([IsAuthenticated])
def view_all_verified_users(request):                                         

    user = User.objects.all()
    serializer = userSerializer(user, many=True)
    query = [d for d in serializer.data if d['verified'] == True]
    return Response (query)

@api_view(['GET'])
# @permission_classes([IsAuthenticated])
def view_all_unverified_users(request):                                         

    user = User.objects.all()
    serializer = userSerializer(user, many=True)
    query = [d for d in serializer.data if d['verified'] == False]
    return Response (query)

@api_view(['GET'])
# @permission_classes([IsAuthenticated])
def view_all_archived_users(request):                                         

    user = User.objects.all()
    serializer = userSerializer(user, many=True)
    query = [d for d in serializer.data if d['archived'] == True]
    return Response (query)

@api_view(['GET'])     
# @permission_classes([IsAuthenticated])                                                         
def view_all_verified_establishments(request):

    establishment = Establishment.objects.all()
    serializer = EstablishmentSerializer(establishment, many=True)
    query = [d for d in serializer.data if d['verified'] == True]
    return Response (query)

@api_view(['GET'])
# @permission_classes([IsAuthenticated])
def view_all_archived_establishments(request):                                  
    
    establishment = Establishment.objects.all()
    serializer = EstablishmentSerializer(establishment, many=True)
    query = [d for d in serializer.data if d['archived'] == True]
    return Response (query)


@api_view(['PUT'])
# @permission_classes([IsAuthenticated])
def archive_user(request, pk):   

    try:
        user = User.objects.get(pk=ObjectId(pk))

    except User.DoesNotExist:
         return Response(data={"message": "User not found"}, status=status.HTTP_404_NOT_FOUND)

    user.archived = True
    user.save()

    return Response(data={"message": "Successfully archived user"})


@api_view(['PUT'])
# @permission_classes([IsAuthenticated])
def unarchive_user(request, pk):   

    try:
        user = User.objects.get(pk=ObjectId(pk))

    except User.DoesNotExist:
         return Response(data={"message": "User not found"}, status=status.HTTP_404_NOT_FOUND)

    user.archived = False
    user.save()

    return Response(data={"message": "Successfully unarchived user"})