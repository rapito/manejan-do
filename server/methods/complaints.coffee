fs = Npm.require('fs');



Meteor.methods
  'Complaints.tweet': (cpId)->

    if Complaints.hasTwitter(cpId)
      # console.log 'Complaints.tweet.hasTwitter', cpId, 'Has Twitter URL, returning'
      return

    if !canRepost()
      # console.log 'Complaints.tweet', 'Repost Settings turned off', canRepost()
      return

    cp = Complaints.coll.findOne({_id: cpId})
    sh = Complaints.getShareObject cp

    post =
      status: "#{RandomTwitterStatus()} #{sh.url}"
      lat: sh.lat
      long: sh.long

    ## post a tweet with media
    media = Media.findOne({_id: cp.media[0]})
    mediaData = getBase64DataSync media


    # first we must post the media to Twitter
    TwitterAPI.post 'media/upload', { media_data: mediaData }, Meteor.bindEnvironment((err, data, response) ->
#      console.log 'Complaints.tweet','media/upload', err, response, post
      return if err

      mediaIdStr = data.media_id_string

      post.media_ids = [mediaIdStr]

      TwitterAPI.post 'statuses/update', post, Meteor.bindEnvironment((err, data, response)->
        # console.log 'Complaints.tweet', 'statuses/update', 'data', data
        if data?.id
          Complaints.setTweetID cpId, data.id
      )
    )   


RandomTwitterStatus = ()->
  status = [
    "Observe el peligro en nuestras vías, #manejando",
    "Salvense quien pueda #manejando",
    "@AMETRD #venAVer #manejando"
  ]
  status[getRandomInt(0,status.length)]

# TODO: make utility
# Checks if the app is setup to repost social media
canRepost = ->
  Meteor.settings.services.repost == true


# TODO: make utility
getRandomInt = (min, max)->
  Math.floor(Math.random() * (max - min)) + min;


# TODO: make utility
getBase64Data = (doc, callback)->
  buffer = new Buffer(0)
  readStream = doc.createReadStream()

  readStream.on 'data', (chunk)->
    buffer = Buffer.concat([buffer, chunk])

  readStream.on 'error', (err)->
    callback(err, null)

  readStream.on 'end', ()->
    callback(null, buffer.toString('base64'))

getBase64DataSync = Meteor.wrapAsync(getBase64Data)
