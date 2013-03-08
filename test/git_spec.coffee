expect  = require('chai').expect
temp    = require 'temp'

git   = require '../lib/git'
exec  = require '../lib/exec'


touchKeep = (root) ->
  cmd   = git.git(root)
  fname = "#{root}/.keep"

  exec.bin('touch', [fname], echo: false)
    .then -> cmd(['add', '.keep'], echo: false)
    .then -> cmd(['commit', '-m', 'Adding .keep file'], echo: false)


initWithKeep = (root) ->
  git.init(root).then -> touchKeep(root)


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
    dir = "#{@root}/branch-name"
    git.init(dir).then ->
      touchKeep(dir)
    .then ->
      git.branchName(dir)
    .then (name) ->
      expect(name).to.equal 'master'
      done()
    .done()

  it 'should checkout a branch', (done) ->
    dir = "#{@root}/checkout-branch"
    initWithKeep(dir).then ->
      git.branchName(dir)
    .then (name) ->
      expect(name).to.equal 'master'
      git.checkout(dir, '-b', 'gh-pages')
    .then  ->
      git.branchName(dir)
    .then (name) ->
      expect(name).to.equal 'gh-pages'
      done()
    .done()
