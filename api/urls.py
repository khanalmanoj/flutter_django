from django.urls import include, path 
from api import views

urlpatterns = [
    #url(r'^rest-auth/', include('rest_auth.urls')),
    path('auth/', include('rest_auth.urls')),
    path('auth/registration/', include('rest_auth.registration.urls')),
    path('user/', views.UserListView.as_view()),
    path('food/', views.MenuListView.as_view()),
    path('orderitem/', views.OrderItemViewSet.as_view({'get': 'list', 'post': 'create'}), name='orderitem-list'),
    path('order/', views.OrderListView.as_view()),
    path('addorder/', views.AddToOrder.as_view()),
    path('deleteitem/', views.DeleteOrderItem.as_view()),
    path('deleteorder/', views.DeleteOrder.as_view()),
    path('ordertoken/', views.GenerateOrderToken.as_view()),
    path('checkout/', views.Checkout.as_view()),
    path('history/', views.HistoryView.as_view()),
    path('allorders/', views.AllOrdersView.as_view()),
    path('sales/', views.sales_view, name='sales'),
    # path('orderitem/create/', OrderItemCreateView.as_view(), name='orderitem-create'),
    # path('orders/create/', OrderCreateView.as_view(), name='order-create'),
]
