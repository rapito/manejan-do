Router.route '/',
	name: 'home'

Router.route '/posts/new',
	name: 'posts.new'
  
Router.route '/posts/show/:_id',
	name: 'posts.show'
	loadingTemplate: 'loading'

	waitOn: ()-> 
		return Meteor.subscribe('Complaint', this.params._id)

	action: ->
		this.render()

	data: ->
		Complaints.coll.findOne {_id: this.params._id}

Router.route '/laws/search',
	name: 'laws.search'

Router.route '/sign-out',
	name: 'sign.out'
	onBeforeAction: AccountsTemplates.logout
