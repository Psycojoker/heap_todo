from django import forms
from models import Todo


class AddTodoForm(forms.Form):
    title = forms.CharField()

    def save(self, *args, **kwargs):
        if self.is_valid():
            return Todo.objects.create(title=self.cleaned_data["title"], position=1, page=1)
        else:
            raise Exception


class EditTodoForm(forms.ModelForm):
    class Meta:
        model = Todo
