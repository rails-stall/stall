class VariantsMatrix.Variant extends Vertebra.View
  events:
    'change [data-variants-matrix-variant-enabled]': 'onEnabledStateChanged'
    'click [data-variants-matrix-apply-to-all]': 'onApplyToAllClicked'

  initialize: (options = {}) ->
    @combination = options.combination
    @persisted = @$el?.data('variant-id')

    # This allows for destroying attributes mappings fields that are
    # automatically added after the actual table row.
    #
    # Not removing it produces an empty variant on each product creation
    #
    if @$el?.length is 1
      @setElement(@$el.add(@$el.next('[data-attributes-mappings]')))

    @isDestroyed = false
    @input = options.input

  renderTo: ($container) ->
    $variant = $(@input.nestedFieldsManager.render())
    $variant.appendTo($container)
    @setElement($variant)
    @$el.simpleForm()
    @fillProperties()

  fillProperties: ->
    # Reset all properties to hidden
    @$("[data-variants-matrix-variant-property]").addClass('hidden')

    for propertyValue in @propertyValues()
      $propertyValue = @$("[data-variants-matrix-variant-property='#{ propertyValue.propertyId }']")
      $propertyValue.find('[data-property-name]').html(propertyValue.name)
      $propertyValue.find('[data-property-value-id]').val(propertyValue.id)
      $propertyValue.removeClass('hidden')

  remove: ->
    @setDestroyed(true)

    if @persisted
      @$el.hide(0)
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
    @$el.toggleClass('disabled', !checked)

  setDestroyed: (state) ->
    @isDestroyed = state
    @$el.find('[data-variant-remove]').val(if @isDestroyed then 'true' else 'false')

  onApplyToAllClicked: ->
    @trigger('applytoall', this)

  copyInputsFrom: (otherVariant) ->
    @$('input:visible').each (i, el) =>
      otherValue = otherVariant.$('input:visible').eq(i).val()
      $(el).val(otherValue)
