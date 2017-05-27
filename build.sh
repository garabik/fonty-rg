#!/bin/sh

export LC_ALL=POSIX

rm -f uni-16.sbf
for i in source/????-????*.sbf
do
  cat $i >>uni-16.sbf
  echo >>uni-16.sbf
  echo >>uni-16.sbf
done

./compact uni-16.sbf > uni-compact-16.sbf
gzip -f -v9 uni-compact-16.sbf


./choose  charsets/LatCyrGr uni-16.sbf   |./compact | ./vga -512 | ./sbf2psf > LatCyrGr-16.psf
gzip -f -v9 LatCyrGr-16.psf

charsets/cz2t.sh charsets/chavo.chars > chavo
cat charsets/graphics >> chavo
echo U+FFFD >> chavo
./choose  chavo uni-16.sbf   | ./compact | ./vga | ./sbf2psf > chavo.psf
gzip -f -v9 chavo.psf
#rm -f chavo

for i in charsets/*.txt;
do
  bn=`basename $i .txt`
  echo Creating font $bn
  charsets/cz2t.sh $i > $bn
  cat charsets/graphics >> $bn
  echo U+FFFD >> $bn
  ./choose $bn uni-16.sbf | ./vga | ./sbf2psf > $bn.psf
  gzip -f -v9 $bn.psf
  rm -f $bn
done

./charset2acm.py charsets/iso8859-16.txt > iso16.acm
gzip -f -v -9 iso16.acm

