from rest_framework import serializers
from .models import Food
from .models import Order

class FoodSerializer(serializers.ModelSerializer):
    class Meta:
        model = Food
        fields = ['id','food_name','desc','price','time','image']

class OrderSerializer(serializers.ModelSerializer):
    class Meta:
        model = Order
        fields = ['food', 'items', 'quantity']