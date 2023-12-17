from django.db import models

# Create your models here.
class Food(models.Model):
    food_name = models.CharField(max_length=50)
    desc = models.TextField(max_length=500)
    time = models.CharField(max_length=50)
    image = models.ImageField(upload_to='images/', null=True, blank=True)