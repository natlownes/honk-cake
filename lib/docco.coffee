Q     = require 'q'
temp  = require 'temp'
walk  = require 'walk'

exec  = require './exec'
git   = require './git'


tmpDir = (prefix='docco') ->
  d = Q.defer()
  temp.mkdir prefix, (err, dir) ->
    if err? then d.reject(err) else d.resolve(dir)
  d.promise

docco = (root, output) ->
  root    or= process.env['PWD']
  output  or= './docs'

  walkFiles(root).then (files) ->
    exec.node('docco', files.concat(['-o', output]), echo: false)
    .then(-> walkFiles(output))

walkFiles = (root) ->
  d = Q.defer()
  files = []
  walker = walk.walk(root)

  walker.on 'file', (root, stat, next) ->
    files.push([root, stat.name].join('/'))
    next()

  walker.on 'end', -> d.resolve(files)

  d.promise

# This command will not push any changes, but will leave you in the specified
# branch with the documention in place.
publish = (srcRoot, branch, origin) ->
  srcRoot or= process.env['PWD']
  branch  or= 'gh-pages'
  origin  or= 'origin'

  tmpDir().then (docRoot) ->
    srcGit = git.git(srcRoot)
    docGit = git.git(docRoot)

    # srcUrl      = srcGit(['config', '--get', "remote.#{origin}.url"], echo: false)
    # origBranch  = git.branchName(srcRoot)

    docco("#{srcRoot}/lib", docRoot)
      .then(-> walkFiles(docRoot))
      .then((files) ->
        git.init(docRoot)
          .then(-> srcGit(['config', '--get', "remote.#{origin}.url"], echo: false))
          .then((result) ->
            remote = result.stdout.split('\n')[0]
            docGit(['remote', 'add', 'origin', remote], echo: false)
          )
          .then(-> docGit(['checkout', '-b', branch], echo: false))
          .then(-> docGit(['add'].concat(files)))
          .then(-> docGit(['commit', '-m', 'Documentation update']))
          .then(-> docGit(['push', '--force', 'origin', branch], echo: false))
      )

  # tmpDir().then (docRoot) ->

  #   docFiles

  #   prepDocRoot = git.init(docRoot).then ->
  #     srcGit(['config', '--get', "remote.#{origin}.url"], echo: false)
  #     .then (url) -> docGit(['remote', 'add', 'origin', url.stdout], echo: false)

  #   Q.all([prepDocRoot, docco(srcRoot, docRoot)]).then (origin) ->
  #     docGit(['add',

  #     docGit(['commit', '-a', '-m', 'Updated documentation'])
  #     .then( -> docGit(['push', 'origin', branch]))

  # docFiles = (tmpDir().then (docRoot) ->
  #   docco(srcRoot, docRoot).then -> walkFiles(docRoot))

  # stage = docFiles.then (files) ->
  #   console.log('FILES', files)
  #   git.checkout(srcRoot, '-b', branch).then ->
  #     exec.bin('mv', files.concat(['.']))


all = ->
  task 'doc', 'Generate Docco documentation', -> docco()
  task 'doc:publish', 'Publish docco docs to gh-pages', -> publish()


module.exports =
  all:  all
