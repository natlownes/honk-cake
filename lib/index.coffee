mocha = require './mocha'

all = (callback) ->
  task 'test',        'Run all Mocha tests', -> mocha.test(callback)
  task 'test:watch',  'Run all Mocha tests, watching for changes', -> mocha.watch(callback)

module.exports =
  all:    all
  mocha:  mocha
