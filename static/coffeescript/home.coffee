render = (query, template, data) ->
    tag = $(query)
    tag.html(Mustache.render(template, data))


TodoModel = Backbone.Model.extend
    url: -> if this.id? then "/todo/#{this.id}/" else "/todo/"


TodoCollection = Backbone.Collection.extend
    model: TodoModel
    url: "/todo/"


TodoListView = Backbone.View.extend
    el: $("div#todos")

    events:
        all: "all_events"

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

    all_events: (event) ->
        console.log "Received event: #{event}"


todoview = new TodoListView
