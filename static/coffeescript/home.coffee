render = (query, template, data) ->
    tag = $(query)
    tag.html(Handlebars.compile(template)(data))


TodoModel = Backbone.Model.extend
    url: -> if this.id? then "/todo/#{this.id}/" else "/todo/"


TodoCollection = Backbone.Collection.extend
    model: TodoModel
    url: "/todo/"


TodoListView = Backbone.View.extend
    el: $("div#todos")

    render: ->
        console.log "Render TodoView"
        that = this
        this.collection.fetch
            success: ->
                that.render_todo_list()

    render_todo_list: ->
        render(this.el, fragments.todos, {todos: this.collection.toJSON()})
        this.collection.each (i) ->
            new TodoView
                el: $("li##{i.id}")
                model: i

    initialize: ->
        console.log "Init TodoView"
        console.log "TodoView attach on " + this.el
        this.collection = new TodoCollection
        this.collection.bind("sync", this.render, this) # I'm sure this is memleaking on adding a new todo
        this.render()

    add_a_todo: (data) ->
        this.collection.create data


TodoView = Backbone.View.extend
    tagName: "li"
    events:
        "click a.remove": "remove_todo"
        "click a.edit": "modify_todo"
        "click a.promote": "promote_todo"
        "click a.delay": "delay_todo"
        "click a.redo": "redo_todo"
        "click span.non-edit": "toggle_done"
        "keypress input": "validate_modification"
        "blur input": "end_modification"
        "mouseover": "display_edit_button"
        "mouseout": "remove_edit_button"
        "mouseover span.non-edit": "preview_done"
        "mouseout span.non-edit": "unpreview_done"

    modify_todo: (event) ->
        event.preventDefault()
        console.log "modify_todo"
        if not this.modify_mode
            this.modify_mode = true
            this.$el.addClass("editable")
            this.$el.find("input").focus()
            this.$el.find("input").val(this.model.attributes.title)

    promote_todo: (event) ->
        event.preventDefault()
        console.log "promote_todo"
        this.model.attributes.position = -1
        this.model.save()

    delay_todo: (event) ->
        event.preventDefault()
        console.log "delay_todo"
        this.model.attributes.position = -2
        this.model.save()

    redo_todo: (event) ->
        event.preventDefault()
        console.log "redo_todo"
        this.model.attributes.done = true
        this.model.save()
        new_todo = new TodoModel({title: this.model.attributes.title})
        new_todo.save()

    toggle_done: ->
        console.log "toggle_done"
        this.model.attributes.done = not this.model.attributes.done
        this.model.save()

    validate_modification: (event) ->
        console.log "validate_modification"
        if event.keyCode == 13
            this.$el.find("span").removeClass("done")
            this.model.attributes.title = this.$el.find("input").val()
            this.model.attributes.title
            this.model.save()
            this.$el.removeClass("editable")
            this.modify_mode = false

    end_modification: ->
        console.log "end_modification"
        this.modify_mode = false
        this.$el.removeClass("editable")

    display_edit_button: ->
        this.$el.find("span.buttons").removeClass("hide")

    remove_edit_button: ->
        this.$el.find("span.buttons").addClass("hide")

    remove_todo: (event) ->
        event.preventDefault()
        that = this
        this.model.destroy
            success: ->
                console.log "Remove model"
                that.$el.remove()
                todo_list_view.render()

    preview_done: ->
        if this.model.attributes.done
            this.$el.find("span").removeClass("done")
        else
            this.$el.find("span").addClass("done")

    unpreview_done: ->
        if this.model.attributes.done
            this.$el.find("span").addClass("done")
        else
            this.$el.find("span").removeClass("done")

    initialize: ->
        console.log "New individual todo view for #{this.el} on model #{this.model.id}"
        this.modify_mode = false


AddTodoView = Backbone.View.extend
    el: $("#submit-todo")

    events:
        click: "submit"

    submit: (event) ->
        console.log "Submit"
        event.preventDefault()
        todo_list_view.add_a_todo
            title: $("#add-todo input@[name=title]").val()
        console.log "Clean input data"
        $("#add-todo input@[name=title]").val("")

    initialize: ->
        console.log "Init AddView"
        console.log "AddView attach on " + this.el


MenuView = Backbone.View.extend
    el: $("#menu")

    events:
        "click a#set_home": "set_home"
        "click a#set_all": "set_all"
        "click a#set_done": "set_done"

    set_home: (event) ->
        event.preventDefault()
        console.log "set_home"
        todo_list_view.collection.url = "/todo/"
        todo_list_view.render()

    set_all: (event) ->
        event.preventDefault()
        console.log "set_all"
        todo_list_view.collection.url = "/all-todo/"
        todo_list_view.render()

    set_done: (event) ->
        event.preventDefault()
        console.log "set_done"
        todo_list_view.collection.url = "/done-todo/"
        todo_list_view.render()

    initialize: ->
        console.log "Init MenuView"
        console.log "attach MenuView on #{this.el}"


todo_list_view = new TodoListView
addtodoview = new AddTodoView
menuview = new MenuView

refresh = -> todo_list_view.render()

setInterval refresh, 30000
