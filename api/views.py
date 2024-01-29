from .models import Food
from .serializers import FoodSerializer
from rest_framework.generics import ListAPIView
# Create your views here.

class FoodListView(ListAPIView):
    queryset = Food.objects.all()
    serializer_class = FoodSerializer