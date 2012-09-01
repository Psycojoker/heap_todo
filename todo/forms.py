from django import forms
from models import Todo


class AddTodoForm(forms.Form):
    title = forms.CharField()

    def save(self, *args, **kwargs):
        if not self.is_valid():
            raise Exception

        return Todo.objects.create(title=self.cleaned_data["title"], position=1, page=1)


class EditTodoForm(forms.ModelForm):
    class Meta:
        model = Todo
