# Helper functions

exports.normalize = (arr) ->
  total = arr.reduce (a, b) -> a + b
  arr = arr.map (x) -> Math.log x / total
  return arr

exports.tokenize = (string) -> string.toUpperCase().replace(/\s/g, ' ').replace(/[^A-Z ]/g, '').replace(/\s+/g, ' ')
