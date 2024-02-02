from .models import Food
from .serializers import FoodSerializer
from rest_framework.generics import ListAPIView
from .models import Order
from .serializers import OrderSerializer
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
# Create your views here.

class FoodListView(ListAPIView):
    queryset = Food.objects.all()
    serializer_class = FoodSerializer

class OrderListView(ListAPIView):
    queryset = Order.objects.all()
    serializer_class = OrderSerializer

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        serializer = self.get_serializer(queryset, many=True)
        return Response(serializer.data)

class OrderCreateView(APIView):
    def post(self, request, *args, **kwargs):
        serializer = OrderSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
