from django.db import models
from django.contrib.auth.models import AbstractUser

class User(AbstractUser):
    id = models.AutoField(primary_key=True)

class Food(models.Model):
    food_name = models.CharField(max_length=50)
    desc = models.TextField(max_length=500)
    price = models.IntegerField(default=0)
    time = models.CharField(max_length=50)
    image = models.ImageField(upload_to='images/', null=True, blank=True)
    
class Order(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    total = models.IntegerField(default=0)
    date_time = models.DateTimeField(auto_now_add=True)

class OrderItem(models.Model):
    order = models.ForeignKey(Order, on_delete=models.CASCADE,blank=True)
    food = models.ForeignKey(Food, on_delete=models.CASCADE,blank=True)
    quantity = models.IntegerField(default=1)

class History(models.Model):
    orders = models.ForeignKey(Order, on_delete=models.CASCADE)
    total_amount = models.IntegerField()
    food_items = models.ManyToManyField(OrderItem)
    date = models.DateTimeField(auto_now_add=True)

class Bill(models.Model):
    order = models.ForeignKey(Order, on_delete=models.CASCADE)
    total = models.IntegerField(default=0)



    


