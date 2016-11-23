# This class handles the sign in form inside the checkout process, allowing the
# customers to sign in directly during the checkout, without leaving the
# process.
#
class Stall.RemoteSignInForm extends Vertebra.View
  @create = ($el) ->
    unless (instance = $el.data('stall.remote-sign-in-form'))
      instance = new Stall.RemoteSignInForm(el: $el)
      instance.onBeforeSend()
      $el.data('stall.remote-sign-in-form', instance)

  events:
    'ajax:beforeSend': 'onBeforeSend'
    'ajax:success': 'onSuccess'
    'ajax:error': 'onError'

  initialize: ->
    # We store the current URL to allow refreshing the page after the user
    # signed in, since Turbolinks 5 automatically forces the browser to follow
    # server redirections by evaluating javascript in the browser. Since we
    # don't want to configure Devise (or other gems) server-side, we work-around
    # this issue by running a second redirection, manually, with the URL we
    # store here
    @currentURL = window.location.href

  onBeforeSend: ->
    @setLoading(true)

  onSuccess: (e, response) ->
    @setLoading(false)
    @removeFlashMessage()
    Turbolinks.visit(@currentURL)

  onError: (e, jqXHR) ->
    @setFlashMessage(jqXHR.responseText, type: 'danger')
    @setLoading(false)

  setLoading: (loading) ->
    state = if loading then 'loading' else 'reset'
    @$('[data-sign-in-submit-btn]').button(state)

  setFlashMessage: (message, options = {}) ->
    @removeFlashMessage()
    alertClass = "alert alert-#{ options.type }"
    $('<div/>', class: alertClass, 'data-flash': true)
      .html(message).prependTo(@$el)

  removeFlashMessage: ->
    @$('[data-flash]').remove()


Stall.onDomReady ->
  $('[data-stall-remote-sign-in-form]').each (i, el) ->
    $(el).one 'ajax:beforeSend', (e) ->
      Stall.RemoteSignInForm.create($(e.currentTarget))
