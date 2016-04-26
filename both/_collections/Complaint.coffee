class mdComplaints extends BaseCollection

  @instance: null

  constructor: ->
    try
      super 'Complaints'
    catch e
      console.error e

  attachSchemas: ->
    try
      # Media Type
      MediaSchema = new SimpleSchema(
        media:
          type: String
        url:
          type: String
      )

      # Distribution
      DistributionSchema = new SimpleSchema(
        network:
          type: String
        id: 
          type: String
        url:
          type: String
          optional: true
      )

      schema = new SimpleSchema(
        status: 
          type: String
          defaultValue: 'pending'
        description:
          label: T_('_desc', null, TLanguage)
          type: String
          max: 300
          optional: true
        location:
          label: T_('_location', null, TLanguage)
          type: Object
          optional: true
          autoform:
            type: 'map'
            afFieldInput:
              geolocation: true
              searchBox: true
              autolocate: true
              zoom: 15
        'location.lat':
          type: Number
          decimal: true
        'location.lng':
          type: Number
          decimal: true
        laws:
          type: [String]
          label: T_('post_form_laws', null, TLanguage)
          min: 1
        dislikes:
          optional: true
          defaultValue: 0
          type: Number
        media:
          type: [String]
          label: T_('post_form_file') # optional, null, TLanguage
        "media.$":
          autoform:
            afFieldInput:
              type: 'fileUpload'
              collection: 'Media'

        distributions:
          type: [DistributionSchema]
          label: 'Link to other social networks'
          optional: true
      )
      @coll.attachSchema schema
      super()
    catch e
      console.error e

  doPublish: ->
    Meteor.publishComposite 'Complaints', ->
      find: ->
        query = {}
        Complaints.coll.find(query)

  publish: ->
    Meteor.publish 'Complaint', (cpId)->
      Complaints.coll.find({_id: cpId})

    @doPublish()

  subscribe: ->
    Meteor.subscribe 'Complaints'

  # should obtain all laws related to this complaint
  # if readonly is true, the resulting data must be appended
  # with an attribute 'readonly': true
  getLaws: (cpId, readonly)->
    cp = @coll.findOne({_id: cpId})
    laws = Laws.coll.find({_id: {$in: cp.laws}})?.fetch()

    # append readonly if true
    for law in laws
      law.id = law._id
      if readonly?
        law.readonly = true;

    laws

  hasNetwork: (cpId, network)->
    cp = @coll.findOne({_id: cpId})
    res = false

    return false unless cp.distributions

    _.each cp.distributions, (dist)->
      res = res || dist.network.toLowerCase() == network.toLowerCase()

    return res

  hasFacebook: (cpId)->
    @hasNetwork cpId, 'Facebook'

  hasTwitter: (cpId)->
    @hasNetwork cpId, 'Twitter'

  # Adds twitter url/id to a complaint distributions 
  setTweetID: (cpId, id)->
    cp = @coll.findOne({_id: cpId})
    cp.distributions ?= []
    cp.distributions.push {
      network: 'Twitter'
      id: id
      url: "https://twitter.com/statuses/#{id}"
    }
    @coll.update({_id: cpId}, {$set: {distributions: cp.distributions}})

  dislikeComplaint: (cpId)->
    Meteor.call 'updateComplaintDislike', cpId, 1

  undislikeComplaint: (cpId)->
    Meteor.call 'updateComplaintDislike', cpId, -1
    
  getShareObject: (cp)->
    if typeof(cp) == "string"
      cp = @coll.findOne({_id: cp})

    desc = if cp.description then cp.description else T_('post_share_desc_default', null, TLanguage)
    url = Meteor.absoluteUrl("posts/show/#{cp._id}", {})
    title = "#{desc} @_ManejanDO"
    sh = 
        title: title
        url: url

    if cp.location?.lat?
      sh.lat = cp.location.lat
      sh.long = cp.location.lng

    if cp.media?.length > 0
      img = Meteor.absoluteUrl Media.findOne({_id: cp.media[0]}).url()
      sh.img = img

    sh

  tweet: (cpId)->
    Meteor.call 'Complaints.tweet', cpId

  removeComplaint: (cpId)->
    Meteor.call 'removeComplaint', cpId

  switchAvailability: (cpId)->
    cp = Complaints.coll.findOne({_id: cpId})
    status = if cp.status == 'pending' then 'available' else 'pending'

    if cp.status != status 
      Meteor.call 'setComplaintStatus', cpId, status

  switchVisibility: (cpId)->
    cp = Complaints.coll.findOne({_id: cpId})
    status = if cp.status == 'hidden' then 'available' else 'hidden'

    if cp.status != status 
      Meteor.call 'setComplaintStatus', cpId, status

  isAvailable: (cp)->
    cp.status == 'available'

  isVisible: (cp)->
    cp.status != 'hidden'

  @get: ->
    @instance ?= new mdComplaints()

@Complaints = mdComplaints.get()

Meteor.methods
  setComplaintStatus: (cpId, status)->

    if status == 'available'
      Complaints.tweet cpId

    Complaints.coll.update({_id: cpId}, { $set: { status: status } })

  removeComplaint: (cpId)->
    if Meteor.user()
      Complaints.coll.remove(cpId)

  updateComplaintDislike: (cpId, increment)->
    cp = Complaints.coll.findOne({_id: cpId})

    cp.dislikes = 0 if _.isNull(cp.dislikes) or not _.isNumber(cp.dislikes)
    cp.dislikes += increment

    Complaints.coll.update cpId, {$set: cp}
    return

@Pages = new Meteor.Pagination Complaints.coll,
  debug: true
  templateName: "home"
  itemTemplate: "Post"
  infiniteCont: '.posts-container'
  infinite: true
  infiniteStep: 1
  pageSizeLimit: 100
  perPage: 2
  sort:
    createdAt: -1
  availableSettings:
    limit: true
    sort: true
    filters: true
  # auth: (skip, subscription) ->
  #   query = {}

  #   if !subscription.userId
  #     query.status = 'available'

  #   console.log 'publish.query', query, subscription.userId
  #   Complaints.coll.find(query)

Complaints.coll.simpleSchema().messages
  required: T_ 'form_required', null, TLanguage
