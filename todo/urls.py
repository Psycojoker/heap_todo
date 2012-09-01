from django.conf.urls import patterns, url
from django.views.generic import ListView

from models import Todo
from views import TodoBackboneView


urlpatterns = patterns('',
    url(r'^$', ListView.as_view(model=Todo), name='home'),
    url(r'^todo/$', TodoBackboneView.as_view(), name="backbone_todo"),
    url(r'^todo/(?P<id>\d+)/$', TodoBackboneView.as_view(), name="backbone_one_todo"),
)
