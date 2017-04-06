class Stall.ProductsFilters extends Vertebra.View
  events:
    'change [data-filter-submission="change"]': 'filterChanged'
    'slideStop [data-filter-submission="slide"]': 'filterChanged'

  filterChanged: (e) ->
    @submit()

  submit: ->
    setTimeout((=> @$el.submit()), 0)

  setSubmitted: (e) ->
    console.log 'setSubmitted // submitted : ', @submitted

    return e.preventDefault() if @submitted
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
  $('[data-products-filters]').each (i, el) -> new Stall.ProductsFilters(el: el)
