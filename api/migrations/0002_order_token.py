# Generated by Django 5.0 on 2024-03-02 09:00

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='order',
            name='token',
            field=models.CharField(blank=True, max_length=100),
        ),
    ]