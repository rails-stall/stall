class VariantsMatrix.Variant extends Vertebra.View
  events:
    'change [data-variants-matrix-variant-enabled]': 'onEnabledStateChanged'

  initialize: (options = {}) ->
    @combination = options.combination
    @persisted = @$el?.data('variant-id')
    @input = options.input

  renderTo: ($container) ->
    $variant = $(@input.nestedFieldsManager.render())
    $variant.appendTo($container)
    @setElement($variant)
    @$el.simpleForm()
    @fillProperties()

  fillProperties: ->
    for property in @properties()
      $property = @$("[data-variants-matrix-variant-property='#{ property.type }']")
      $property.find('[data-property-name]').html(property.name)
      $property.find('[data-property-id]').val(property.id)

  remove: ->
    if @persisted
      @$el.hide(0)
      @setDestroyed(true)
    else
      @$el.remove()
      @trigger('destroy', this)

  show: ->
    @$el.show(0)
    @setDestroyed(false)

  matches: (combination) ->
    VariantsMatrix.objectsAreEqual(@combination, combination)

  properties: ->
    @_properties ?= (@buildPropertyFor(key, value) for key, value of @combination when @combination.hasOwnProperty(key))

  buildPropertyFor: (key, value) ->
    id: value
    name: @input.nameForProperty(key, value)
    type: key

  setEnabledState: (state) ->
    @$('[data-variants-matrix-variant-enabled]')
      .prop('checked', state)
      .trigger('change')

  onEnabledStateChanged: (e) ->
    checked = @$('[data-variants-matrix-variant-enabled]').prop('checked')
    @$el.toggleClass('disabled')
    @setDestroyed(!checked)

  setDestroyed: (state) ->
    @$el.find('[data-variant-remove]').val(if state then 'true' else 'false')
