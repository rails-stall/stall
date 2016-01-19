class Stall.AddToCartForm extends Vertebra.View
  @create = ($el) ->
    return if $el.data('stall.add-to-cart-form')
    instance = new Stall.AddToCartForm(el: $el)
    $el.data('stall.add-to-cart-form', instance)

  events:
    'ajax:success': 'onSuccess'

  onSuccess: (e, resp) ->
    @$modal = $(resp).appendTo('body').modal()
    @updateTotalQuantityCounter()

  updateTotalQuantityCounter: ->
    quantity = @$modal.data('cart-total-quantity')

    if ($counter = $('[data-cart-quantity-counter]')).length
      $counter.text(quantity)

Stall.onDomReady ->
  $('body').on 'ajax:beforeSend', '[data-add-to-cart-form]', (e) ->
    Stall.AddToCartForm.create($(e.currentTarget))
