# Generated by Django 5.0 on 2024-03-09 16:26

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0008_salesreport_date_salesreport_profit'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='salesreport',
            name='date',
        ),
        migrations.RemoveField(
            model_name='salesreport',
            name='profit',
        ),
    ]
