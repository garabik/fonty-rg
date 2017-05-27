#!/usr/bin/python2

import string, sys

def txt2hex(s):
    s = string.replace(s, '0', '1')
    s = string.replace(s, '.', '0')
    i = int(s, 2)
    return "%02x" % i

f = open(sys.argv[1])

reper = {}
cglyph = []
ccp = []
for i in f.readlines():
    l = string.strip(i)
    if l == "": 
        if cglyph:
            for j in ccp:
                reper[j] = string.join(cglyph, '')
        cglyph = []
        ccp = []
        continue
    if l[0] == '[' and l[-1] == ']':
        if '+' not in l[1+2:-1]: # not a decomposition
            ccp.append(l[1+2:-1])
    elif l[0] in ('.', '0'):
        cglyph.append(txt2hex(l[:8]))


for i in reper.keys():
    print "%s:%s" % (i, reper[i])
    
