from rest_framework.serializers import ModelSerializer
from .models import *

class AdminSerializer(ModelSerializer):
    class Meta:
        model = Admin
        fields = '__all__'

class userSerializer(ModelSerializer):
    class Meta:
        model = User
        fields = '__all__'

class reviewSerializer(ModelSerializer):
    class Meta:
        model = Review
        fields = '__all__'

# class ticketSerializer(ModelSerializer):
#     class Meta:
#         model = Ticket
#         fields = '__all__'

# class accomodationSerializer(ModelSerializer):
#     class Meta:
#         model = Accommodation
#         fields = '__all__'

################################################################

