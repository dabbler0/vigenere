helper = require './helper.coffee'
fs = require 'fs'
crypt = require './cryptanalysis.coffee'

traincorpus = ''
for file in fs.readdirSync process.argv[2]
  traincorpus += helper.tokenize fs.readFileSync(process.argv[2] + '/' + file).toString()

trueProbs = helper.normalize crypt.count(traincorpus, 1)[0]

fs.writeFile 'englishData.json', JSON.stringify(trueProbs)
