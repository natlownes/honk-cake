# Helper [Cake](http://coffeescript.org/documentation/docs/cake.html) functions
# to deal with [Git](http://git-scm.com/) repositories.
exec = require './exec'


# Create a function that can execute git commands in the specified directory. It
# can be reused. The resulting function will take a variable number of arguments
# and return a promise of the result of the forked process. If `root` is
# omitted, it assumes the current working directory.
#
# It's assumed that the given `root` points to a non-bare git repo.
git = (root) ->
  root or= process.env['PWD']
  (args, opts) ->
    dirArgs = ["--work-tree=#{root}", "--git-dir=#{root}/.git"]
    exec.bin('git', dirArgs.concat(args), opts)


# Initializes an empty non-bare repository at the specified location. If `root`
# is omitted, the current working directory is assumed.
init = (root) ->
  exec.bin('git', ['init', root], echo: false)

# Determine the current branch of the specified `root`. If no `root` is given,
# the current working directory is assumed.
branchName = (root) ->
  args = ['rev-parse', '--abbrev-ref', 'HEAD']
  git(root)(args, echo: false).then (result) ->
    result.stdout.split('\n')[0]


checkout = (root, args...) ->
  git(root)(['checkout'].concat(args), echo: false)


module.exports =
  git:        git
  init:       init
  branchName: branchName
  checkout:   checkout
