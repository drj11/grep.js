#!/usr/bin/env coffee
fs = require 'fs'
# process.argv[0] is coffee, [1] is the name of this script.
ARG = process.argv[2..]
RE = RegExp ARG[0]
# :todo: async
for fn in ARG[1..]
  # :todo: how do we read a file line by line?
  fs.readFile fn, (err, buf) ->
    if err
      console.warn err
      process.exit 2
    s = String(buf)
    lines = s.split('\n')
    for l in lines
      if RE.test l
        console.log l
