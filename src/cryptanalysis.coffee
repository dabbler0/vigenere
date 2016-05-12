numeric = require 'numeric'
vigenere = require './vigenere.coffee'
helper = require './helper.coffee'

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

exports.decaesar = decaesar = (trueProbs, profile) ->
  cyclic = profile
  max = -Infinity; best = null
  for el, i in cyclic
    prob = numeric.dot trueProbs, cyclic
    if prob > max
      max = prob
      best = i

    cyclic.push cyclic.shift()

  return {
    key: vigenere.ALPHABET[best]
    score: max
  }

exports.testStride = testStride = (trueProbabilities, string, stride) ->
  sortedProfiles = count string, stride

  key = ''
  score = 0
  for profile in sortedProfiles
    result = decaesar trueProbabilities, profile
    key += result.key
    score += result.score

  return {key, score}

exports.getKey = getKey = (trueProbabilities, string, minlength = 2, maxlength = 16) ->
  max = -Infinity; best = null
  for stride in [minlength..maxlength]
    {key, score} = testStride trueProbabilities, string, stride
    if score > max
      best = key
      max = score

  return best
