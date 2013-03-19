mocha = require './mocha'
docco = require './docco'


all = (opts) ->
  mocha.all(opts)
  docco.all(opts)


module.exports =
  all:    all
  mocha:  mocha
  docco:  docco
