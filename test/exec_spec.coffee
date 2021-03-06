_       = require 'lodash'
expect  = require('chai').expect

exec    = require '../lib/exec'


describe 'Exec', ->

  beforeEach ->
    @_procEnv = _.clone(process.env)

  afterEach ->
    process.env = @_procEnv

  describe 'nodeBinary', ->
    it 'should resolve an NPM node path', ->
      expect(exec.nodeBinary('pants')).to.equal './node_modules/.bin/pants'

  describe 'expandedEnv', ->
    it 'should add expand and resolve paths in the node path', ->
      expanded = "#{process.cwd()}/lib"
      expect(exec.expandedEnv(['./lib'])['NODE_PATH']).to.equal (expanded)

    it 'should use the procs env when none is given', ->
      process.env['NODE_PATH'] = 'existing:bits'
      expanded = "#{process.cwd()}/foo:existing:bits"
      expect(exec.expandedEnv(['foo'])['NODE_PATH']).to.equal expanded

  describe 'bin', ->

    it 'should fork a proc', (done) ->
      exec.bin('ls', [], echo: false)
        .then (result) ->
          expect(result.status).to.equal 0
          done()
        .done()

    it 'should return the stdout of a proc', (done) ->
      exec.bin('echo', ['-en', 'pants town'], echo: false)
        .then (result) ->
          expect(result.stdout).to.equal 'pants town'
          done()
        .done()
