{spawn, exec} = require 'child_process'

_     = require 'lodash'
Q     = require 'q'
path  = require 'path'


# Full-resolve a binary installed by [npm](https://npmjs.org). As noted
# elsewhere, because the returned paths is absolute, even if a fully-resolvable
# alternative is available in the $PATH, this will cause the exec call to fail.
nodeBinary = (name) ->
  "./node_modules/.bin/#{name}"


# Adds manditory parameters to an existing environment. If no (or an empty)
# environment is given, this will use the current process' environment.
expandedEnv = (paths=[], existing) ->
  env      = (existing or _.clone(process.env) or {})
  nodePath = env['NODE_PATH']?.split(':') or []
  newPaths = (path.resolve(p) for p in paths).concat(nodePath)

  _.extend env,
    NODE_PATH: newPaths.join(':')


# Run a binary command from the path. The stdout and stderr of the forked
# process will be "redirected" to the current process.
bin = (cmd, args, opts) ->
  defaults =
    echo:   true
    paths:  ['./lib']

  opts    = _.extend(defaults, opts)
  def     = Q.defer()
  proc    = spawn cmd, args, env: expandedEnv(opts.paths)
  stdout  = ''
  stderr  = ''

  if opts.echo
    process.stdin.pipe(proc.stdin)
    proc.stdout.pipe(process.stdout)
    proc.stderr.pipe(process.stderr)
  else
    proc.stdout.on 'data', (s) -> stdout += s
    proc.stderr.on 'data', (s) -> stderr += s

  proc.on 'close', (exitCode) ->
    result =
      status:   exitCode
      stdout:   stdout
      stderr:   stderr
      cmd:      [cmd].concat(args).join(' ')
    if exitCode is 0 then def.resolve(result) else def.reject(result)

  return def.promise

debug = (cmd, args, opts) ->
  args = ['debug', cmd].concat(args)
  console.log "[DEBUG] node #{args.join(' ')}"
  bin('node', args, opts)

# Launch a binary installed by [npm](https://npmjs.org/). This will assume the
# binary is available in `./node_modules/.bin/` and will flat-out fail if the
# binary is available elsewhere. The semantics of the function are the same as
# `bin`.
node = (cmd, args, opts) ->
  bin(nodeBinary(cmd), args, opts)

nodeDebug = (cmd, args, opts) ->
  debug(nodeBinary(cmd), args, opts)


module.exports =
  nodeBinary:   nodeBinary
  expandedEnv:  expandedEnv
  bin:          bin
  node:         node
  nodeDebug:    nodeDebug
