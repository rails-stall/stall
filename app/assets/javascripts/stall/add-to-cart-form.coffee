class Stall.AddToCartForm extends Vertebra.View
  @create = ($el) ->
    unless (form = $el.data('stall.add-to-cart-form'))
      form = new Stall.AddToCartForm(el: $el)
      $el.data('stall.add-to-cart-form', form)

    form

  @validate = ($el) ->
    form = Stall.AddToCartForm.create($el)
    form.validate()

  @sendRequest = ($el) ->
    form = Stall.AddToCartForm.create($el)
    form.sendRequest()

  events:
    'ajax:success': 'onSuccess'
    'ajax:complete': 'onComplete'
    'change [name$="[sellable_id]"]': 'onValidatableFieldChanged'
    'change [name$="[quantity]"]': 'onValidatableFieldChanged'

  initialize: ->
    @$button = @$('[type="submit"]')
    @errorMessages = @$el.data('error-messages')

  sendRequest: ->
    return false unless (v = @validate(submit: true)) and (e = !@errors.length)
    @setLoading(true)
    true

  onValidatableFieldChanged: ->
    @validate()

  validate: (options = {})->
    @checkErrors()
    @refreshErrorsDisplay(options)
    !@errors.length

  checkErrors: ->
    @errors = []
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
    @removeExistingModal()
    @$modal = $(resp).appendTo('body').modal()
    @updateWidget()

  updateWidget: ->
    if ($widget = $('[data-cart-widget]'))
      $widget.replaceWith(@$modal.data('cart-widget-markup'))
    else if ($counter = $('[data-cart-quantity-counter]')).length
      $counter.text(@$modal.data('cart-total-quantity'))

  # Hide current modal and remove it from DOM when it's hidden
  #
  removeExistingModal: ->
    return unless ($modal = $('.modal')).length
    $modal.one('hidden.bs.modal', -> $modal.remove())
    $modal.modal('hide')

  # Displays errors in a tooltip on the form submit button, listing different
  # errors and disabling the submit button
  #
  refreshErrorsDisplay: (options = {}) ->
    @clearErrorMessages()
    @displayErrorMessages(options) if @errors.length

  displayErrorMessages: (options) ->
    messages = (@errorMessages[error] for error in @errors)
    message = messages.join('<br>')
    @$button.attr('data-original-title': message)
    @$button.tooltip(html: true)
    @$button.tooltip('enable')
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
  $('[data-add-to-cart-form]').each (i, el) ->
    Stall.AddToCartForm.validate($(el))

  $('body').on 'ajax:beforeSend', '[data-add-to-cart-form]', (e) ->
    Stall.AddToCartForm.sendRequest($(e.currentTarget))
