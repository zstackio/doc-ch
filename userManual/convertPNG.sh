#!/bin/sh

files=`ls *.PNG`

for f in $files
do
    filename=`echo $f | cut -f1 -d'.'`
    echo $filename
    mv $f $filename.png
done
