from datetime import datetime
from django.db import models

class Todo(models.Model):
    title = models.CharField(max_length=255)
    done = models.BooleanField(default=False)
    created = models.DateTimeField(auto_now_add=True, editable=False)
    done_datetime = models.DateTimeField(default=None, null=True, editable=False)
    position = models.IntegerField(null=True)
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

    def save(self, *args, **kwargs):
        if Todo.objects.filter(id=self.id):
            in_db_todo = Todo.objects.get(id=self.id)
            if not in_db_todo.done and self.done:
                self.done_datetime = datetime.now()
            elif in_db_todo.done and not self.done:
                self.done_datetime = None
        return super(Todo, self).save(*args, **kwargs)

    class Meta:
        ordering = ["position"]
