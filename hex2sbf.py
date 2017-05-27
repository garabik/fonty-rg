#!/usr/local/ActivePython-2.1/bin/python

import sys, string

def hex2bin(s):
    return {
    '0': '0000',
    '1': '0001',
    '2': '0010',
    '3': '0011',
    '4': '0100',
    '5': '0101',
    '6': '0110',
    '7': '0111',
    '8': '1000',
    '9': '1001',
    'a': '1010',
    'b': '1011',
    'c': '1100',
    'd': '1101',
    'e': '1110',
    'f': '1111',
    }[string.lower(s)]

import sys
for ll in sys.stdin.xreadlines():
    l = string.strip(ll)
    cp = l[:4]
    glyph = l[5:]
    if len(glyph) == 64: # double width
        continue
        print
        print '[U+%s]' % cp
        for i in range(0, len(glyph), 4):
            cl = hex2bin(glyph[i])+hex2bin(glyph[i+1])+hex2bin(glyph[i+2])+hex2bin(glyph[i+3])
            ccl = []
            for j in range(0, len(cl), 2):
                if '1' in cl[j:j+2]:
                    ccl.append('1')
                else:
                    ccl.append('0')
            cl = string.join(ccl, '')
            cl = string.replace(cl, '0', '.')
            cl = string.replace(cl, '1', '0')
            print cl+'.'
    else:
        print
        print '[U+%s]' % cp
        for i in range(0, len(glyph), 2):
            cl = hex2bin(glyph[i])+hex2bin(glyph[i+1])
            cl = string.replace(cl, '0', '.')
            cl = string.replace(cl, '1', '0')
            print cl+'.'
            
            
            
        