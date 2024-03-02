from rest_framework import serializers
from .models import *
from rest_auth.registration.serializers import RegisterSerializer
from rest_auth.serializers import LoginSerializer
from rest_auth.serializers import UserDetailsSerializer


class NewRegisterSerializer(RegisterSerializer):
    pass

class NewLoginSerializer (LoginSerializer):
    pass

class UserSerializer(UserDetailsSerializer):
    is_staff = serializers.BooleanField()

    class Meta(UserDetailsSerializer.Meta):
        model = User  # Specify the custom User model
        fields = UserDetailsSerializer.Meta.fields + ('is_staff',)

class MenuItemSerializer(serializers.ModelSerializer):
    class Meta:
        model = MenuItem
        fields = "__all__"

class OrderItemSerializer(serializers.ModelSerializer):
    food_name = serializers.CharField(source='food.food_name', read_only=True)
    class Meta:
        model = OrderItem
        fields = "__all__"

class OrderSerializer(serializers.ModelSerializer):
    class Meta:
        model = Order
        fields = "__all__"


class HistoryOrderItemSerializer(serializers.ModelSerializer):
    class Meta:
        model = HistoryOrderItem
        fields = ['food_name', 'quantity']

class HistorySerializer(serializers.ModelSerializer):
    food_items_ordered = HistoryOrderItemSerializer(source='historyorderitem_set',many=True)

    class Meta:
        model = History
        fields = ['id', 'food_items_ordered', 'date', 'user', 'total_amount']


