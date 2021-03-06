noflo = require 'noflo'
jsdom = require 'jsdom'
transparency = require 'transparency'

class Render extends noflo.Component
  constructor: ->
    @template = ''
    @rootSelector = 'html'
    @enclosingAll = null
    @enclosing = null

    @inPorts =
      in: new noflo.Port 'object'
      template: new noflo.Port 'string'
      enclosing: new noflo.Port 'string'
      root: new noflo.Port 'string'
    @outPorts =
      out: new noflo.Port 'string'

    @inPorts.template.on 'data', (@template) =>
    @inPorts.root.on 'data', (@rootSelector) =>
    @inPorts.enclosing.on 'data', (@enclosingAll) =>

    @inPorts.in.on 'begingroup', (@enclosing) =>
    @inPorts.in.on 'endgroup', =>
      @enclosing = null

    @inPorts.in.on 'data', (data) =>
      # Create root node from jsdom
      root = jsdom.jsdom(@template).querySelector(@rootSelector)

      # Enclose with a group if provided. This is for specifying where to start
      # iterating. Enclosing as provided by input takes precedent over that
      # provided by template.
      enclosing = @enclosingAll or @enclosing
      if enclosing?
        bindings = {}
        bindings[enclosing] = data
      else
        bindings = data

      # Apply template
      output = transparency.render(root, bindings).outerHTML

      @outPorts.out.send output

    @inPorts.in.on 'disconnect', =>
      @outPorts.out.disconnect()

exports.getComponent = -> new Render
