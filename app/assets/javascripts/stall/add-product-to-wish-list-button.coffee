class Stall.AddProductToWishListButton extends Vertebra.View
  events:
    'click': 'onButtonClicked'

  onButtonClicked: ->
    if @$el.is('[data-included]') then @remove() else @add()

  add: ->
    @setLoading(true)

    data =
      product_id: @$el.data('product-id')

    $.post(@$el.data('url'), data).then(@onResponse)

  remove: ->
    @setLoading(true)

    data =
      _method: 'delete'

    $.post(@$el.data('url'), data).then(@onResponse)

  onResponse: (resp) =>
    @popover?.destroy()
    @setLoading(false)
    @setNewElement($(resp))

  setNewElement: ($el) ->
    @$el.tooltip('hide')
    @$el.replaceWith($el)
    @setElement($el)
    # Open popover if provided
    if (content = $el.data('popover-content')) then @openPopover(content)

  openPopover: (content) ->
    @popover = new Stall.WishListFormPopover(content: content)
    @popover.renderTo(@$el)
    @listenTo(@popover, 'send', => @setLoading(true))
    @listenTo(@popover, 'added', @onResponse)

  setLoading: (state) ->
    @popover?.hide()
    @$el.toggleClass('loading', state)
    @$('[data-wish-list-icon]').toggleClass('hidden', state)
    @$('[data-wish-list-loading-spinner]').toggleClass('hidden', !state)

class Stall.WishListFormPopover extends Vertebra.View
  events:
    'ajax:beforeSend [data-add-to-wish-list-form]': 'onBeforeSend'
    'ajax:success [data-add-to-wish-list-form]': 'onItemAdded'
    'click [data-cancel-button]': 'onCancelClicked'

  initialize: (options = {}) ->
    @content = options.content

  renderTo: ($parent) ->
    $parent.popover
      title: false
      content: @content
      html: true
      trigger: 'manual'
      placement: 'auto'
      container: 'body'

    @popover = $parent.data('bs.popover')
    @popover.show()

    @setElement(@popover.$tip)
    @initializeForm()

  initializeForm: ->
    @$('[data-variant-select-input]').each (i, el) ->
      new Stall.VariantSelectInput(el: el)

  hide: ->
    @popover?.hide()

  onBeforeSend: ->
    @trigger('send')

  onItemAdded: (e, resp) ->
    @trigger('added', resp)

  onCancelClicked: ->
    console.log 'onCancelClicked', this
    @destroy()

  destroy: ->
    return if @destroyed
    @popover.destroy()
    @popover = null
    super()
    @destroyed = true


Stall.onDomReady ->
  $('[data-add-to-wish-list="product"]').each (i, el) ->
    new Stall.AddProductToWishListButton(el: el)
