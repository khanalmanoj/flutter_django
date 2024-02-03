from django.db import models

# Create your models here.
class User(models.Model):
    USER_TYPES = [
        ('Customer', 'Customer'),
        ('Admin', 'Admin'),
    ]
    user_id = models.AutoField(primary_key=True)
    user_name = models.CharField(max_length=255)
    user_type = models.CharField(max_length=20, choices=USER_TYPES)

class Food(models.Model):
    id = models.AutoField(primary_key=True)
    food_name = models.CharField(max_length=50)
    desc = models.TextField(max_length=500)
    price = models.IntegerField(default=0)
    time = models.CharField(max_length=50)
    image = models.ImageField(upload_to='images/', null=True, blank=True)

class OrderItem(models.Model):
    o_id = models.AutoField(primary_key=True)
    food = models.ForeignKey(Food, on_delete=models.CASCADE)
    quantity = models.IntegerField(default=1)
    
class Order(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    order_id = models.AutoField(primary_key=True)
    date_time = models.DateTimeField(auto_now_add=True)

class Bill(models.Model):
    bill_id = models.AutoField(primary_key=True)
    order = models.ForeignKey(Order, on_delete=models.CASCADE)
    total = models.IntegerField(default=0)   


    


