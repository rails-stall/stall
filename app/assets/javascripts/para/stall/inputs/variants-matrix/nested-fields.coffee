nestedFieldsElementCounter = 0

# Class that allows rendering new nested fields as variant matrix rows, allowing
# usual cocoon-based nested fields rendering options, and para's model-scoped
# templates rendering as `admin/<model_name>/_variants_row.html.haml`
#
# The class is borrowed from Cocoon code to allow using existing server-side
# code. We couldn't directly use Cocoon's API since there's only a DOM event
# based API and no public access to underlying methods
#
class VariantsMatrix.NestedFields
  constructor: (@$button) ->
    @$button.remove()

  render: ->
    assoc                = @$button.data('association')
    assocs               = @$button.data('associations')
    content              = @$button.data('association-insertion-template')
    regexpBraced         = new RegExp('\\[new_' + assoc + '\\](.*?\\s)', 'g')
    regexpUnderscored    = new RegExp('_new_' + assoc + '_(\\w*)', 'g')
    newId                = @createNewId()
    newContent           = content.replace(regexpBraced, @newContentBraced(newId))

    if newContent is content
      regexpBraced     = new RegExp('\\[new_' + assocs + '\\](.*?\\s)', 'g')
      regexpUnderscored = new RegExp('_new_' + assocs + '_(\\w*)', 'g')
      newContent       = content.replace(regexpBraced, @newContentBraced(newId))

    newContent.replace(regexpUnderscored, @newContentUnderscored(newId))

  createNewId: ->
    new Date().getTime() + nestedFieldsElementCounter++

  newContentBraced: (id) ->
    "[#{ id }]$1"

  newContentUnderscored: (id) ->
    "_#{ id }_$1"
