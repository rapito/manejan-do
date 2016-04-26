class mdLaws extends BaseCollection

  @instance: null

  constructor: ->
    try
      super 'Laws', true
    catch e
      console.error e

  attachSchemas: ->
    try
      schema = new SimpleSchema(
        name:
          label: T_('_name', null, TLanguage)
          type: String
          optional: true
        description:
          label: T_('_desc', null, TLanguage)
          type: String
          max: 300
          optional: true
        tags:
          type: [String]
          optional: true
      )
      @coll.attachSchema schema
      super()
    catch e
      console.error e

  populate: ->
    try
      if @coll.find().count() isnt 0
        return false

      laws = [
        {name: 'Art. 49', description: 'Descripción de Articulo 49', tags: ['Via Contraria', 'Contravia']}
        {name: 'Art. 153', description: 'Descripción de Articulo 153', tags: ['Vidrios Tintados', 'Cristales Oscuros']}
        {name: 'Art. 198', description: 'Descripción de Articulo 198', tags: ['No Estacione', 'Mal Parqueado']}
      ]

      for law in laws
        @coll.insert law

      super()
    catch e
      console.error e

  # Obtains all existing Laws with all the
  # Law Tags as a separate Law
  fetchLawsWithTags: ()->
    try
      laws = @coll.find({}).fetch()

      # Array to be actually returned
      result = []

      for law in laws
        # Assign the private _id attr to the .id attr
        law.id = law._id
        # create laws from tags and push them
        # to our result[]
        if law.tags?
          for tag in law.tags
            t = {id: law.id, name: tag}
            result.push t

        # finally push the law itself
        result.push law

      return result
    catch e
      console.error e

  removeLaw: (lawId)->
    Meteor.call 'removeLaw', lawId

  @get: ->
    @instance ?= new mdLaws()

Meteor.methods
  removeLaw: (lawId)->
    Laws.coll.remove(lawId)

@Laws = mdLaws.get()

Laws.coll.simpleSchema().messages
  required: T_ 'form_required', null, TLanguage
