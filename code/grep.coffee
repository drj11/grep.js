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
re = ARG[0]
if argv.x
  if not /^\^/.test re
    re = '^' + re
  if not /\$$/.test re
    re = re + '$'
try
  RE = RegExp re, flags
catch err
  console.warn String(err)
  process.exit 5

# Result Code
#  0: at least one line selected
#  1: no lines selected
#  >1: error
# In fact we use bit 0 to track the lines selected, and bit 1
# to track errors.
rc = 1

file1 = (fn, cb) ->
  inp = fs.createReadStream fn
  inp.on 'error', (err) ->
    unless argv.s
      console.warn String(err)
      rc |= 2
  stream1 inp, cb

stream1 = (inp, cb) ->
  buf = ''
  n = 0 # line number
  c = 0 # count of matches
  line1 = (line) ->
    n += 1
    if RE.test(line) != argv.v
      rc &= ~1
      if argv.q
        return cb 'early'
      if argv.l
        if inp.fd == 0
          console.log '(standard input)'
        else
          console.log inp.path
        return cb()
      if argv.c
        c += 1
        return
      if many
        process.stdout.write inp.path
        process.stdout.write ':'
      if argv.n
        process.stdout.write String(n)
        process.stdout.write ':'
      console.log line

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
    if argv.c
      console.log String(c)
    cb()

if ARG.length > 1
  if ARG.length > 2
    many = true
  else
    many = false
  async.each ARG[1..], file1, () ->
    process.exit rc
else
  process.stdin.resume()
  async.each [process.stdin], stream1, () ->
    process.exit rc
