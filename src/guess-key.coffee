#!/usr/bin/env coffee

fs = require 'fs'
helper = require './helper.coffee'
crypt = require './cryptanalysis.coffee'
vigenere = require './vigenere.coffee'

MINLENGTH = 2
MAXLENGTH = 16

trueProbs = JSON.parse fs.readFileSync('./englishData.json').toString()
string = fs.readFileSync(process.argv[2]).toString()

console.log crypt.getKey trueProbs, string, MINLENGTH, MAXLENGTH
