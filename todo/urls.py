from django.conf.urls import patterns, url
from django.views.generic import ListView
from django.http import HttpResponse
from django import forms

from djangbone.views import BackboneAPIView

from models import Todo


class AddTodoForm(forms.Form):
    title = forms.CharField()

    def save(self, *args, **kwargs):
        if self.is_valid():
            return Todo.objects.create(title=self.cleaned_data["title"], position=1, page=1)
        else:
            raise Exception


class TodoBackboneView(BackboneAPIView):
    base_queryset = Todo.objects.all()
    add_form_class = AddTodoForm
    #edit_form_class = AddTodoForm


def dummy(request):
    return HttpResponse("prout")


urlpatterns = patterns('',
    url(r'^$', ListView.as_view(model=Todo), name='home'),
    url(r'^add/$', dummy, name='add'),
    url(r'^todo/$', TodoBackboneView.as_view(), name="backbone_todo"),
    url(r'^todo/(?P<id>\d+)/$', TodoBackboneView.as_view(), name="backbone_one_todo"),
)
