{spawn, exec} = require 'child_process'

_ = require 'lodash'

stdout = (cmd, args, callback) ->
  proc = spawn cmd, args
  buf = ''
  proc.stdout.on 'data', (data) -> buf += data
  proc.on 'close', -> callback?(buf)

# Full-resolve a binary installed by [npm](https://npmjs.org). As noted
# elsewhere, because the returned paths is absolute, even if a fully-resolvable
# alternative is available in the $PATH, this will cause the exec call to fail.
nodeBinary = (name) ->
  "./node_modules/.bin/#{name}"


# Adds manditory parameters to an existing environment. If no (or an empty)
# environment is given, this will use the current process' environment.
expandedEnv = (existing) ->
  env      = (existing or process.env or {})
  nodePath = env['NODE_PATH']?.split(':') or []

  _.extend env,
    NODE_PATH: ['./lib'].concat(nodePath).join(':')


# Run a binary command from the path. The stdout and stderr of the forked
# process will be "redirected" to the current process.
bin = (cmd, options, callback) ->
  proc = spawn cmd, options, expandedEnv()
  proc.stdout.pipe(process.stdout)
  proc.stderr.pipe(process.stderr)
  proc.on 'exit', (status) -> callback?() if status is 0


# Launch a binary installed by [npm](https://npmjs.org/). This will assume the
# binary is available in `./node_modules/.bin/` and will flat-out fail if the
# binary is available elsewhere. The semantics of the function are the same as
# `bin`.
node = (cmd, options, callback) ->
  bin(nodeBinary(cmd), options, callback)

module.exports =
  nodeBinary:   nodeBinary
  expandedEnv:  expandedEnv
  bin:          bin
  node:         node