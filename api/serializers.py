from rest_framework import serializers
from .models import Food
from .models import Order
from .models import OrderItem
from .models import History
from .models import User
from rest_auth.registration.serializers import RegisterSerializer
from rest_auth.serializers import LoginSerializer

class NewRegisterSerializer(RegisterSerializer):
    pass

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
    user = serializers.CharField(source='order.user', read_only=True)
    total_amount = serializers.IntegerField(source='order.total', read_only=True)

    class Meta:
        model = History
        fields = ['id','user','total_amount','date', 'food_items_ordered']

    def get_food_items_ordered(self, obj):
        return [{'food_name': item.food.food_name, 'quantity': item.quantity} for item in obj.order_items.all()]
   