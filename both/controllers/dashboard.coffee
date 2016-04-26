@DashboardController = AppController.extend(
  waitOn: ->
    # @subscribe 'items'

  # data: 
    # items: Items.find({})

  onAfterAction: ->
    Meta.setTitle 'Dashboard'
    return
)
DashboardController.events 'click [data-action=doSomething]': (event, template) ->
  event.preventDefault()
  return
