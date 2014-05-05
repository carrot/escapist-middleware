mm = require 'minimatch'

module.exports = (opts = {}) ->
  ignores = Array::concat(opts.ignore or '')

  return (req, res, next) ->
    next(ignores.some((i) -> mm(req.url, i)))
