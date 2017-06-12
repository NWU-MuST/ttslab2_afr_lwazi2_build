#!/bin/bash
set -e

#args:
VOICEFILE=$1
BUILDDIR=$2

#temporarily setup paths to find tools:
source ./paths.sh
ORIGSYSPATH=$PATH
export PATH=`echo $HTS_BIN`:`echo $ORIGSYSPATH`

#create 16k wavs for alignment:
mkdir $BUILDDIR/wavs_16k
for wavfn in $BUILDDIR/wavs/*; do
    sox $wavfn -r 16k $BUILDDIR/wavs_16k/`basename $wavfn`;
done

#DO ALIGNMENTS:
cd $BUILDDIR
ttslab_align.py $VOICEFILE auto

#restore original paths:
export PATH=$ORIGSYSPATH
