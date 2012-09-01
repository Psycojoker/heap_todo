from datetime import datetime
from django.db import models

class Todo(models.Model):
    title = models.CharField(max_length=255)
    done = models.BooleanField(default=False)
    created = models.DateTimeField(default=datetime.now, editable=False)
    position = models.PositiveIntegerField(null=True)
    page = models.IntegerField()

    @classmethod
    def get_home_page(klass):
        home_page = klass.objects.filter(position__isnull=False)[:10]
        if all(map(lambda x: x.done, home_page)):
            for i in home_page:
                i.position = None
                print "caca"
                i.save()

        # can't slice here, otherwise I would broke djangbone
        # I slice in the backbone view at the good time
        return klass.objects.filter(position__isnull=False)

    class Meta:
        ordering = ["position"]
