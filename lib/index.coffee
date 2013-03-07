mocha = require './mocha'


all = (callback) ->
  task 'test', 'Run all Mocha tests', -> mocha.test(callback)

module.exports =
  all:    all
  mocha:  mocha
