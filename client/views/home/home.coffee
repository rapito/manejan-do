Template.home.rendered = ->
	$('#select-post-filter').material_select()
	filterDefaultPosts()	


Template.home.events
	'change #select-post-filter': (evt)->
		status = evt.target.value

		filters = status: status
		filters = {} if status == 'all'

		res = Pages.set filters: filters
		
		return
		

# Filters posts and shows them all if admin 
# or only shows available posts
filterDefaultPosts = ->
	filters = if Meteor.user() then {} else { status: 'available' }
	Pages.set filters: filters