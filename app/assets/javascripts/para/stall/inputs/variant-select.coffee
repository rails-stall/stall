class VariantSelectInput extends Vertebra.View
  events:
    'change [data-variant-select-property]': 'onInputChanged'

  initialize: ->
    @variants = @$el.data('variant-select-data')
    @$properties = @$('[data-variant-select-property]')
    @$foreignKey = @$('[data-variant-select-foreign-key]')
    @preparePriceTarget()
    @refreshSelectedVariant()

  preparePriceTarget: ->
    @$priceTarget = $(@$el.data('price-target'))
    return unless @$priceTarget.length
    @originalPrice = @$priceTarget.html()

  onInputChanged: ->
    @refreshSelectedVariant()

  refreshSelectedVariant: ->
    selectedProperties = @serializeSelectedProperties()
    variant = @fetchVariantWithProperties(selectedProperties)
    @updateSelectedVariantWith(variant)

  serializeSelectedProperties: ->
    selectedProperties = {}

    @$properties.each (i, el) ->
      $property = $(el)
      name = $property.data('variant-select-property')

      value = if $property.is('[data-preselected]')
        $property.find('[data-preselected-value]').val()
      else
        $property.find('input:checked, select').val()

      selectedProperties[name] = parseInt(value, 10)

    selectedProperties

  fetchVariantWithProperties: (properties) ->
    for variant in @variants
      matches = true
      matches = (matches and variant[key] is value) for key, value of properties when properties.hasOwnProperty(key)
      return variant if matches

    null

  updateSelectedVariantWith: (variant) ->
    value = if variant then variant.id else null
    @$foreignKey.val(value)
    @$foreignKey.trigger('change')
    @updatePriceWith(variant)

  updatePriceWith: (variant) ->
    return unless @$priceTarget.length
    price = if variant then variant.price else @originalPrice
    @$priceTarget.html(price)

$(document).on 'page:change turbolinks:load', ->
  $('[data-variant-select-input]').each (i, el) ->
    new VariantSelectInput(el: el)
