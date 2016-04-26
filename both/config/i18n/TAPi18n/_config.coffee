if Meteor.isClient
  Meteor.startup ()->
    TAPi18n.setLanguage 'es'

@T_ = TAPi18n.__ # proxy method
#console.log '@T_', T_

@TLanguage = 'es'