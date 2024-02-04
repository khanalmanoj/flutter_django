from django.urls import include, path 
from api import views
from api.views import OrderCreateView, OrderItemCreateView

urlpatterns = [
    #url(r'^rest-auth/', include('rest_auth.urls')),
    path('auth/', include('rest_auth.urls')),
    path('auth/registration/', include('rest_auth.registration.urls')),
    path('food/', views.FoodListView.as_view()),
    path('order/', views.OrderListView.as_view()),
    path('orderitem/create/', OrderItemCreateView.as_view(), name='orderitem-create'),
    path('orders/create/', OrderCreateView.as_view(), name='order-create'),
]
