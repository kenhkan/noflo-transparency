noflo = require 'noflo'
_str = require 'underscore.string'

unless noflo.isBrowser()
  chai = require 'chai' unless chai
  Render = require '../components/Render.coffee'
else
  Render = require 'test/components/Render.js'

describe 'Render component', ->
  globals = {}

  beforeEach ->
    globals.c = Render.getComponent()
    globals.ins = noflo.internalSocket.createSocket()
    globals.template = noflo.internalSocket.createSocket()
    globals.root= noflo.internalSocket.createSocket()
    globals.out = noflo.internalSocket.createSocket()
    globals.c.inPorts.in.attach globals.ins
    globals.c.inPorts.template.attach globals.template
    globals.c.inPorts.root.attach globals.root
    globals.c.outPorts.out.attach globals.out

  describe 'when instantiated', ->
    it 'should have an input port', ->
      chai.expect(globals.c.inPorts.in).to.be.an 'object'
      chai.expect(globals.c.inPorts.template).to.be.an 'object'
      chai.expect(globals.c.inPorts.root).to.be.an 'object'
    it 'should have an output port', ->
      chai.expect(globals.c.outPorts.out).to.be.an 'object'

  describe 'templating', ->
    it 'accepts a template and outputs as-is if input is an empty object', (done) ->
      template = '''
        <html>
          <body>
            <div id="div"></div>
          </body>
        </html>
      '''
      output = template
      bindings = {}

      globals.out.on 'data', (data) ->
        chai.expect(_str.clean data).to.equal _str.clean output

      globals.out.on 'disconnect', ->
        done()

      globals.template.send template
      globals.template.disconnect()

      globals.ins.send bindings
      globals.ins.disconnect()

    it 'replaces template bindings with object', (done) ->
      template = '''
        <html>
          <body>
            <div id="div">
              <div id="name"></div>
              <div class="gender"></div>
            </div>
          </body>
        </html>
      '''
      output = '''
        <html>
          <body>
            <div id="div">
              <div id="name">Ken</div>
              <div class="gender">m</div>
            </div>
          </body>
        </html>
      '''
      bindings =
        name: 'Ken'
        gender: 'm'

      globals.out.on 'data', (data) ->
        chai.expect(_str.clean data).to.equal _str.clean output

      globals.out.on 'disconnect', ->
        done()

      globals.template.send template
      globals.template.disconnect()

      globals.ins.send bindings
      globals.ins.disconnect()

    it 'replaces template iterating bindings with arrays', (done) ->
      template = '''
        <html>
          <body>
            <div>
              <div class="name"></div>
              <div class="gender"></div>
            </div>
          </body>
        </html>
      '''
      output = '''
        <html>
          <body>
            <div>
              <div class="name">Ken</div>
              <div class="gender">m</div>
            </div>
          </body>
          <body>
            <div>
              <div class="name">Jen</div>
              <div class="gender">f</div>
            </div>
          </body>
        </html>
      '''
      bindings = [
        {
          name: 'Ken'
          gender: 'm'
        }
        {
          name: 'Jen'
          gender: 'f'
        }
      ]

      globals.out.on 'data', (data) ->
        chai.expect(_str.clean data).to.equal _str.clean output

      globals.out.on 'disconnect', ->
        done()

      globals.template.send template
      globals.template.disconnect()

      globals.ins.send bindings
      globals.ins.disconnect()

    it 'replaces template iterating bindings with arrays in object', (done) ->
      template = '''
        <html>
          <body class="iterate">
            <div>
              <div class="name"></div>
              <div class="gender"></div>
            </div>
          </body>
        </html>
      '''
      output = '''
        <html>
          <body class="iterate">
            <div>
              <div class="name">Ken</div>
              <div class="gender">m</div>
            </div>

            <div>
              <div class="name">Jen</div>
              <div class="gender">f</div>
            </div>
          </body>
        </html>
      '''
      bindings =
        iterate: [
          {
            name: 'Ken'
            gender: 'm'
          }
          {
            name: 'Jen'
            gender: 'f'
          }
        ]

      globals.out.on 'data', (data) ->
        chai.expect(_str.clean data).to.equal _str.clean output

      globals.out.on 'disconnect', ->
        done()

      globals.template.send template
      globals.template.disconnect()

      globals.ins.send bindings
      globals.ins.disconnect()

  describe 'options', ->
    it 'defines a specific node as root', (done) ->
      template = '''
        <html>
          <body>
            <div id="root">
              <div class="name"></div>
              <div class="gender"></div>
            </div>
          </body>
        </html>
      '''
      output = '''
        <div id="root">
          <div class="name">Ken</div>
          <div class="gender">m</div>

          <div class="name">Jen</div>
          <div class="gender">f</div>
        </div>
      '''
      bindings = [
        {
          name: 'Ken'
          gender: 'm'
        }
        {
          name: 'Jen'
          gender: 'f'
        }
      ]

      globals.out.on 'data', (data) ->
        chai.expect(_str.clean data).to.equal _str.clean output

      globals.out.on 'disconnect', ->
        done()

      globals.root.send '#root'
      globals.root.disconnect()

      globals.template.send template
      globals.template.disconnect()

      globals.ins.send bindings
      globals.ins.disconnect()

  describe 'groups', ->
    it 'wraps data IPs in an object as value with incoming group as the key', (done) ->
      template = '''
        <html>
          <body>
            <div id="root">
              <div>
                <div class="target">
                  <div>
                    <div class="name"></div>
                    <div class="gender"></div>
                  </div>
                </div>
              </div>
            </div>
          </body>
        </html>
      '''
      output = '''
        <div id="root">
          <div>
            <div class="target">
              <div>
                <div class="name">Ken</div>
                <div class="gender">m</div>
              </div>
              <div>
                <div class="name">Jen</div>
                <div class="gender">f</div>
              </div>
            </div>
          </div>
        </div>
      '''
      bindings = [
        {
          name: 'Ken'
          gender: 'm'
        }
        {
          name: 'Jen'
          gender: 'f'
        }
      ]

      globals.out.on 'data', (data) ->
        chai.expect(_str.clean data).to.equal _str.clean output

      globals.out.on 'disconnect', ->
        done()

      globals.root.send '#root'
      globals.root.disconnect()

      globals.template.send template
      globals.template.disconnect()

      globals.ins.beginGroup 'target'
      globals.ins.send bindings
      globals.ins.endGroup 'target'
      globals.ins.disconnect()
