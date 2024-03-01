from rest_framework import serializers
from .models import *
from rest_auth.registration.serializers import RegisterSerializer
from rest_auth.serializers import LoginSerializer


class NewRegisterSerializer(RegisterSerializer):
    pass

class NewLoginSerializer (LoginSerializer):
    pass

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'is_staff']

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


# class HistorySerializer(serializers.ModelSerializer):
#     food_items_ordered = serializers.SerializerMethodField()
#     user = serializers.IntegerField(source='order.user.id', read_only=True)
#     total_amount = serializers.IntegerField(source='order.total', read_only=True)

#     class Meta:
#         model = History
#         fields = ['id','user','total_amount','date', 'food_items_ordered']

#     def get_food_items_ordered(self, obj):
#         return [{'food_name': item.food.food_name, 'quantity': item.quantity} for item in obj.order_items.all()]