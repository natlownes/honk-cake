expect  = require('chai').expect

exec    = require '../lib/exec'


describe 'Exec', ->

  describe 'nodeBinary', ->
    it 'should resolve an NPM node path', ->
      expect(exec.nodeBinary('pants')).to.equal './node_modules/.bin/pants'

  describe 'expandedEnv', ->
    it 'should add ./lib to the NODE_PATH', ->
      env = {NODE_PATH: 'zip'}
      expect(exec.expandedEnv(env)['NODE_PATH']).to.equal ('./lib:zip')

    it 'should use the procs env when none is given'
