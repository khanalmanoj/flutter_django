from django.urls import path
from api import views
from api.views import OrderCreateView

urlpatterns = [
    path('food/', views.FoodListView.as_view()),
    path('order/', views.OrderListView.as_view()),
    path('orders/create/', OrderCreateView.as_view(), name='order-create'),
]
