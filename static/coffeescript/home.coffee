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
        "dblclick span": "modify_todo"
        "click span": "toggle_done"
        "keypress input": "validate_modification"
        "focusout": "end_modification"

    modify_todo: ->
        if not this.modify_mode
            this.modify_mode = true
            this.$el.addClass("editable")
            this.$el.find("input").focus()
            this.$el.find("input").val(this.model.attributes.title)

    toggle_done: ->
        console.log this.model.attributes.done
        this.$el.find("span").toggleClass("done")
        this.model.attributes.done = not this.model.attributes.done
        this.model.save()

    validate_modification: (event) ->
        if event.keyCode == 13
            this.$el.find("span").removeClass("done")
            this.model.attributes.title = this.$el.find("input").val()
            this.model.attributes.title
            this.model.save()
            this.$el.removeClass("editable")
            this.modify_mode = false

    end_modification: ->
        this.modify_mode = false
        this.$el.removeClass("editable")

    remove_todo: (event) ->
        that = this
        this.model.destroy
            success: ->
                console.log "Remove model"
                that.$el.remove()

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


todo_list_view = new TodoListView
addtodoview = new AddTodoView
