#!/usr/bin/env coffee

fs = require 'fs'

# https://github.com/caolan/async
async = require 'async'

# process.argv[0] is coffee, [1] is the name of this script.
ARG = process.argv[2..]
RE = RegExp ARG[0]

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
