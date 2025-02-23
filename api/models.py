from django.db import models
import uuid
from django.contrib.auth.models import AbstractUser

class User(AbstractUser):
    id = models.AutoField(primary_key=True)
    is_staff = models.BooleanField(default=False)      

class MenuItem(models.Model):
    CATEGORY_CHOICES = [
        ('Drinks', 'Drinks'),
        ('FoodItem', 'FoodItem'),
    ]
    food_name = models.CharField(max_length=50)
    desc = models.TextField(max_length=500)
    price = models.IntegerField(default=0)
    time = models.CharField(max_length=50)
    image = models.ImageField(upload_to='images/', null=True, blank=True)
    category = models.CharField(max_length=20, choices=CATEGORY_CHOICES)
    
class Order(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    token = models.CharField(max_length=100, blank=True)
    total = models.IntegerField(default=0)
    date_time = models.DateTimeField(auto_now_add=True)

    def generate_token(self):
        # Generate a new unique token using UUID every time
        return uuid.uuid4().hex

    def save(self, *args, **kwargs):
        # Generate and assign a new token before saving
        self.token = self.generate_token()
        super().save(*args, **kwargs)

class OrderItem(models.Model):
    order = models.ForeignKey(Order, on_delete=models.CASCADE,blank=True)
    food = models.ForeignKey(MenuItem, on_delete=models.CASCADE,blank=True)
    quantity = models.IntegerField(default=1)

class History(models.Model):
    order = models.ForeignKey(Order, on_delete=models.CASCADE)
    date = models.DateTimeField(auto_now_add=True)
    user = models.CharField(max_length=50)
    total_amount = models.IntegerField()

class HistoryOrderItem(models.Model):
    history = models.ForeignKey(History, on_delete=models.CASCADE)
    food_name = models.CharField(max_length=50)
    quantity = models.IntegerField()  

class SalesReport(models.Model):
    date = models.DateField(auto_now_add=True)
    revenue = models.IntegerField()
    totalusers = models.IntegerField()
    totalorders = models.IntegerField()
    
   


