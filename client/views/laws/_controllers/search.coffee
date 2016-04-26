Query = new ReactiveVar ''
SelectedLaw = new ReactiveVar null
ModalSelector = '#modal-selected-law'

AutoForm.hooks
  "form-law":
    onSuccess: (formType, result)->
      closeLawModal();
      showMessage T_('law_saved')
    onError: (formType, error)->
      showMessage T_('save_error')

Template.LawsSearch.onRendered ->

# TODO: extract into utility
Template.registerHelper "stringify", (obj) ->
  JSON.stringify obj

Template.LawsSearch.helpers
  'omitFields': ()->
    ['createdAt', 'modifiedAt']
  'Laws': ()->
    Laws.coll
  'formType': ()->
    if SelectedLaw.get()
      'update'
    else
      'insert'
  'selectedLaw': ()->
    SelectedLaw.get()

  'laws': ()->
    query = Query.get()
    if query

      query = ".*#{query}.*" # build the query
      qOpts = {$regex: query, $options: 'i'}
      query = {$or: [{name: qOpts}, {description: qOpts}, {tags: qOpts}]}
    else
      query = {}

    Laws.coll.find(query)

Template.LawsSearch.events
  'click #btn-law-new': (evt)->
    # console.log 'click #btn-law-new', this, evt
    SelectedLaw.set null
    openLawModal()

  'click .btn-law-delete': (evt)->
    evt.stopPropagation() # Dont let row click interfere
    console.log 'click #btn-law-delete', this, evt
    if confirm(T_('law_delete?', this.name))
      Laws.removeLaw(this._id)
      showMessage T_('law_deleted')

  'click .row-law': (evt)->
    console.log 'click .row-law', this, evt
    SelectedLaw.set this

    openLawModal()

  'change #search-laws, keyup #search-laws': (evt)->
    console.log 'change #search-laws', Query
    Query.set $(evt.currentTarget).val()



openLawModal = ()->
  $(ModalSelector).openModal();

closeLawModal = ()->
  $(ModalSelector).closeModal();