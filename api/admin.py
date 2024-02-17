from django.contrib import admin
from . import models
from .models import User
from .models import Food
from .models import OrderItem
from .models import Order
# Register your models here.
admin.site.register(models.User)

@admin.register(Food)
class FoodAdmin(admin.ModelAdmin):
    list_display = ['id','food_name','desc','time','image']

@admin.register(OrderItem)
class OrderAdmin(admin.ModelAdmin):
    list_display = ['id','food','quantity']

@admin.register(Order)
class OrderAdmin(admin.ModelAdmin):
    list_display = ['id','user','date_time']