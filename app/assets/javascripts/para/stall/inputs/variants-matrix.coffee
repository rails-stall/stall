#= require_self
#= require ./variants-matrix/helpers
#= require ./variants-matrix/nested-fields
#= require ./variants-matrix/properties_select
#= require ./variants-matrix/input
#= require ./variants-matrix/variant

@VariantsMatrix = {}

$(document).on 'page:change turbolinks:load', ->
  $('[data-variants-matrix-input]').each (i, el) ->
    new VariantsMatrix.Input(el: el)
