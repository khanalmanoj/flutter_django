# Generated by Django 5.0 on 2024-03-09 16:31

import django.utils.timezone
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0009_remove_salesreport_date_remove_salesreport_profit'),
    ]

    operations = [
        migrations.AddField(
            model_name='salesreport',
            name='date',
            field=models.DateField(auto_now_add=True, default=django.utils.timezone.now),
            preserve_default=False,
        ),
    ]
