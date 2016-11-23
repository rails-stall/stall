class Stall.AddressesFields extends Vertebra.View
  events:
    'change [data-use-another-address-for-billing]': 'addressesSwitchChanged'

  initialize: ->
    @refresh()

  addressesSwitchChanged: ->
    @refresh()

  refresh: ->
    checked = @$('[data-use-another-address-for-billing]').is(':checked')
    @$('[data-address-form="billing"]').toggleClass('hidden', !checked)

Stall.onDomReady ->
  if ($addressesFields = $('[data-addresses-fields]')).length
    new Stall.AddressesFields(el: $addressesFields)
