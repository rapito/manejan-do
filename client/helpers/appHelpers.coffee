@Helpers =
  appTitle: () ->
    Meteor.settings.public.app.title
  thisYear: () ->
    new Date().getFullYear();


$.each Object.keys(Helpers), (_idx, helperName)->
#  console.log 'registerHelper', helperName, Helpers[helperName]
  Template.registerHelper helperName, Helpers[helperName]

@showMessage = (message, delay = 3000)->
	Materialize.toast message, delay