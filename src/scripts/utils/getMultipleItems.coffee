# Returns items from an array

module.exports = (fn, num) ->
  arr = []
  i = 0
  while i < num
    arr.push fn()
    i++
  return arr
