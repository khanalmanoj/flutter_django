# Generated by Django 5.0 on 2024-03-04 08:42

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0002_order_token'),
    ]

    operations = [
        migrations.RenameField(
            model_name='historyorderitem',
            old_name='food_name',
            new_name='name',
        ),
        migrations.RenameField(
            model_name='menuitem',
            old_name='food_name',
            new_name='name',
        ),
    ]
