Meteor.startup ->
  AutoForm.setDefaultTemplate 'materialize'
  $('body').on 'click', '[data-action=logout]', (event) ->
    event.preventDefault()
    AccountsTemplates.logout()
    return

  return
