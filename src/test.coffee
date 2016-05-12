fs = require 'fs'
helper = require './helper.coffee'
crypt = require './cryptanalysis.coffee'
vigenere = require './vigenere.coffee'

MINLENGTH = 2
MAXLENGTH = 16
MESSAGE_LENGTH_MIN = MAXLENGTH * 2048 / 16
MESSAGE_LENGTH_MAX = MESSAGE_LENGTH_MIN * 50
NUM_TESTS = 1000

# Generate a random key
generateKey = (minlength = MINLENGTH, maxlength = MAXLENGTH) ->
  length = Math.floor Math.random() * (maxlength - minlength) + minlength
  return [1..length].map((x) -> vigenere.ALPHABET[Math.floor Math.random() * vigenere.ALPHABET.length]).join ''

# Test to see if two keys are equivalent
equivalent = (a, b) ->
  if a is b
    return true

  resulta = resultb = ''

  for [0...a.length]
    resulta += b

  for [0...b.length]
    resultb += a

  return resulta is resultb

# TRAINING: Read out all the data files
testcorpus = ''
for file in fs.readdirSync process.argv[3]
  testcorpus += helper.tokenize fs.readFileSync(process.argv[3] + '/' + file).toString()

trueProbs = JSON.parse fs.readFileSync('./englishData.json').toString()

# Test something
runtest = ->
  substringBegin = Math.floor Math.random() * (testcorpus.length - MESSAGE_LENGTH_MAX)
  range = [substringBegin, substringBegin + Math.random() * (MESSAGE_LENGTH_MAX - MESSAGE_LENGTH_MIN) + MESSAGE_LENGTH_MIN]
  substring = testcorpus[range[0]..range[1]]
  key = generateKey()

  enciphered = vigenere.encipher substring, key

  newkey = crypt.getKey trueProbs, enciphered, MINLENGTH, MAXLENGTH
  return {
    result: equivalent(key, newkey)
    key, newkey, substring
  }

accuracy = 0
for [0...NUM_TESTS]
  result = runtest()
  if result.result
    console.log 'SUCCESS'
    accuracy += 1
  else
    console.log 'FAILURE', '|', JSON.stringify(result.key), '|', JSON.stringify(result.newkey)
    fs.appendFileSync 'errors.log', JSON.stringify(result) + '\n'
console.log 'ACCURACY:', (accuracy / NUM_TESTS * 100), '%'
