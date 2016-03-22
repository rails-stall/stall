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
    $form = $(resp).find('[data-cart-form]')
    @$el.html($form.html())
    @clean()

Stall.onDomReady ->
  if ($cartForm = $('[data-cart-form]')).length
    new Stall.CartForm(el: $cartForm)
