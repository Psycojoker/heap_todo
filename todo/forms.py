from django.db.models import Max
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
