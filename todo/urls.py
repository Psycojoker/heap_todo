from django.conf.urls import patterns, url
from django.views.generic import ListView
from django.http import HttpResponse

from models import Todo
from views import TodoBackboneView


def dummy(request):
    return HttpResponse("prout")


urlpatterns = patterns('',
    url(r'^$', ListView.as_view(model=Todo), name='home'),
    url(r'^add/$', dummy, name='add'),
    url(r'^todo/$', TodoBackboneView.as_view(), name="backbone_todo"),
    url(r'^todo/(?P<id>\d+)/$', TodoBackboneView.as_view(), name="backbone_one_todo"),
)
