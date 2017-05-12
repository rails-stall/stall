class Stall.AddToWishListButton extends Vertebra.View
  events:
    'click': 'add'

  initialize: ->
    @url = @$el.data('url')

  add: ->
    data = @$el.closest('form').serialize()
    $.post(@url, data).then(@onResponse)

  onResponse: (resp) =>
    $(resp).modal()

Stall.onDomReady ->
  $('[data-add-to-wish-list="line-item-form"]').each (i, el) ->
    new Stall.AddToWishListButton(el: el)
