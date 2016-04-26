Meteor.startup ->
  Meteor.Mailgun.config
    username: 'postmaster@domain.com'
    password: 'password-goes-here'

  Meteor.methods sendContactEmail: (name, email, message) ->
    @unblock()
    Meteor.Mailgun.send
      to: 'recipient@example.com'
      from: name + ' <' + email + '>'
      subject: 'New Contact Form Message'
      text: message
      html: Handlebars.templates['contactEmail'](
        siteURL: Meteor.absoluteUrl()
        fromName: name
        fromEmail: email
        message: message
      )

    return

  return
