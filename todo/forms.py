from django.db.models import Max, Min
from django import forms
from models import Todo


class AddTodoForm(forms.Form):
    title = forms.CharField()

    def save(self, *args, **kwargs):
        if not self.is_valid():
            raise Exception

        max_position = Todo.objects.all().aggregate(Max("position"))["position__max"]
        return Todo.objects.create(title=self.cleaned_data["title"], position=max_position + 1 if max_position else 1, page=1)


class EditTodoForm(forms.ModelForm):
    class Meta:
        model = Todo

    def save(self, *args, **kwargs):
        todo = super(EditTodoForm, self).save(*args, **kwargs)
        #from ipdb import set_trace; set_trace()

        print "Todo position:", todo.position
        if todo.position == -1: # promote mode
            print "promoting"
            min_position = Todo.objects.all().aggregate(Min("position"))["position__min"]
            todo.position = min_position - 1 if min_position else 1
            todo.save()

        elif todo.position == -2: # delay mode
            print "delaying"
            max_position = Todo.objects.all().aggregate(Max("position"))["position__max"]
            todo.position = max_position + 1 if max_position else 1
            todo.save()

        return todo
