fs = require 'fs'
vigenere = require './vigenere.coffee'
helper = require './helper.coffee'

fs.writeFile process.argv[4], vigenere.encipher helper.tokenize(fs.readFileSync(process.argv[2]).toString()), process.argv[3]
