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
def resubmit_verification_data(request, pk):
    user = User.objects.get(pk=ObjectId(pk))
    user.rejected = False  # Set the is_rejected field to True
    user.id_type = request.data['id_type']
    user.id_number = request.data['id_number']
    user.id_picture = request.data['id_picture']
    user.verified = False
    user.rejected = False
    user.save()

    return Response(data={"message": "Successfully resubmitted verification data"}) 

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
    # print(request.user)
    
    serializer = SignUpSerializer(data=request.data, many=False)
    
    if serializer.is_valid():
        serializer.save()
        #print(serializer.data)
        #user = User.objects.get(pk=ObjectId(serializer.data["_id"]))
        #print(check_password(request.data['password'], user.password))

        response = {"message": "User Created Successfully", "data": serializer.data}

        return Response(data=response, status=HTTPStatus.CREATED)
    
    return Response(data=serializer.errors, status=HTTPStatus.BAD_REQUEST)

@api_view(['GET'])
def get_all_user_info(request):
    user = User.objects.all()
    serializer = userSerializer(user, many=True)
    return Response(serializer.data)

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
        # print("Login Successful")

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
    serializer = userSerializer(user, many=True)
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
    serializer = EstablishmentWithoutImagesSerializer(establishments, many=True)
    return Response(serializer.data)

@api_view(['POST'])
def get_loc_picture(request):
    establishments = Establishment.objects.get(pk=ObjectId(request.data['_id']))
    serializer = EstablishmentLocPictureSerializer(establishments)
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

    # Fetch and delete all rooms associated with the establishment
    rooms_to_delete = Room.objects.filter(establishment_id=pk)
    rooms_to_delete.delete()

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
    req = {}
    req["capacity"] = int(request.data["capacity"])
    req["price_lower"] = int(request.data["price_lower"])
    req["price_upper"] = int(request.data["price_upper"])
    req["establishment_id"] = request.data["establishment_id"]
    serializer = RoomSerializer(data=req)
    
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
    # print(serializer.data)
    return Response(serializer.data)

@api_view(['POST'])
def resolve_ticket(request):
    ticket = Ticket.objects.get(pk=ObjectId(request.data["_id"]))
    ticket.resolved = True
    ticket.save()
    return Response(data={"message": "Successfully resolved report"})

@api_view(['POST'])
def delete_ticket(request):
    ticket = Ticket.objects.get(pk=ObjectId(request.data["_id"]))
    ticket.delete()
    return Response(data={"message": "Successfully deleted report"})

@api_view(['POST'])
def report_establishment(request): #can be used for other types of tickets
    req = {}
    req["tags"] = [request.data["tags"][2:-2]]
    req["user_id"] = request.data["user_id"]
    req["establishment_id"] = request.data["establishment_id"]
    req["description"] = request.data["description"]
    serializer = ticketSerializer(data=req)

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
@api_view(['POST'])
def getreviewdetails(request):
    estab = Establishment.objects.get(pk=ObjectId(request.data["establishment_id"]))
    review = Review.objects.filter(pk__in=[ObjectId(d) for d in estab.reviews])
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
            review = Review.objects.get(pk=ObjectId(serializer.data['_id']))
            review.delete()
            return Response(data={"message": "Establishment not found"}, status=status.HTTP_404_NOT_FOUND)
        
        estab.reviews.append(serializer.data['_id'])
        estab.save()

        user = User.objects.get(pk=ObjectId(serializer.data['user_id']))
        user.reviews.append(serializer.data['_id'])
        user.save()

        return Response(serializer.data, status=201)
    return Response(data={"message": "Failed creating a review"})

@api_view(['POST'])
def view_all_user_favorites(request):
    try:
        print(request.data['email'])
        user = User.objects.get(email=request.data['email'])
        serializer = userFavoritesSerializer(user)
        print(serializer.data["favorites"])
        return Response(serializer.data["favorites"])
    except Exception as e:
        print('%s' % type(e))
        return Response(data={"message": "Failed getting user favorites"})

@api_view(['POST'])
def add_room_to_user_favorites(request):
    try:
        user = User.objects.get(email=request.data['email'])
        User_serializer = userSerializer(user)
        # check if room is already in favorites)
        if request.data['ticket_id'] in user.favorites:
            user.favorites.remove(request.data['ticket_id'])
            user.save()
            return Response(data={"message": "Room already in user favorites"})
        else:
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

    #user_type = request.data.get('user_type')

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

    # if user_type == "user":
    #     available = [d for d in serializer.data if d['availability'] == True]
    #     return Response(available)
    # else:
    return Response(serializer.data)

#----------------------------------------------------------------------------------------------
@api_view(['POST'])
def search_establishment(request):
    # print(request.data)
    name = request.data.get('name', None)
    location_exact = request.data.get('location_exact', None)
    location_approx = request.data.get('location_approx')
    establishment_type = request.data.get('establishment_type', None)
    tenant_type = request.data.get('tenant_type', None)
    if (name == ''):
        name = None
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
    # print(establishments)
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

    if (price_lower == None and price_upper == None and capacity == None):
        actual_estab_results = [d for d in serializer_estab_full.data if str(d['_id']) in valid_estab_criteria]
    else:
        serializer_room = RoomSerializer(rooms, many=True)
        estab_ids = [d["establishment_id"] for d in serializer_room.data if d['availability'] == True and d['establishment_id'] in valid_estab_criteria]
        unique_estab_ids = list(dict.fromkeys(estab_ids))
        
        actual_estab_results = [d for d in serializer_estab_full.data if str(d['_id']) in unique_estab_ids]
    
    
    return Response(actual_estab_results)
    

@api_view(['GET'])
# @permission_classes([IsAuthenticated])
def view_all_users(request):
    user = User.objects.all()
    serializer = userWithoutImageSerializer(user, many=True)
    return Response(serializer.data)

@api_view(['GET'])
# @permission_classes([IsAuthenticated])
def view_all_users_verification_status(request):
    user = User.objects.all()
    serializer = userVerifiedStatusSerializer(user, many=True)
    return Response(serializer.data)

@api_view(['GET'])
# @permission_classes([IsAuthenticated])
def view_all_verified_users(request):                                         

    user = User.objects.all()
    serializer = userWithoutImageSerializer(user, many=True)
    query = [d for d in serializer.data if d['verified'] == True]
    return Response (query)

@api_view(['GET'])
# @permission_classes([IsAuthenticated])
def view_all_unverified_users(request):                                         

    user = User.objects.all()
    serializer = userWithoutImageSerializer(user, many=True)
    query = [d for d in serializer.data if d['verified'] == False]
    return Response (query)

@api_view(['GET'])
# @permission_classes([IsAuthenticated])
def view_all_archived_users(request):                                         

    user = User.objects.all()
    serializer = userWithoutImageSerializer(user, many=True)
    query = [d for d in serializer.data if d['archived'] == True]
    return Response (query)


@api_view(['GET'])
def view_all_modifUnverified_users(request):
    user = User.objects.all()
    serializer = userWithoutImageSerializer(user, many=True)
    query = [d for d in serializer.data if d['verified'] == False and d['archived'] == False and d['user_type'] !="admin"]
    return Response(query)

@api_view(['GET'])
def view_all_modifVerified_users(request):
    user = User.objects.all()
    serializer = userWithoutImageSerializer(user, many=True)
    query = [d for d in serializer.data if d['verified'] == True and d['archived'] == False and d['user_type'] !="admin"]
    return Response(query)

@api_view(['GET'])
def view_all_modifArchived_users(request):
    user = User.objects.all()
    serializer = userWithoutImageSerializer(user, many=True)
    #query = [d for d in serializer.data if d['archived'] == True and d['verified'] == True and d['user_type'] !="admin"]
    query = [d for d in serializer.data if d['archived'] == True and d['user_type'] !="admin"]
    return Response(query)

@api_view(['GET'])
def view_all_un_users(request):
    user = User.objects.all()
    serializer = userWithoutImageSerializer(user, many=True)
    query = [d for d in serializer.data if d['archived'] == False and d['verified'] == False and d['user_type'] !="admin"]
    return Response(query)


@api_view(['GET'])     
# @permission_classes([IsAuthenticated])                                                         
def view_all_verified_establishments(request):

    establishment = Establishment.objects.all()
    serializer = EstablishmentWithoutImagesSerializer(establishment, many=True)
    query = [d for d in serializer.data if d['verified'] == True]
    return Response (query)

@api_view(['GET'])
# @permission_classes([IsAuthenticated])
def view_all_archived_establishments(request):                                  
    
    establishment = Establishment.objects.all()
    serializer = EstablishmentWithoutImagesSerializer(establishment, many=True)
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

@api_view(['GET'])
def view_one_user(request, pk):
    try:
        user = User.objects.get(pk=ObjectId(pk))
    except User.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND, data={"message": "User not found"})

    serializer = userSerializer(user)
    return Response(serializer.data)


@api_view(['GET'])
def view_userOwned_establishments(request, pk):
    try:
        user = User.objects.get(pk=ObjectId(pk))
        # print('hi2')
        # print(user._id)
    except User.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND, data={"message": "User not found"})

    establishments = Establishment.objects.filter(owner=str(user._id))
    serializer = EstablishmentSerializer(establishments, many=True)

    # Include the accommodations and rooms in the response
    for establishment_data in serializer.data:
        establishment_id = establishment_data['_id']
        accommodations = establishment_data['accommodations']

        rooms = Room.objects.filter(establishment_id=str(establishment_id))
        room_serializer = RoomSerializer(rooms, many=True)
        establishment_data['accommodations'] = {
            'accommodations': accommodations,
            'rooms': room_serializer.data
        }

        # Print the rooms
        # print(f"Establishment ID: {establishment_id}")
        # print("Rooms:")
        # for room in room_serializer.data:
        #     room_id = room['_id']
        #     availability = room['availability']
        #     price_lower = room['price_lower']
        #     price_upper = room['price_upper']
        #     capacity = room['capacity']
        #     print(f"Room ID: {room_id}, Availability: {availability}, Price Range: {price_lower}-{price_upper}, Capacity: {capacity}")

    return Response(serializer.data)


@api_view(['DELETE'])
def delete_all_userOwned_establishments(request, pk):
    try:
        user = User.objects.get(pk=ObjectId(pk))
    except User.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND, data={"message": "User not found"})

    establishments = Establishment.objects.filter(owner=str(user._id))

    for establishment in establishments:
        establishment_id = establishment._id

        # Delete rooms
        rooms = Room.objects.filter(establishment_id=str(establishment_id))
        rooms.delete()

        # Remove the establishment from the owner's establishments list
        owner = User.objects.get(pk=ObjectId(establishment.owner))
        owner.establishments = [estab_id for estab_id in owner.establishments if estab_id != str(establishment._id)]
        owner.save()

        # Delete estab
        establishment.delete()

    return Response(data={"message": "All user-owned establishments and rooms have been deleted"})

######

@api_view(['POST'])
# @permission_classes([IsAuthenticated])
def set_reject_user(request):   

    try:
        user = User.objects.get(pk=ObjectId(request.data["_id"]))

    except User.DoesNotExist:
         return Response(data={"message": "User not found"}, status=status.HTTP_404_NOT_FOUND)

    if  (request.data["rejected"] == "True"):
        status = True
    else:
        status = False 
    user.rejected = status
    user.save()

    return Response(data={"message": "Successfully set reject status of user"})

@api_view(['POST'])
# @permission_classes([IsAuthenticated])
def set_reject_estab(request):   
    # print(request.data)
    try:
        estab = Establishment.objects.get(pk=ObjectId(request.data["_id"]))

    except Establishment.DoesNotExist:
         return Response(data={"message": "Establishment not found"}, status=status.HTTP_404_NOT_FOUND)

    if  (request.data["rejected"] == "True"):
        status = True
    else:
        status = False 
    estab.rejected = status
    estab.save()

    return Response(data={"message": "Successfully set reject status of establishment"})

@api_view(['POST'])
# @permission_classes([IsAuthenticated])
def add_new_proof_user(request):   
    try:
        user = User.objects.get(pk=ObjectId(request.data["_id"]))

    except User.DoesNotExist:
         return Response(data={"message": "User not found"}, status=status.HTTP_404_NOT_FOUND)

    user.id_type = request.data["id_type"]
    user.id_picture = request.data["id_picture"]
    user.id_number = request.data["id_number"]
    user.archived = False
    user.rejected = False
    user.save()

    return Response(data={"message": "Successfully add new proof for establishment"})


@api_view(['POST'])
# @permission_classes([IsAuthenticated])
def add_new_proof_estab(request):   
    try:
        estab = Establishment.objects.get(pk=ObjectId(request.data["_id"]))

    except Establishment.DoesNotExist:
         return Response(data={"message": "Establishment not found"}, status=status.HTTP_404_NOT_FOUND)

    estab.proof_type = request.data["proof_type"]
    estab.proof_number = request.data["proof_number"]
    estab.proof_picture = request.data["proof_picture"]
    estab.archived = False
    estab.rejected = False
    estab.save()

    return Response(data={"message": "Successfully add new proof for establishment"})

@api_view(['GET'])
# @permission_classes([IsAuthenticated])
def get_num_users(request):   
    count = User.objects.exclude(user_type="admin").count()
    

    return Response(data={"count": count})

@api_view(['GET'])
# @permission_classes([IsAuthenticated])
def get_total_login(request):   
    
    try:
        room = Room.objects.get(capacity=-999)
    except Room.DoesNotExist:
        Room.objects.create(capacity=-999, price_lower=1)
        return Response(data={"count": 1})
    
    return Response(data={"count": room.price_lower})

@api_view(['GET'])
# @permission_classes([IsAuthenticated])
def add_login(request):   
    #print("HELLO")
    try:
        room = Room.objects.get(capacity=-999)
    except Room.DoesNotExist:
        Room.objects.create(capacity=-999, price_lower=1)
        return Response(data={"count": 1})
    
    room.price_lower = room.price_lower+1
    #print(room.price_lower)
    room.save()
    
    return Response(data={"count": 1})