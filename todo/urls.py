from django.conf.urls import patterns, url
from django.views.generic import TemplateView

from views import TodoBackboneView, HomePageTodoBackboneView


urlpatterns = patterns('',
    url(r'^$', TemplateView.as_view(template_name="home.haml"), name='home'),
    url(r'^todo/$', HomePageTodoBackboneView.as_view(), name="backbone_todo"),
    url(r'^todo/(?P<id>\d+)/$', TodoBackboneView.as_view(), name="backbone_one_todo"),
    url(r'^all-todo/$', TodoBackboneView.as_view(), name="backbone_todo"),
)
