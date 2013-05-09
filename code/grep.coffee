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
  inp = fs.createReadStream fn
  inp.on 'data', (data) ->
    buf += data
    if '\n' in buf
      lines = buf.split '\n'
    buf = lines.pop()
    for line in lines
      if RE.test line
        console.log line
  inp.on 'end', () ->
    if buf
      if RE.test buf
        console.log buf
    cb()

async.each ARG[1..], file1, () ->
  process.exit()
