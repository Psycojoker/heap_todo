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
        console.log "TodoView attach on " + this.el
        this.collection = new TodoCollection
        this.collection.bind("sync", this.render, this) # I'm sure this is memleaking on adding a new todo
        this.render()

    all_events: (event) ->
        console.log "Received event: #{event}"


AddTodoView = Backbone.View.extend
    el: $("#submit-todo")

    events:
        all: "all_events"
        click: "submit"

    all_events: (event) ->
        console.log "Received event: " + event

    submit: (event) ->
        console.log "Submit"
        event.preventDefault()
        todoview.add_a_todo
            title: $("#add-todo input@[name=title]").val()
        console.log "Clean input data"
        $("#add-todo input@[name=title]").val("")

    initialize: ->
        console.log "Init AddView"
        console.log "AddView attach on " + this.el


todoview = new TodoListView
addtodoview = new AddTodoView
