exec = require './exec'

test = (callback) ->
  options = [
    '--compilers', 'coffee:coffee-script'
    '--colors',
    '-R', 'spec'
  ]

  exec.node('mocha', options, callback)

watch = (callback) ->
  options = [
    '--compilers', 'coffee:coffee-script'
    '--colors',
    '-R', 'spec',
    '-w'
  ]

  exec.node('mocha', options, callback)

module.exports =
  test:   test
  watch:  watch
