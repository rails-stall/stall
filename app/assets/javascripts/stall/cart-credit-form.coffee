class Stall.CartCreditForm extends Vertebra.View
  events:
    'keyup [data-cart-credit-input]': 'onInputKeyUp'
    'click [data-cart-credit-button]': 'submit'
    'click [data-cart-credit-remove-button]': 'removeCreditUsage'

  initialize: ->
    @targetURL = @$el.data('cart-credit-form-url')
    @$input = @$('[data-cart-credit-input]')

  onInputKeyUp: (e) ->
    console.log 'onInputKeyUp', e.keyCode
    if e.keyCode is 13
      e.preventDefault()
      @submit()

  submit: ->
    value = @$input.val()
    $.post(@targetURL, amount: value, _method: 'patch').then(@onUpdate)

  onUpdate: (resp) =>
    if ($cartForm = $('[data-cart-form]')).length
      $cartForm.data('stall.cart-form').updateCartFormWith(resp)

  removeCreditUsage: ->
    $.post(@targetURL, _method: 'delete').then(@onUpdate)
