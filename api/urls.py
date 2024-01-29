from django.urls import path
from api import views

urlpatterns = [
    path('food/', views.FoodListView.as_view()),
]
