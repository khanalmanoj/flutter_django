from django.urls import path
from api import views
from api.views import OrderCreateView, OrderItemCreateView

urlpatterns = [
    path('food/', views.FoodListView.as_view()),
    path('order/', views.OrderListView.as_view()),
    path('orderitem/create/', OrderItemCreateView.as_view(), name='orderitem-create'),
    path('orders/create/', OrderCreateView.as_view(), name='order-create'),
]
