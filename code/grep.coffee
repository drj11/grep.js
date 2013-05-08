#!/usr/bin/env coffee

fs = require 'fs'

# https://github.com/caolan/async
async = require 'async'

# process.argv[0] is coffee, [1] is the name of this script.
ARG = process.argv[2..]
RE = RegExp ARG[0]

file1 = (fn, cb) ->
  # :todo: how do we read a file line by line?
  fs.readFile fn, (err, buf) ->
    if err
      console.warn err
      cb()
    s = String(buf)
    lines = s.split('\n')
    for l in lines
      if RE.test l
        console.log l
    cb()

async.each ARG[1..], file1, () ->
  process.exit()
