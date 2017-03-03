class Stall.ProductFilters extends Vertebra.View
  events:
    'change [data-filter]': 'filterChanged'

  initialize: ->
    console.log 'ProductFilters', @$el, @$('[data-filter]')

  filterChanged: ->
     @$el.submit()

Stall.onDomReady ->
  if ($productFilters = $('[data-product-filters]')).length
    new Stall.ProductFilters(el: $productFilters)
