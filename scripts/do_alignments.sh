#!/bin/bash
set -e

#args:
VOICEFILE=$HOME/frontend.voice.pickle
BUILDDIR=$HOME/build

#temporarily setup paths to find tools:
source $HOME/src/paths.sh
ORIGSYSPATH=$PATH
export PATH=`echo $HTS_BIN`:`echo $ORIGSYSPATH`

# #create 16k wavs for alignment:
# mkdir $BUILDDIR/wavs_16k
# for wavfn in $BUILDDIR/wavs/*; do
#     sox $wavfn -r 16k $BUILDDIR/wavs_16k/`basename $wavfn`;
# done

#Build is 16k (just link wav location):
pushd $BUILDDIR
ln -s wavs wavs_16k
popd

#DO ALIGNMENTS:
pushd $BUILDDIR
ttslab_align.py $VOICEFILE auto
popd

#restore original paths:
export PATH=$ORIGSYSPATH
