class VariantsMatrix.Input extends Vertebra.View
  initialize: ->
    @$variantsContainer = @$('[data-variants-matrix-variants-container]')
    @$variantsTableHeader = @$('[data-variants-matrix-variants-table-header]')

    @propertiesSelect = new VariantsMatrix.PropertiesSelect(el: @$('[data-variants-matrix-properties-select]'))
    @listenTo(@propertiesSelect, 'change', @onPropertySelectChanged)

    @nestedFieldsManager = new VariantsMatrix.NestedFields(@$('[data-variants-matrix-new-row-button]'))

    @buildVariants()

  buildVariants: ->
    existingCombinations = @buildPossibleCombinations()

    @variants = for row in @$('[data-variants-matrix-variant-row]').get()
      combination = @findCombinationForRow(row, existingCombinations)
      variant = new VariantsMatrix.Variant(el: row, combination: combination, input: this)
      @listenTo(variant, 'applytoall', @onVariantApplyToAll)
      @listenTo(variant, 'destroy', @onVariantDestroyed)

      variant

  findCombinationForRow: (row, existingCombinations) ->
    propertyValues = for propertyCell in $(row).find('[data-variants-matrix-variant-property]').get()
      $property = $(propertyCell)
      propertyId = $property.data('variants-matrix-variant-property')
      valueId = $property.find('[data-property-value-id]').val()
      { propertyId: propertyId, id: valueId }

    return combination for combination in existingCombinations when @combinationMatches(propertyValues, combination)

  combinationMatches: (propertyValues, combination) ->
    for combinationProperty in combination
      propertyValue = value for value in propertyValues when value.propertyId is combinationProperty.propertyId
      combinationValueMatches = combinationProperty and combinationProperty.id is propertyValue.id

      return false unless combinationValueMatches

    # Return true if all property values where found in combination
    true


  onPropertySelectChanged: (e) ->
    @refreshAvailableProperties()
    @refreshAvailableVariants()

  refreshAvailableProperties: ->
    propertyHeaderCells = for property in @propertiesSelect.getSelectedProperties() when property.active
      $('<th/>', 'data-variants-matrix-variant-property-cell': '').text(property.name)

    @$variantsTableHeader.find('[data-variants-matrix-variant-property-cell]').remove()
    $enabledCell = @$variantsTableHeader.find('[data-variants-matrix-variant-enabled-cell]')
    $enabledCell.after(propertyHeaderCells)

  refreshAvailableVariants: ->
    combinations = @buildPossibleCombinations()
    @removeVariantsNotIn(combinations)
    @createVariantsIn(combinations)

  removeVariantsNotIn: (combinations) ->
    removeableVariants = []

    for variant, index in @variants
      continue unless variant
      matches = false
      matches = true for combination in combinations when variant.matches(combination)
      removeableVariants.push(variant) unless matches

    # We remove variants after iterating, avoiding to change array indexes
    # while we loop through it to match removeable variants
    variant.remove() for variant in removeableVariants

  createVariantsIn: (combinations) ->
    for combination in combinations
      existingVariant = @findVariantFor(combination)
      variant = existingVariant or @createVariantFor(combination)
      variant.show()

  findVariantFor: (combination) ->
    return variant for variant, index in @variants when variant.matches(combination)

  createVariantFor: (combination) ->
    variant = new VariantsMatrix.Variant(combination: combination, input: this)
    variant.renderTo(@$variantsContainer)
    @listenTo(variant, 'destroy', @onVariantDestroyed)
    @listenTo(variant, 'applytoall', @onVariantApplyToAll)
    @variants.push(variant)

    variant

  # This methods loops through all select property options to create an array
  # of possible variant combinations to pre
  buildPossibleCombinations: ->
    selection = @propertiesSelect.getSelectedProperties()

    combinations = []

    for property, index in selection
      new_combinations = []

      # If a property has no option selected, we go to the next iteration,
      # leaving the combinations array untouched
      continue unless property.values.length

      # For the first property array, we just fill the combinations array with
      # our property values
      if combinations.length is 0
        for value in property.values
          combination = []
          combination.push(value)
          new_combinations.push(combination)

      # For other property arrays, we create a new array by combining each
      # existing combination with each property values of the current set
      else
        for item in combinations
          for value in property.values
            combination = VariantsMatrix.clone(item)
            combination.push(value)
            new_combinations.push(combination)

      # When the new combinations array is created, we replace the previous
      # one for next iterations to use it
      combinations = new_combinations

    combinations

  onVariantApplyToAll: (variant) =>
    v.copyInputsFrom(variant) for v in @variants when v.cid isnt variant.cid

  # Cleanup destroyed variants
  #
  onVariantDestroyed: (destroyedVariant) ->
    destroyedVariant.destroy()
    # Remove variant from @variants array
    @variants.splice(index, 1) for variant, index in @variants when variant?.matches(destroyedVariant.combination)

