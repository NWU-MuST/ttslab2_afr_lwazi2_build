#!/bin/bash
set -e

export LC_ALL=C

#args:
VOICEFILE=$HOME/hts_voice.pickle
BUILDDIR=$HOME/build
SAMPLERATE=16k

#setup paths to find tools:
source $HOME/src/paths.sh
export HTS_BIN
export SPTK_BIN
export HTS_ENGINE_BIN

#DO ALIGNMENTS:
echo $VOICEFILE
cd $BUILDDIR
ttslab_make_htsmodels.py \
-o hts \
-u utts \
$VOICEFILE \
$HOME/src/ttslabdev2/voicetools/HTS-template_${SAMPLERATE}_MELP.tar.gz \
`grep -iR "MIN:" etc/feats.conf | awk '{print$2}'` \
`grep -iR "MAX:" etc/feats.conf | awk '{print$2}'` \
