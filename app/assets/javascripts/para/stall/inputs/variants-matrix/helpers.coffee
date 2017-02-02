# Shallow clone objects
#
# Method borrowed from first snippet from :
# http://stackoverflow.com/questions/728360/how-do-i-correctly-clone-a-javascript-object
#
VariantsMatrix.clone = (obj) ->
  return obj if null is obj or "object" isnt typeof obj
  copy = obj.constructor()
  copy[key] = value for key, value of obj when obj.hasOwnProperty(key)
  copy

VariantsMatrix.objectsAreEqual = (a, b) ->
  for key, _ of a
    continue unless a.hasOwnProperty(key)
    return false unless a[key] is b[key]

  true
