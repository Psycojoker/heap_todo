from djangbone.views import BackboneAPIView
from django.http import HttpResponse

from models import Todo
from forms import AddTodoForm, EditTodoForm


class TodoBackboneView(BackboneAPIView):
    base_queryset = Todo.objects.all()
    add_form_class = AddTodoForm
    edit_form_class = EditTodoForm

    def validation_error_response(self, form_errors):
        print form_errors
        from ipdb import set_trace; set_trace()


class ActiveTodoBackboneView(BackboneAPIView):
    base_queryset = Todo.objects.filter(done=False)


class DoneTodoBackboneView(TodoBackboneView):
    base_queryset = Todo.objects.filter(done=True)


class HomePageTodoBackboneView(TodoBackboneView):
    def get_collection(self, request, *args, **kwargs):
        """
        Handle a GET request for a full collection (when no id was provided).
        """
        qs = self.base_queryset[:10]
        output = self.serialize_qs(qs)
        return self.success_response(output)

    def dispatch(self, request, *args, **kwargs):
        self.base_queryset = Todo.get_home_page()
        return super(TodoBackboneView, self).dispatch(request, *args, **kwargs)


# shoudl require POST to be well made
def clean_home(request):
    home_page_todos = Todo.objects.filter(position__isnull=False)[:10]

    for i in home_page_todos:
        if not i.done:
            continue

        i.position = None
        print "caca"
        i.save()

    return HttpResponse("ok")
