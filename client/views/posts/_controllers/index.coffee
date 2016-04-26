Template.Post.onCreated ->

Template.Post.onRendered ->
  template = this
  $(document).ready ->
    initLaws template.data
    initSlider template.data
    initClipboard()

Template.Post.helpers
  'extraMarginClass': ->
    if this.media?.length > 1
      return 'btn-post-extra-margin' 

  'showVisibility': ()->
    this.status == 'available' or this.status == 'hidden'

  'hasLocation': ()->
    hasLocation = this.location?.lat? or this.location?.lng?
    if hasLocation then '' else 'invisible'

  'twitterShare': (complaint)->
    sh = Complaints.getShareObject complaint
    
    base = "https://twitter.com/intent/tweet"
    url = encodeURIComponent sh.url
    text = encodeURIComponent sh.title
    href = base + "?url=" + url + "&text=" + text
    
    if sh?.author
        href += "&via=" + sh.author
    
    href
    
  'imgUrl': (img)->
    img = Media.findOne({_id: img})
    img?.url()

  'dislikedClass': ->
    if Session.get("disliked_#{this._id}") then 'red-text' else ' black-text'

  'unavailableClass': ->
    if this.status != 'available' then 'unavailable' else ''

  'statusLabel': ->
    status = T_ "status_#{this.status}"
    "#{status} - "

Template.Post.events
  'click .btn-post-visibility': (evt)->
    return unless this.status == 'available' or this.status == 'hidden'
    evt.stopPropagation() # Dont let row click interfere
    # console.log 'click .btn-post-visibility', this, evt

    confirmationLabel = if Complaints.isVisible(this) then 'post_set_hidden?' else 'post_set_visible?'
    if confirm T_(confirmationLabel, this._id)
      Complaints.switchVisibility this._id
      showMessage T_('post_visibility_updated')

  'click .post-status': (evt)->
    return unless Meteor.user()

    confirmationLabel = if Complaints.isAvailable(this) then 'post_set_pending?' else 'post_set_available?'
    if confirm(T_(confirmationLabel), this._id)
      Complaints.switchAvailability this._id
      showMessage T_('post_status_updated')

  'click .btn-post-delete': (evt)->
      evt.stopPropagation() # Dont let row click interfere
      # console.log 'click .btn-post-delete', this, evt
      if confirm(T_('post_delete?', this._id))
        Complaints.removeComplaint this._id
        showMessage T_('post_deleted')

  'click .btn-location': (evt)->
      openGoogleMaps this.location.lat, this.location.lng

  'click .btn-share-fb': (evt)->
    evt.preventDefault()
    sh = Complaints.getShareObject this
    
    if Meteor.settings?.public?.services?.facebook?.app_id?
        base = "https://www.facebook.com/dialog/feed?"
        appId = Meteor.settings.public.services.facebook.app_id 
        picture = sh.img
        link = sh.url
        FB.ui
            method: 'feed'
            picture: picture
            name: T_('post_share_desc_default')
            link: link
            caption: "Manejan.do"
            description: sh.title
        
        
  'click .btn-share-link': (evt)-> 
    showMessage T_('post_copied')
  'click .btn-dislike': (evt)->
    sess_attr = "disliked_#{this._id}"
    # console.log(Complaints)

    # toggle the dislike status
    if not Session.get(sess_attr)
      Session.set sess_attr, true
      Complaints.dislikeComplaint(this._id)
    else
      Session.set sess_attr, false
      Complaints.undislikeComplaint(this._id)

# Inits slick slider
initSlider = (post)->
  imageContainer = "#card-media-#{post._id}"
  firstImage = $($("#{imageContainer} img")[0])
  if post.media?.length == 1
    url = firstImage.attr('data-lazy')
    firstImage.attr('src', url)
  else
    $("#{imageContainer}").slick {
    #   autoplay: true,
    #   autoplaySpeed: 1500
      lazyLoad: 'progressive'
      dots: true
      arrows: false
      infinite: true
      speed: 300
      slidesToShow: 1
      slidesToScroll: 1
      adaptiveHeight: true
  # fade: true
      cssEase: 'linear'
    }

# Inits token-input law widgets
initLaws = (post)->
  opts =
    theme: 'manejando'
    excludeCurrent: true
    onSelectedToken: showLawInfo
    prePopulate: Complaints.getLaws(post._id, true)

  inputTokenSelector = '.token-input-token-manejando'

  # Execute the token input initialization to our laws-input
  $("#input-cp-laws-#{post._id}").tokenInput(null, opts)
  $("#token-input-input-cp-laws-#{post._id}").remove() # remove input
  $("#{inputTokenSelector}").addClass('activator').addClass('selectable') # make tokens activate law reveal
  $("#{inputTokenSelector} p").addClass('activator').addClass('selectable') # make tokens activate law reveal

# TODO: Must show law details
showLawInfo = (element, law)->
  id = element.parentElement.nextElementSibling.attributes['data-post-id'].value
  $title = $("#post-law-info-#{id} span b")
  $desc = $("#post-law-info-#{id} p")

  $title.html(law.name)
  $desc.html(law.description)

# inits clipboard.js for share links
initClipboard = ()->
 new Clipboard '.btn-share-link'

# TODO: extract to utility method
# TODO: embed map in new modal
openGoogleMaps = (lat, long)->
  url = "http://maps.google.com/maps?q=#{lat},#{long}"
  window.open url, '_blank'

T = -> Template.instance()