mocha = require './mocha'

all = (callback) ->
  mocha.all()

module.exports =
  all:    all
  mocha:  mocha
