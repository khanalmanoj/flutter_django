from django.contrib import admin
from . import models
from .models import MenuItem
from django.contrib.admin.sites import NotRegistered
from rest_framework.authtoken.models import Token
from rest_framework.authtoken.models import TokenProxy

# admin.site.unregister(TokenProxy)
# admin.site.unregister(Token)

@admin.register(models.User)
class UserAdmin(admin.ModelAdmin):
    list_display = ['id','username','is_staff']

@admin.register(MenuItem)
class FoodAdmin(admin.ModelAdmin):
    list_display = ['id','food_name','desc','time','image']

@admin.register(models.History)
class HistoryAdmin(admin.ModelAdmin):
    list_display = ['id','order','date']

@admin.register(models.HistoryOrderItem)
class HistoryOrderItemAdmin(admin.ModelAdmin):
    list_display = ['id','food_name','quantity']


admin.site.register(Token)
admin.site.unregister(Token)
