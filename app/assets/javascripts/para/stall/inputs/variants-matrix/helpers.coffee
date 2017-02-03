# Shallow clone objects
#
# Method borrowed from first snippet from :
# http://stackoverflow.com/questions/728360/how-do-i-correctly-clone-a-javascript-object
#
VariantsMatrix.clone = (obj) ->
  return obj if null is obj or 'object' isnt typeof obj
  copy = obj.constructor()

  for key, value of obj when obj.hasOwnProperty(key)
    copy[key] = if 'object' is typeof obj
      VariantsMatrix.clone(value)
    else
      value

  copy

VariantsMatrix.objectLength = (obj) ->
  length = 0
  length++ for key, _ of obj when obj.hasOwnProperty(key)
  length

VariantsMatrix.objectsAreEqual = (objectA, objectB) ->
  compareObjects = (a, b) ->
    for key, _ of a
      continue unless a.hasOwnProperty(key) or b.hasOwnProperty(key)

      return true if !a and !b
      return false unless a and b

      keyValuesAreEqual = if 'object' is typeof a[key]
        VariantsMatrix.objectsAreEqual(a[key], b[key])
      else
        a[key] is b[key]

      return false unless keyValuesAreEqual

    true

  compareObjects(objectA, objectB) and compareObjects(objectB, objectA)
