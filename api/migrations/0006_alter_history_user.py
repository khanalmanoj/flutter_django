# Generated by Django 5.0 on 2024-03-06 10:36

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0005_rename_name_historyorderitem_food_name_and_more'),
    ]

    operations = [
        migrations.AlterField(
            model_name='history',
            name='user',
            field=models.CharField(max_length=50),
        ),
    ]