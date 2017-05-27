#!/usr/bin/python

import sys, string

for i in range(0x80,0x9f+1):
	print "0X%X '%s'" % (i, chr(i))

f = open(sys.argv[1])
for i in f.xreadlines():
	l = string.strip(i)
	cp, un = string.split(i)[:2]
	cp = '0x'+cp[1:]
	un = "u'%s'" % ('\U0000'+un[2:])
	un = eval(un)
	un = "'%s'" % un.encode('utf-8')
	if int(cp, 16)>=0xa0:
		print cp, un

