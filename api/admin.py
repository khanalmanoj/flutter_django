from django.contrib import admin
from .models import Food
from .models import Order
# Register your models here.
@admin.register(Food)
class FoodAdmin(admin.ModelAdmin):
    list_display = ['id','food_name','desc','time','image']

@admin.register(Order)
class OrderAdmin(admin.ModelAdmin):
    list_display = ['o_id','food', 'items', 'quantity','date_time']