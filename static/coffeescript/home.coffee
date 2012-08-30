TodoModel = Backbone.Model.extend
    defaults:
        title: "No title yet"
    url: -> this.id ? '/todo/' + this.id + '/' : '/todo/'

TodoCollection = Backbone.Collection.extend
    model: TodoModel
    url: '/todo/'

TodoView = Backbone.View.extend
    el: $('.todos')
    render: ->
        console.log "Render TodoView"
        that = this
        this.collection.fetch
            success: ->
                $(that.el).append("<ul>")
                that.collection.each (todo) ->
                    console.log "caca"
                    console.log todo
                    $(that.el).append("<li>" + todo.attributes.title + "</li>")
                $(that.el).append("</ul>")

    initialize: ->
        console.log "Init TodoView"
        this.collection = new TodoCollection
        this.render()

todoview = new TodoView
