import models


def clean_10_first_todo_if_they_are_done():
    home_page_todos = models.Todo.objects.filter(position__isnull=False)[:10]
    if all(map(lambda x: x.done, home_page_todos)):
        for i in home_page_todos:
            i.position = None
            print "caca"
            i.save()
