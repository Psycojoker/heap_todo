from django.conf.urls import patterns, url
from django.views.generic import ListView
from django.http import HttpResponse
from djangbone.views import BackboneAPIView

from models import Todo

class TodoBackboneView(BackboneAPIView):
    base_queryset = Todo.objects.all()

def dummy(request):
    return HttpResponse("prout")

urlpatterns = patterns('',
    url(r'^$', ListView.as_view(model=Todo), name='home'),
    url(r'^add/$', dummy, name='add'),
    url(r'^todo/$', TodoBackboneView.as_view()),
    url(r'^todo/(?P<id>\d+)/$', TodoBackboneView.as_view()),
)
