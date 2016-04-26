@TwitterAPI = new TwitMaker
  consumer_key:         Meteor.settings.services.twitter.api_key
  consumer_secret:      Meteor.settings.services.twitter.api_secret
  access_token:         Meteor.settings.services.twitter.access_token
  access_token_secret:  Meteor.settings.services.twitter.access_token_secret
  timeout_ms:           60*1000 # optional HTTP request timeout to apply to all requests.
