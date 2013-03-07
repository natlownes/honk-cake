exec = require './exec'

test = (files) ->
  args = [
    '--compilers', 'coffee:coffee-script'
    '--colors',
    '-R', 'spec',
    files
  ]

  exec.node('mocha', args)


watch = (files) ->
  args = [
    '--compilers', 'coffee:coffee-script'
    '--colors',
    '-R', 'spec',
    '-w',
    files
  ]

  exec.node('mocha', args)

all = ->
  option '-f', '--files [FILES]', 'select which file to run tests for'

  task 'test', 'Run all Mocha tests', (opts) ->
    test(opts.files or './test/')

  task 'test:watch', 'Run all Mocha tests, watching for changes', (opts) ->
    watch(opts.files or './test/')

module.exports =
  all:    all
  test:   test
  watch:  watch
