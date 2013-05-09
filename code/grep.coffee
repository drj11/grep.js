#!/usr/bin/env coffee

fs = require 'fs'

# https://github.com/caolan/async
async = require 'async'
# https://github.com/substack/node-optimist
optimist = require 'optimist'

argv = optimist.boolean('clqinsvx'.split '').argv

ARG = argv._

flags = ''
if argv.i
  flags += 'i'
RE = RegExp ARG[0], flags

file1 = (fn, cb) ->
  buf = ''
  n = 0 # line number
  line1 = (line) ->
    n += 1
    if RE.test line
      if argv.n
        process.stdout.write String(n)
        process.stdout.write ':'
      console.log line

  inp = fs.createReadStream fn
  inp.on 'data', (data) ->
    buf += data
    if '\n' in buf
      lines = buf.split '\n'
    buf = lines.pop()
    for line in lines
      line1 line
  inp.on 'end', () ->
    if buf
      line1 line
    cb()

async.each ARG[1..], file1, () ->
  process.exit()
