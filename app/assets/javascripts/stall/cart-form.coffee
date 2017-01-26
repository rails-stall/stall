class Stall.CartForm extends Vertebra.View
  events:
    'change [data-quantity-field]': 'formUpdated'
    'cocoon:after-remove': 'formUpdated'
    'ajax:success': 'updateSuccess'

  initialize: ->
    @clean()

  clean: ->
    @$('[data-cart-update-button]').hide(0)

  formUpdated: (e) ->
    @$el.submit()

  updateSuccess: (e, resp) ->
    @updateCartFormWith(resp)

  updateCartFormWith: (markup) =>
    $form = $(markup).find('[data-cart-form]')
    @$el.html($form.html())
    @clean()


Stall.onDomReady ->
  if ($cartForm = $('[data-cart-form]')).length
    cartForm = new Stall.CartForm(el: $cartForm)
    $cartForm.data('stall.cart-form', cartForm)
