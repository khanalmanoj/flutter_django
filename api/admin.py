from django.contrib import admin
from .models import User
from .models import Food
from .models import OrderItem
from .models import Order
# Register your models here.
@admin.register(User)
class UserAdmin(admin.ModelAdmin):
    list_display = ['user_id','user_name','user_type']

@admin.register(Food)
class FoodAdmin(admin.ModelAdmin):
    list_display = ['id','food_name','desc','time','image']

@admin.register(OrderItem)
class OrderAdmin(admin.ModelAdmin):
    list_display = ['o_id','food','quantity']

@admin.register(Order)
class OrderAdmin(admin.ModelAdmin):
    list_display = ['user','order_id','date_time']