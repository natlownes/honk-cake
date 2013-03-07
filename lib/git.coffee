# Helper [Cake](http://coffeescript.org/documentation/docs/cake.html) functions
# to deal with [Git](http://git-scm.com/) repositories.
exec = require './exec'


git = (args, opts={}) ->
  exec.bin('git', args, opts)


init = (path, callback) ->
  git(['init', path], echo: false)

branchName = (path) ->
  args = ['rev-parse', '--abbrev-ref', 'HEAD']
  if path? then args.push(path)

  git(args, echo: false).then (result) ->
    result.stdout.split('\n')[0]

module.exports =
  init:       init
  branchName: branchName
