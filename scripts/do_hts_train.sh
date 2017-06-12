#!/bin/bash
set -e

#args:
VOICEFILE=$1
BUILDDIR=$2
SAMPLERATE=$3

#setup paths to find tools:
source ./paths.sh
export HTS_BIN
export HTS_ENGINE_BIN
export SPTK_BIN

#DO ALIGNMENTS:
echo $VOICEFILE
cd $BUILDDIR
ttslab_make_htsmodels.py \
-o hts \
-u utts \
$VOICEFILE \
$HOME/GIT/ttslabdev/voicetools/HTS-template_${SAMPLERATE}_MELP.tar.gz \
`grep -iR "MIN:" etc/feats.conf | awk '{print$2}'` \
`grep -iR "MAX:" etc/feats.conf | awk '{print$2}'` \
