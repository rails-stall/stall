class VariantsMatrix.Variant extends Vertebra.View
  events:
    'change [data-variants-matrix-variant-enabled]': 'onEnabledStateChanged'
    'click [data-variants-matrix-apply-to-all]': 'onApplyToAllClicked'

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
    for propertyValue in @propertyValues()
      $propertyValue = @$("[data-variants-matrix-variant-property='#{ propertyValue.propertyId }']")
      $propertyValue.find('[data-property-name]').html(propertyValue.name)
      $propertyValue.find('[data-property-value-id]').val(propertyValue.id)
      $propertyValue.removeClass('hidden')

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

  propertyValues: ->
    @_propertyValues ?= for key, value of @combination when @combination.hasOwnProperty(key)
      @buildPropertyValueFor(key, value)

  buildPropertyValueFor: (key, value) ->
    id: value.id
    name: value.name
    type: key
    propertyId: value.propertyId

  setEnabledState: (state) ->
    @$('[data-variants-matrix-variant-enabled]')
      .prop('checked', state)
      .trigger('change')

  onEnabledStateChanged: (e) ->
    checked = @$('[data-variants-matrix-variant-enabled]').prop('checked')
    @$el.toggleClass('disabled')

  setDestroyed: (state) ->
    @$el.find('[data-variant-remove]').val(if state then 'true' else 'false')

  onApplyToAllClicked: ->
    @trigger('applytoall', this)

  copyInputsFrom: (otherVariant) ->
    @$('input').each (i, el) ->
      otherValue = otherVariant.$('input').eq(i).val()
      $(el).val(otherValue)
