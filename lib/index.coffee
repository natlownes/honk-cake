mocha = require './mocha'
docco = require './docco'


all = (callback) ->
  mocha.all()
  docco.all()


module.exports =
  all:    all
  mocha:  mocha
  docco:  docco
