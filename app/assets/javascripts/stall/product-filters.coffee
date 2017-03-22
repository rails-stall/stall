class Stall.ProductFilters extends Vertebra.View
  events:
    'change [data-filter-submission="change"]': 'filterChanged'
    'slideStop [data-filter-submission="slide"]': 'filterChanged'

  filterChanged: (e) ->
    return if @submitted
    @setSubmitted()
    setTimeout((=> @$el.submit()), 0)

  setSubmitted: ->
    @submitted = true

    $overlay = $('<div/>', class: 'overlay').css(
      position: 'absolute',
      width: '100%',
      height: '100%',
      background: '#fafafa',
      zIndex: '100',
      opacity: '0.4'
    )

    @$el.prepend($overlay)

Stall.onDomReady ->
  if ($productFilters = $('[data-product-filters]')).length
    new Stall.ProductFilters(el: $productFilters)
