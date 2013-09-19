noflo = require 'noflo'
jsdom = require 'jsdom'
transparency = require 'transparency'

class Render extends noflo.Component
  constructor: ->
    @template = ''
    @rootSelector = 'html'

    @inPorts =
      in: new noflo.Port 'object'
      template: new noflo.Port 'string'
      root: new noflo.Port 'string'
    @outPorts =
      out: new noflo.Port 'string'

    @inPorts.template.on 'data', (@template) =>
    @inPorts.root.on 'data', (@rootSelector) =>

    @inPorts.in.on 'data', (data) =>
      root = jsdom.jsdom(@template).querySelector(@rootSelector)
      output = transparency.render(root, data).outerHTML

      @outPorts.out.send output

    @inPorts.in.on 'disconnect', =>
      @outPorts.out.disconnect()

exports.getComponent = -> new Render
