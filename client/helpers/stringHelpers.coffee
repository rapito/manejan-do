Template.registerHelper 'truncate', (string, length) ->
  cleanString = _(string).stripTags()
  _(cleanString).truncate length
