from rest_framework.decorators import api_view
from rest_framework.response import Response
from .serializers import *
from .models import *

# Create your views here.
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
    notes = Admin.objects.all()
    serializer = AdminSerializer(notes, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def getuserdetails(request):
    user = User.objects.all()
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

######################################################
