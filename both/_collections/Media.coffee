@Media = new FS.Collection "media",
  stores: [
#    new FS.Store.FileSystem('uploads/complaints/media/'),
    new FS.Store.GridFS("media", {})
    
  ],
  filter: 
    allow: 
      contentTypes: ['image/*'] 

@Media.allow({
  insert: ()->
    true
  update: ()->
    true
  remove: ()->
    true
  download: ()->
    true
})

if Meteor.isServer
  Meteor.publish 'Media.find', ->
    Media.find({})
else if Meteor.isClient
  Meteor.subscribe 'Media.find'