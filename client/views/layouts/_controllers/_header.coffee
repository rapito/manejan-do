Template._header.rendered = ->
  Meteor.setTimeout (->
    @$('.dropdown-button').dropdown
      inDuration: 300
      outDuration: 225
      constrain_width: false
      hover: false
      alignment: 'right'
      gutter: 0
      belowOrigin: true

    @$('.button-collapse').sideNav
      menuWidth: 240
      activationWidth: 70
      closeOnClick: true

    return
  ).bind(this), 200
  return