from datetime import datetime
from django.db import models

from utils import clean_10_first_todo_if_they_are_done

class Todo(models.Model):
    title = models.CharField(max_length=255)
    done = models.BooleanField(default=False)
    created = models.DateTimeField(auto_now_add=True, editable=False)
    done_datetime = models.DateTimeField(default=None, null=True, editable=False)
    position = models.IntegerField(null=True)
    page = models.IntegerField()

    @classmethod
    def get_home_page(klass):
        clean_10_first_todo_if_they_are_done()

        # can't slice here, otherwise I would broke djangbone
        # I slice in the backbone view at the good time
        # TODO rtfm djangbone pagination stuff
        return klass.objects.filter(position__isnull=False)

    def save(self, *args, **kwargs):
        self.set_done_datetime_of_current_todo()
        return super(Todo, self).save(*args, **kwargs)

    def set_done_datetime_of_current_todo(self):
        I_am_in_db = Todo.objects.filter(id=self.id)
        if not I_am_in_db:
            return

        in_db_todo = Todo.objects.get(id=self.id)
        if not in_db_todo.done and self.done:
            self.done_datetime = datetime.now()
        elif in_db_todo.done and not self.done:
            self.done_datetime = None

    class Meta:
        ordering = ["position"]
