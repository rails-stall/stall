class VariantsMatrix.PropertiesSelect extends Vertebra.View
  events:
    'change [data-variants-matrix-property-select]': 'onPropertySelectChanged'
    'change [data-variants-matrix-property-selector-input]': 'onPropertyChanged'
    'click [data-variants-matrix-property-selector-label]': 'onPropertyLabelClicked'

  initialize: ->
    @$propertySelects = @$('[data-variants-matrix-property-select]').selectize
      plugins: ['remove_button']

  # Serializes all selected properties into an array of hashes containing the
  # field name and the selected property values ids
  #
  getSelectedProperties: ->
    selectedProperties = []

    for el in @$propertySelects.get()
      $field = $(el)

      # Ensure the property is enabled
      $propertyListItem = $field.closest('[data-variants-matrix-property-id]')
      continue unless $propertyListItem.is(':visible')

      propertyId = parseInt($propertyListItem.data('variants-matrix-property-id'), 10)

      fieldName = $field.data('variants-matrix-property-select')
      values = @serializeFieldValues($field, propertyId)

      continue unless values?.length

      selectedProperties.push
        id: propertyId
        name: fieldName
        values: values
        active: !!values.length

    selectedProperties

  serializeFieldValues: ($field, propertyId) ->
    for option in $field.find(':selected').get()
      $option = $(option)
      { id: $option.attr('value'), name: $option.text(), propertyId: propertyId }

  onPropertyChanged: (e) ->
    $checkbox = $(e.currentTarget)
    isActive = $checkbox.is(':checked')
    propertyId = $checkbox.val()
    $target = @$("[data-variants-matrix-property-id='#{ propertyId }']")
    $target.toggleClass('hidden', !isActive)
    @trigger('change')

  onPropertyLabelClicked: (e) ->
    e.stopPropagation()

  onPropertySelectChanged: (e) ->
    @trigger('change')
