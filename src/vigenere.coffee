# Copy encipher method for testing
exports.ALPHABET = alphabet = ' ABCDEFGHIJKLMNOPQRSTUVWXYZ'
inverse = {}
for char, i in alphabet
  inverse[char] = i

exports.encipher = (message, key) ->
  result = ''
  for char, i in message
    result += alphabet[(inverse[char] + inverse[key[i % key.length]]) % alphabet.length]
  return result

exports.decipher = (message, key) ->
  result = ''
  for char, i in message
    result += alphabet[(inverse[char] - inverse[key[i % key.length]]) %% alphabet.length]
  return result
