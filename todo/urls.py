from django.conf.urls import patterns, url
from django.views.generic import ListView
from django.http import HttpResponse

from djangbone.views import BackboneAPIView

from models import Todo
from forms import AddTodoForm, EditTodoForm


class TodoBackboneView(BackboneAPIView):
    base_queryset = Todo.objects.all()
    add_form_class = AddTodoForm
    edit_form_class = EditTodoForm

    def get_collection(self, request, *args, **kwargs):
        """
        Handle a GET request for a full collection (when no id was provided).
        """
        qs = self.base_queryset[:10]
        output = self.serialize_qs(qs)
        return self.success_response(output)

    def validation_error_response(self, form_errors):
        print form_errors
        from ipdb import set_trace; set_trace()


def dummy(request):
    return HttpResponse("prout")


urlpatterns = patterns('',
    url(r'^$', ListView.as_view(model=Todo), name='home'),
    url(r'^add/$', dummy, name='add'),
    url(r'^todo/$', TodoBackboneView.as_view(), name="backbone_todo"),
    url(r'^todo/(?P<id>\d+)/$', TodoBackboneView.as_view(), name="backbone_one_todo"),
)
