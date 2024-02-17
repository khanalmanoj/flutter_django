from rest_framework import serializers
from .models import Food
from .models import Order
from .models import OrderItem
from .models import History
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

class FoodSerializer(serializers.ModelSerializer):
    class Meta:
        model = Food
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

class HistorySerializer(serializers.ModelSerializer):
    food_items_ordered = serializers.SerializerMethodField()

    class Meta:
        model = History
        fields = ['id', 'total_amount','date', 'food_items_ordered']

    def get_food_items_ordered(self, obj):
        return [{'food_name': item.food.food_name, 'quantity': item.quantity} for item in obj.food_items.all()]
   