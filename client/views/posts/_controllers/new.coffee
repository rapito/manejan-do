addLocation = new ReactiveVar true
uploadedImageTemplate = Template.uploadedImage

doAfter = (f, time = 1000)->
  window.setTimeout f, time

getSlider = ->
  $('#media-slider-container')

fixSliderSize = ->
  height = $('.uploaded-media-img').height()
  getSlider().find('.slick-list').first().css('height', "#{height}px");

setInputToImages = ->
  $('input[type="file"]').attr 'accept', "image/*"

AutoForm.hooks 
  insertComplaintForm:
    after:
      insert: (err, res)->
        if !err
          Router.go "/posts/show/#{res}"
          showMessage T_('post_saved')


Template.PostsNew.rendered = ->
  initPostsNewLawsTokenInput()
  $(document).ready ->
    initSlider()
    # TODO: reuse
    $('.progress').hide();
    setInputToImages()

Template.PostsNew.helpers

  'descLabel': ()->
    T_ '_desc'

  'lawsLabel': ()->
    T_ 'post_form_laws'

  'locationLabel': ()->
    T_ '_location'

  'locationClass': ()->
    if addLocation.get()
      ''
    else 
      'hidden'

  'locationIcon': ()->
    if addLocation.get() 
      'location_on'
    else 
      'location_off'

  'uploadedMedia': ()->
    return uploadedMedia.get()

  'onFileUploaded': ()->
    lastUrl = null
    getFileUrl = -> return $('.file-upload img').last().attr('src')
    appendImageToPreview = (url)->
      url ?= getFileUrl()
      # console.log 'appendImageToPreview', lastUrl, url
      if !url || lastUrl == url || url?.indexOf('/cfs/files/media') == -1
        doAfter appendImageToPreview
        return

      lastUrl = url
      templateHtml = Blaze.toHTMLWithData(uploadedImageTemplate, url)
      
      $('.progress').hide()
      getSlider().slick('slickAdd', templateHtml)
      getSlider().slick('slickNext')
      doAfter fixSliderSize

    return (t, fileObj)->
      return if !t or !fileObj
      # console.log 'onFileUploaded', t, fileObj
      try 
        appendImageToPreview(fileObj.url())

        $('#form-media .autoform-add-item').click();
        doAfter setInputToImages
        
      catch e
        console.log e
        

Template.PostsNew.events =
  'click #btn-add-media': (evt) ->
    # $('.file-upload label').click()
    jQuery(($)->
        evt.preventDefault();
        $('input[type="file"]').last().click()
        $('.progress').show();
    )

  'click .btn-location': (evt) ->
    console.log 'clicked: ', evt.target
    addLocation.set !addLocation.get() 

initSlider = ()->
    options = {
      adaptiveHeight: true
      dots: true
      arrows: false
      slidesToShow: 1
      slidesToScroll: 1
    }
    getSlider().slick(options)

# Clears Token Input
clearLawsTokenInput = ->
  elId = "#insertComplaintForm * input[name=laws]"
  $(elId).tokenInput 'clear'

initPostsNewLawsTokenInput = ->
# Get the element by it's ID
  elId = "#insertComplaintForm * input[name=laws]"
  obj = $(elId)

  # query the law data
  laws = Laws.fetchLawsWithTags()
  uriOrData = laws
  settings = {
    theme: 'manejando'
    excludeCurrent: true
    preventDuplicates: true
  }
  # Execute the token input initialization to our laws-input
  $(obj).tokenInput uriOrData, settings