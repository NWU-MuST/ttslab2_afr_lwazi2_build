#!/bin/bash
set -e

BUILDDIR=$1
SAMPLERATE=$2

#SETUP ALIGNMENTS (BUILDDIR IS RELATIVE PATH -- ONE DEEP):
ttslab_setup_voicebuild.py \
-w recordings/chunked/wavs \
-u recordings/chunked/utts.data \
-o $BUILDDIR \
-r $SAMPLERATE

#replace 'default' setup with predefined...
rm -fr $BUILDDIR/etc/*
cd $BUILDDIR/etc
cp ../../etc/* .
sed "s/ 'n/ _n/g" ../../recordings/chunked/utts.data > utts.data
cd ..
