from django.db import models

# Create your models here.
class Food(models.Model):
    id = models.AutoField(primary_key=True)
    food_name = models.CharField(max_length=50)
    desc = models.TextField(max_length=500)
    price = models.IntegerField(default=0)
    time = models.CharField(max_length=50)
    image = models.ImageField(upload_to='images/', null=True, blank=True)

class Order(models.Model):
    o_id = models.AutoField(primary_key=True)
    food = models.ForeignKey(Food, on_delete=models.CASCADE)
    items = models.TextField(max_length=500)
    quantity = models.IntegerField(default=1)
    date_time = models.DateTimeField(auto_now_add=True, blank=True)



    


