class VariantsMatrix.Input extends Vertebra.View
  events:
    'change [data-variants-matrix-property-select]': 'onPropertySelectChanged'

  initialize: ->
    @$variantsContainer = @$('[data-variants-matrix-variants-container]')
    @$propertySelects = @$('[data-variants-matrix-property-select]').selectize
      plugins: ['remove_button']

    @requireAllProperties = @$el.is('[data-require-all-properties]')
    @nestedFieldsManager = new VariantsMatrix.NestedFields(@$('[data-variants-matrix-new-row-button]'))

    @buildVariants()

  buildVariants: ->
    @variants = for el in @$('[data-variants-matrix-variant-row]').get()
      combination = @buildCombinationForRow(el)
      variant = new VariantsMatrix.Variant(el: el, combination: combination, input: this)
      @listenTo(variant, 'destroy', @onVariantDestroyed)

      variant

    @buildMissingVariants()

  buildMissingVariants: ->
    combinations = @buildPossibleCombinations()

    for combination in combinations
      unless @findVariantFor(combination)
        variant = @createVariantFor(combination)
        variant.setEnabledState(false)

  buildCombinationForRow: (row) ->
    combination = {}

    $(row).find('[data-variants-matrix-variant-property]').each (i, propertyCell) ->
      $property = $(propertyCell)
      type = $property.data('variants-matrix-variant-property')
      value = $property.find('[data-property-id]').val()
      combination[type] = value

    combination

  onPropertySelectChanged: (e) ->
    @refreshAvailableVariants()

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
    @variants.push(variant)

    variant

  # This methods loops through all select property options to create an array
  # of possible variant combinations to pre
  buildPossibleCombinations: ->
    selection = []

    # Create an intermediate hash containing
    @$propertySelects.each (i, el) ->
      $field = $(el)
      fieldName = $field.data('variants-matrix-property-select')
      value = $field.val() or []
      selection.push({ name: fieldName, values: value })

    combinations = []

    for property, index in selection
      new_combinations = []

      unless property.values.length
        # If a property has no option selected, we return an empty
        # combinations array if all properties are required, or we
        # go to the next iteration, leaving the combinations array untouched
        if @requireAllProperties then return [] else continue

      # For the first property array, we just fill the combinations array with
      # our property values
      if combinations.length is 0
        for value in property.values
          combination = {}
          combination[property.name] = value
          new_combinations.push(combination)

      # For other property arrays, we create a new array by combining each
      # existing combination with each property values of the current set
      else
        for item in combinations
          for value in property.values
            combination = VariantsMatrix.clone(item)
            combination[property.name] = value
            new_combinations.push(combination)

      # When the new combinations array is created, we replace the previous
      # one for next iterations to use it
      combinations = new_combinations

    combinations

  # Cleanup destroyed variants
  #
  onVariantDestroyed: (destroyedVariant) ->
    destroyedVariant.destroy()
    # Remove variant from @variants array
    @variants.splice(index, 1) for variant, index in @variants when variant?.matches(destroyedVariant.combination)

  # Allow fetching and caching property names without having to sideload them
  # in our view, in case they're really numerous
  #
  nameForProperty: (type, id) ->
    @propertyNamesCache ?= {}
    @propertyNamesCache[type] ?= {}
    @propertyNamesCache[type][id] ?= @$propertySelects
      .filter("[data-variants-matrix-property-select='#{ type }']")
      .find("[value='#{ id }']").text()
