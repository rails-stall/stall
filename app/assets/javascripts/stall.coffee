#= require vertebra
#= require cocoon
#= require_self
#= require stall/add-to-cart-form
#= require stall/cart-form

@Stall =
  onDomReady: (callback) ->
    event = if window.Turbolinks && window.Turbolinks.supported
      'page:change turbolinks:load'
    else
      'ready'

    $(document).on(event, callback)
