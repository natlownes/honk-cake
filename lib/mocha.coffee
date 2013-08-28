# Tasks to help with a [Mocha](http://visionmedia.github.com/mocha/) project. By
# default, it is assumed that tests live in `./test/`, though the option can be
# overriden.
#
# By default, it's assumed that the test root is `./test/` and the reporter of
# choice is `spec`.

#
exec = require './exec'


# Fork mocha to run the test suite. Mocha must be present in
# `./node_modules/.bin`. Std(in|out) will be piped to the parent process
test = (files, reporter='spec', opts) ->
  args = [
    '--compilers', 'coffee:coffee-script',
    '--colors',
    '--recursive',
    '-R', reporter
    files
  ]

  exec.node('mocha', args, opts)

# Run mocha in "debug" mode -- this is slightly different than the "--debug"
# flag which will allow a debugger to attach. Rather this will drop you in to
# node's command line debugger during the test.
debug = (files, reporter='spec', opts) ->
  args = [
    'debug'
    '--compilers', 'coffee:coffee-script',
    '--colors',
    '--recursive',
    '-R', reporter
    files
  ]
  exec.node('mocha', args, opts)


# Use mocha's built in watch capabilities to trigger a test run when it a file
# changes.
watch = (files, opts) ->
  args = [
    '--compilers', 'coffee:coffee-script'
    '--colors',
    '--recursive',
    '-R', 'spec',
    '-w',
    files
  ]

  exec.node('mocha', args, opts)


# Load all of the Mocha tasks. If a root or spec is provided, they will be used
# for all applicable tasks. The executed tests can be limited in scope by
# providing a `--files` flag to cake (which will be exposed when this function
# is invoked).
all = (execOpts, root='./test/', reporter='spec') ->
  option '-f', '--files [FILES]', 'select which file to run tests for'
  files = (opts) -> opts.files or root

  task 'test', 'Run all Mocha tests', (opts) ->
    test(files(opts), reporter=reporter, execOpts)

  task 'test:debug', 'Run all Mocha tests with debugging enabled', (opts) ->
    debug(files(opts), reporter=reporter, execOpts)

  task 'test:watch', 'Run all Mocha tests, watching for changes', (opts) ->
    watch(files(opts), execOpts)


module.exports =
  all:    all
  test:   test
  watch:  watch
