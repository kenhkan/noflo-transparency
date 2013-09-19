# Transparency Template Engine <br/>[![Build Status](https://secure.travis-ci.org/kenhkan/noflo-transparency.png?branch=master)](http://travis-ci.org/kenhkan/noflo-transparency) [![Dependency Status](https://gemnasium.com/kenhkan/noflo-transparency.png)](https://gemnasium.com/kenhkan/noflo-transparency) [![NPM version](https://badge.fury.io/js/noflo-transparency.png)](http://badge.fury.io/js/noflo-transparency) [![Stories in Ready](https://badge.waffle.io/kenhkan/noflo-transparency.png)](http://waffle.io/kenhkan/noflo-transparency)

Wrapper around [Transparency](http://leonidas.github.io/transparency/) the templating engine.

## Usage

* [transparency/Render](#render)

### Render

"Just call .render()"

#### In-ports

* TEMPLATE: any HTML code that serves as a Transparency template
* IN: the data bindings to perform the substitution in template. See
  Transparency
  [example](https://github.com/leonidas/transparency/blob/master/examples/hello-server/server.js).

#### Out-ports

* OUT: template substituted with data bindings
