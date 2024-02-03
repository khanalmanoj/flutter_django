from .models import Food
from .serializers import FoodSerializer, OrderSerializer
from rest_framework.generics import ListAPIView
from .models import Order
from .serializers import OrderItemSerializer
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.generics import CreateAPIView
# Create your views here.

class FoodListView(ListAPIView):
    queryset = Food.objects.all()
    serializer_class = FoodSerializer

class OrderListView(ListAPIView):
    queryset = Order.objects.all()
    serializer_class = OrderItemSerializer

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        serializer = self.get_serializer(queryset, many=True)
        return Response(serializer.data)

class OrderItemCreateView(CreateAPIView):
   serializer_class = OrderItemSerializer

   def post(self, request, *args, **kwargs):
        serializer = OrderItemSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class OrderCreateView(CreateAPIView):
   serializer_class = OrderSerializer

   def post(self, request, *args, **kwargs):
        serializer = OrderSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
