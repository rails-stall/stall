class Stall.ProductListForm extends Vertebra.View
  events:
    'change [data-quantity-field]': 'formUpdated'
    'cocoon:after-remove': 'formUpdated'
    'ajax:success': 'updateSuccess'

  initialize: ->
    @clean()

  clean: ->
    @$('[data-product-list-update-button]').hide(0)
    # Backwards compatibility with app overriden cart forms
    @$('[data-cart-update-button]').hide(0)

  formUpdated: (e) ->
    @$el.submit()

  updateSuccess: (e, resp) ->
    @updateProductListFormWith(resp)

  updateProductListFormWith: (markup) =>
    $form = $(markup).find('[data-product-list-form], [data-cart-form]')
    @$el.html($form.html())
    @clean()


Stall.onDomReady ->
  # Backwards compatibility with app overriden cart forms
  if ($product_listForm = $('[data-product-list-form], [data-cart-form]')).length
    product_listForm = new Stall.ProductListForm(el: $product_listForm)
    $product_listForm.data('stall.product-list-form', product_listForm)
