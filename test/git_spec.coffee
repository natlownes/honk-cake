expect  = require('chai').expect
temp    = require 'temp'

git   = require '../lib/git'
exec  = require '../lib/exec'

describe 'Git helpers', ->

  beforeEach (done) ->
    temp.mkdir 'git-helpers-test-', (err, dir) =>
      expect(err).to.be.null
      @root = dir
      done()

  afterEach (done) ->
    exec.bin('rm', ['-rf', @root])
      .then -> done()
      .end()

  it 'should create an empty repo', (done) ->
    dir = "#{@root}/git-init-test"
    git.init(dir).then (result) ->
      expect(result.status).to.equal 0
      expect(result.stdout).to.equal "Initialized empty Git repository in #{dir}/.git/\n"
      done()
    .end()

  it 'should determine a branch name', (done) ->
    dir = "#{@root}/git-init-test"
    git.init(dir)
      .then -> git.branchName(dir)
      .then (name)->
        expect(name).to.equal 'master'
        done()
      .end()
