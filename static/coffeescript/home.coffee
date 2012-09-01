render = (query, template, data) ->
    tag = $(query)
    tag.html(Mustache.render(template, data))


TodoModel = Backbone.Model.extend
    defaults:
        title: "No title yet"
    url: -> if this.id? then "/todo/#{this.id}/" else "/todo/"


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
                that.render_todo_list()

    render_todo_list: ->
        render(this.el, fragments.todos, {todos: this.collection.toJSON()})

    initialize: ->
        console.log "Init TodoView"
        console.log "Attach on " + this.el
        this.collection = new TodoCollection
        this.render()

todoview = new TodoView
