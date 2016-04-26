if Meteor.users.find().count() == 0
  Accounts.createUser
    username: Meteor.settings.seeds.user.username
    email: Meteor.settings.seeds.user.email
    password: Meteor.settings.seeds.user.password