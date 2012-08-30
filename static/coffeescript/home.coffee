render_pure = (query, template, data, directives) ->
    tag = $(query)
    tag.html(template)
    tag.render(data, directives)

TodoModel = Backbone.Model.extend
    defaults:
        title: "No title yet"
    url: -> this.id ? '/todo/' + this.id + '/' : '/todo/'

TodoCollection = Backbone.Collection.extend
    model: TodoModel
    url: '/todo/'

TodoView = Backbone.View.extend
    directive:
        'li':
            'todo<-todos':
                '.': 'todo.title'
    el: $('.todos')
    render: ->
        console.log "Render TodoView"
        that = this
        this.collection.fetch
            success: ->
                render_pure(that.el, fragments.todos, {todos: that.collection.toJSON()}, that.directive)

    initialize: ->
        console.log "Init TodoView"
        console.log "Attach on " + this.el
        this.collection = new TodoCollection
        this.render()

todoview = new TodoView
