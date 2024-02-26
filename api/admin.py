from django.contrib import admin
from . import models
from .models import User
from .models import MenuItem
from .models import OrderItem
from .models import Order
# Register your models here.
@admin.register(models.User)
class UserAdmin(admin.ModelAdmin):
    list_display = ['id','username','email','is_staff']

@admin.register(MenuItem)
class FoodAdmin(admin.ModelAdmin):
    list_display = ['id','food_name','desc','time','image']

@admin.register(Order)
class OrderAdmin(admin.ModelAdmin):
    list_display = ['id','user','date_time']

@admin.register(OrderItem)
class OrderAdmin(admin.ModelAdmin):
    list_display = ['id','food','quantity']

@admin.register(models.History)
class HistoryAdmin(admin.ModelAdmin):
    list_display = ['id','order','date']