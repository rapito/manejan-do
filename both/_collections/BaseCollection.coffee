#SimpleSchema.debug = true
class @BaseCollection


  # Create a collection with the 'collectionName' and its 'opts'
  # publishAll: Indicates if should publish and subscribe all documents.
  constructor: (collectionName, publishAll = false, opts = {})->
    try
      serverLog "Creating collection #{collectionName} [started]"

      @coll = new Mongo.Collection collectionName, opts
      @collectionName = collectionName

      serverLog 'Attaching Schemas [started]'
      @attachSchemas() # Attach any schemas
      serverLog 'Attaching Schemas [finished]'

      serverLog 'Allow/Deny [started]'
      @allow()
      @deny()
      serverLog 'Allow/Deny [finished]'

      serverLog 'Populating collection [started]'
      if @count() <= 0
        @populate() if Meteor.isServer # Pre-Populate Collection
      serverLog 'Populating collection [finished]'

      serverLog 'Publishing/Subscribing Collection [started]'
      if publishAll # Publish/Subscribe to everything if true
        if Meteor.isServer
          @publishAll()
        else
          @subscribeAll()
      else # Do normal publishing/subscribing
        if Meteor.isServer
          @publish()
        else
          @subscribe()
      serverLog 'Publishing/Subscribing Collection [finished]'

    catch e
      serverError e
    finally
      serverLog "Creating collection #{collectionName} [finished]"

# this method should be overriden to add values to the schemas array
# and finally call super method to add them all
  attachSchemas: ->
    try
      # insert created/updated schemas
      serverLog "Attaching own schemas"
      
      createAtSchema = new SimpleSchema(
        createdAt:
          type: Date
          autoValue: ->
            if @isInsert
              return new Date()
            else if @isUpsert
              return {$setOnInsert: new Date()}
            else
              @unset()
      )


      modifiedAtSchema = new SimpleSchema(
        modifiedAt:
          type: Date
          optional: true
          autoValue: ->
            if @isUpdate
              return new Date()
      )
      
      @coll.attachSchema createAtSchema
      @coll.attachSchema modifiedAtSchema
    catch e
      serverError e

  count: ->
    try
      c = @coll.find().count()
    catch e
      serverError e

  populate: ->
    try
      serverLog "Inserted #{@coll.find({}).count()} documents."
    catch e
      serverError e

  publish: ->
    try
    catch e
      serverError e

  subscribe: ->
    try
    catch e
      serverError e

  allow: ->
    try
      @coll.allow
        insert: (userId, doc)->
          true
        update: (userId, doc, fieldNames, modifier)->
          true
        remove: (userId)->
          userId?
    catch e
      serverError e

  deny: ->
    try
    catch e
      serverError e

  publishAll: ->
    try
      coll = @coll
      Meteor.publish @collectionName, ->
        coll.find({})
    catch e
      serverError e

  subscribeAll: ->
    try
      @subscriptionHandle = Meteor.subscribe @collectionName
    catch e
      serverError e

  find: (filter = {}, projection = {})->
    try
      @coll.find(filter, projection).fetch()
    catch e
      serverError e

#TODO: extract to utility methods
serverLog = ()->
  if(Meteor.isServer)
    console.log arguments...

#TODO: extract to utility methods
serverError = ()->
  if(Meteor.isServer)
    console.error arguments...
