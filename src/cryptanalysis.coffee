numeric = require 'numeric'
vigenere = require './vigenere.coffee'
helper = require './helper.coffee'

# Get letter counts for a given document, separated by (stride). e.g. if stride is 7, determine 7 sets
# of letter counts, each one corresponding to one starting offset for every 7th letter.
exports.count = count = (string, stride) ->
  profiles = ({} for [0...stride])

  for profile in profiles
    for token in vigenere.ALPHABET
      profile[token] = 0

  for char, i in string by stride
    for j in [0...stride] when i + j < string.length
      profiles[j][string[i + j]] += 1

  return profiles.map (profile) ->
    vigenere.ALPHABET.split('').map (token) -> profile[token]

# Solve a caesar cipher. We do this by testing all 27 possible cyclic shifts of the probabilities and seeing
# which one matches the real probabilities best. We compute this "matching" by determining the probability
# of the corpus under the guessed cyclic shift:
#   P(corpus)
#     = product of P(letter|shift) over letters
#     = product of P(letter|shift)^count(letter) over letters in alphabet
#     = e^dot product(log(P(letter|shift), counts)
#
# We return both the discovered shift and the log probability of the corpus under that shift.
exports.decaesar = decaesar = (trueProbs, profile) ->
  cyclic = profile
  max = -Infinity; best = null
  for el, i in cyclic
    # Determine the log probability of the corpus under this cyclic shift
    prob = numeric.dot trueProbs, cyclic
    if prob > max
      max = prob
      best = i

    cyclic.push cyclic.shift()

  return {
    key: vigenere.ALPHABET[best]
    score: max
  }

# Test a key length. We do this by solving (n) caesar ciphers,
# each on a stride-separated portion of the document (so we solve,
# for instance, the caesar cipher for every seventh letter), and determining
# the probability of the document under the guessed key.
# Note that this is the same as taking the product of the probabilities of all
# the probabilities of the stride-separated parts of the document.
exports.testStride = testStride = (trueProbabilities, string, stride) ->
  sortedProfiles = count string, stride

  key = ''
  score = 0
  for profile in sortedProfiles
    result = decaesar trueProbabilities, profile
    key += result.key
    score += result.score

  return {key, score}

# Find the key by testing all the possible key lengths and getting the most probable one.
exports.getKey = getKey = (trueProbabilities, string, minlength = 2, maxlength = 16) ->
  max = -Infinity; best = null
  for stride in [minlength..maxlength]
    {key, score} = testStride trueProbabilities, string, stride
    if score > max
      best = key
      max = score

  return best
