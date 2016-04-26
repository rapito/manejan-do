
AccountsTemplates.configure
  hideSignUpLink: true
  forbidClientAccountCreation: true

AccountsTemplates.configureRoute 'signIn',
  layoutTemplate: 'appLayout'

AccountsTemplates.configureRoute 'ensureSignedIn',
  layoutTemplate: 'appLayout'
