class Stall.AddToCartForm extends Vertebra.View
  @create = ($el) ->
    unless (instance = $el.data('stall.add-to-cart-form'))
      instance = new Stall.AddToCartForm(el: $el)
      $el.data('stall.add-to-cart-form', instance)

    instance.sendRequest()

  events:
    'ajax:success': 'onSuccess'
    'ajax:complete': 'onComplete'
    'change [name$="[sellable_id]"]': 'onValidatableFieldChanged'
    'change [name$="[quantity]"]': 'onValidatableFieldChanged'

  initialize: ->
    @$button = @$('[type="submit"]')
    @errorMessages = @$el.data('error-messages')

  sendRequest: ->
    return false unless @validate(submit: true) and !@errors.length
    @setLoading(true)
    true

  onValidatableFieldChanged: ->
    @validate()

  validate: (options = {})->
    @checkErrors()
    @refreshErrorsDisplay(options)

  checkErrors: ->
    @errors = []
    console.log 'CHECK ERRORS'
    console.log 'sellable_id', @$('[name$="[sellable_id]"]').val(), @sellableChosen()
    console.log 'quantity', @$('[name$="[quantity]"]').val(), @quantityFilled()

    @errors.push('choose') unless @sellableChosen()
    @errors.push('quantity') unless @quantityFilled()

  sellableChosen: ->
    !!@$('[name$="[sellable_id]"]').val()

  quantityFilled: ->
    quantity = parseInt(@$('[name$="[quantity]"]').val(), 10)
    quantity > 0

  onComplete: ->
    @setLoading(false)

  onSuccess: (e, resp) ->
    @$modal = $(resp).appendTo('body').modal()
    @updateWidget()

  updateWidget: ->
    if ($widget = $('[data-cart-widget]'))
      $widget.replaceWith(@$modal.data('cart-widget-markup'))
    else if ($counter = $('[data-cart-quantity-counter]')).length
      $counter.text(@$modal.data('cart-total-quantity'))

  # Displays errors in a tooltip on the form submit button, listing different
  # errors and disabling the submit button
  refreshErrorsDisplay: (options = {}) ->
    @clearErrorMessages()
    @displayErrorMessages(options) if @errors.length

  displayErrorMessages: (options) ->
    messages = (@errorMessages[error] for error in @errors)
    message = messages.join('<br>')
    @$button.attr(title: message)
    @$button.tooltip(html: true)
    # Force tooltip display if the user just submitted the form
    @$button.tooltip('show') if options.submit
    @$button.prop('disabled', true)

  clearErrorMessages: ->
    @$button.attr(title: '')
    @$button.tooltip('disable') if @$button.data('bs.tooltip')
    @$button.prop('disabled', false)


  setLoading: (loading) ->
    state = if loading then 'loading' else 'reset'
    @$button.button(state)


Stall.onDomReady ->
  $('body').on 'ajax:beforeSend', '[data-add-to-cart-form]', (e) ->
    Stall.AddToCartForm.create($(e.currentTarget))
