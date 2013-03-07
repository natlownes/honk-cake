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
      .then ->
        done()
      .done()

  it 'should create an empty repo', (done) ->
    dir  = "#{@root}/init"
    git.init(dir).then (result) =>
      expect(result.status).to.equal 0
      expect(result.stdout).to.equal "Initialized empty Git repository in #{dir}/.git/\n"
      done()
    .done()

  it 'should determine a branch name', (done) ->
    # TODO: This will actually give you the branch name of the current
    #       directory. Classic!
    dir  = "#{@root}/branch-name"
    git.init(dir)
      .then -> git.branchName(dir)
      .then (name) ->
        expect(name).to.equal 'master'
        done()
      .done()

  it 'should checkout a branch'
  # it 'should checkout a branch', (done) ->
  #   dir = @dir
  #   git.init(dir)
  #     .then -> git.branchName(dir)
  #     .then (name) ->
  #       expect(name).to.equal 'master'
  #       git.checkout('-b', 'gh-pages')
  #     .then (result) ->
  #       console.log result
  #       done()
  #     .end()
