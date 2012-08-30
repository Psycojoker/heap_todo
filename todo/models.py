from datetime import datetime
from django.db import models

class Todo(models.Model):
    title = models.CharField(max_length=255)
    done = models.BooleanField(default=False)
    created = models.DateTimeField(default=datetime.now)
    position = models.IntegerField()
    page = models.IntegerField()
