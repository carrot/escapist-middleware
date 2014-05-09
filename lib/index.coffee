mm = require 'minimatch'

module.exports = (ignores = '') ->
  ignores = Array::concat(ignores)

  return (req, res, next) ->
    next(ignores.some((i) -> mm(req.url, i)))
