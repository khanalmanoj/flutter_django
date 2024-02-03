from rest_framework import serializers
from .models import Food
from .models import Order
from .models import OrderItem
from .models import User

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['user_id','user_name','user_type']

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
    