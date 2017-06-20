#!/bin/bash
set -e

BUILDDIR=$HOME/build
SAMPLERATE=16k

#SETUP ALIGNMENTS (BUILDDIR IS RELATIVE PATH -- ONE DEEP):
ttslab_setup_voicebuild.py \
-w $HOME/recs/wavs \
-u $HOME/recs/utts.data \
-o $BUILDDIR \
-r $SAMPLERATE

#replace 'default' setup with predefined...
rm -fr $BUILDDIR/etc/*
cp $HOME/etc/* $BUILDDIR/etc
sed "s/ 'n/ _n/g" $HOME/recs/utts.data > $BUILDDIR/etc/utts.data
