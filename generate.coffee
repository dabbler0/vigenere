fs = require 'fs'

letter = -> 'abcdefghijklmnopqrstuvwxyz '[Math.floor Math.random() * 27]

string = ''
for [0...10000]
  string += letter()

for n in [1..100]
  fs.writeFile "test#{n}.txt", string
