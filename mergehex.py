#!/usr/bin/python

import sys, string

f = open(sys.argv[1])

reper = {}

for i in f.readlines():
    l = string.strip(i)
    cp = l[:4]
    glyph = l[5:]
    reper[cp] = glyph

f = open(sys.argv[2])
for i in f.readlines():
    l = string.strip(i)
    cp = l[:4]
    glyph = l[5:]
    if not reper.has_key(cp):
        reper[cp] = glyph

for i in reper.keys():
    print "%s:%s" % (i, reper[i])
