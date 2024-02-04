from rest_framework import serializers
from .models import Food
from .models import Order
from .models import OrderItem
from .models import User
from rest_auth.registration.serializers import RegisterSerializer
from rest_auth.serializers import LoginSerializer

class NewRegisterSerializer(RegisterSerializer):
    first_name = serializers.CharField()
    last_name = serializers.CharField()
    def custom_signup(self, request, user): 
        user.first_name = request.data['first_name']
        user.last_name = request.data['last_name']
        user.save()

class NewLoginSerializer (LoginSerializer):
    pass

# class UserSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = User
#         fields = ['user_id','user_name','user_type']

class FoodSerializer(serializers.ModelSerializer):
    class Meta:
        model = Food
        fields = ['id','food_name','desc','price','time','image']

class OrderItemSerializer(serializers.ModelSerializer):
    class Meta:
        model = OrderItem
        fields = ['food', 'quantity']

class OrderSerializer(serializers.ModelSerializer):
    class Meta:
        model = Order
        fields = ['user','date_time']
    