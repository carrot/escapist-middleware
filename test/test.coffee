connect     = require 'connect'
serveStatic = require 'serve-static'

describe 'basic', ->

  before ->
    @app = connect()
            .use(escapist('/index.html'))
            .use(serveStatic(path.join(base_path, 'basic')))

  it 'should block a page if matched', (done) ->
    chai.request(@app).get('/index.html').res (res) ->
      res.text.should.equal('true')
      res.should.have.status(500)
      done()

  it 'should allow other pages to be served', (done) ->
    chai.request(@app).get('/foo.html').res (res) ->
      res.text.should.equal('<p>foo</p>\n')
      res.should.have.status(200)
      done()

describe 'recovery', ->
  before ->
    @app = connect()
            .use(escapist('/index.html'))
            .use(serveStatic(path.join(base_path, 'basic')))
            .use((err, req, res, next) -> res.statusCode = 404; next())

  it 'should be able to recover from a blocking', (done) ->
    chai.request(@app).get('/index.html').res (res) ->
      res.should.have.status(404)
      done()

describe 'muliple patterns', ->
  before ->
    @app = connect()
            .use(escapist(['/index.html', '/foo.*']))
            .use(serveStatic(path.join(base_path, 'basic')))

  it 'should ignore files based on multiple patterns', (done) ->
    chai.request(@app).get('/index.html').res (res) =>
      res.should.have.status(500)

      chai.request(@app).get('/foo.html').res (res) ->
        res.should.have.status(500)
        done()
