TodoModel = Backbone.Model.extend
    defaults:
        title: "No title yet"
    url: -> this.id ? '/todo/' + this.id + '/' : '/todo/'

TodoCollection = Backbone.Collection.extend
    model: TodoModel
    url: '/todo/'

TodoView = Backbone.View.extend
    directive:
        "div.centered":
            'todo<-todos':
                'button': 'todo.title'
    el: $('.todos')
    render: ->
        console.log "Render TodoView"
        that = this
        this.collection.fetch
            success: ->
                $(that.el).html('<div class="row collapse"><div class="four columns centered"><button class="large secondary button"></button></div></div>')
                $(that.el).render({todos: that.collection.toJSON()}, that.directive)

    initialize: ->
        console.log "Init TodoView"
        this.collection = new TodoCollection
        this.render()

todoview = new TodoView
