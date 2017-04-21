#= require vertebra
#= require cocoon
#
#= require_self
#
#= require stall/add-to-cart-form
#= require stall/add-to-wish-list-button
#= require stall/product-list-form
#= require stall/addresses-fields
#= require stall/remote-sign-in-form
#= require stall/products-filters
#
#= require para/stall/inputs/variant-select
#= require para/lib/turbolinks-forms
#

@Stall =
  onDomReady: (callback) ->
    event = if window.Turbolinks && window.Turbolinks.supported
      'page:change turbolinks:load'
    else
      'ready'

    $(document).on(event, callback)
