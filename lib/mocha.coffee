exec = require './exec'

module.exports.test = (callback) ->
  options = [
    '--compilers', 'coffee:coffee-script'
    '--colors',
    '-R', 'spec'
  ]

  exec.node('mocha', options, callback)
