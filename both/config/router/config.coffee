Router.configure
  controller: 'AppController'
  loadingTemplate: 'loading'
  layoutTemplate: 'appLayout'

Router.plugin 'dataNotFound',
  dataNotFoundTemplate: 'notFound'

Router.plugin 'ensureSignedIn',
  except: ['home','posts.new', 'posts.show']
