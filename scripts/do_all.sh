#!/bin/bash
set -e

bash $HOME/scripts/make_voice.sh
bash $HOME/scripts/setup_alignments.sh
bash $HOME/scripts/do_alignments.sh
bash $HOME/scripts/do_hts_train.sh

cp $HOME/build/hts/voices/qst001/ver1/*.txt $HOME/lang/hts
cp $HOME/build/hts/voices/qst001/ver1/*.htsvoice $HOME/lang/hts
pushd $HOME/lang/hts
ln -s dataset_speaker.htsvoice htsvoice
ln -s mix_excitation_5filters_99taps_16Kz.txt mixfilter
ln -s pulsedispersion.impulseresponse16000.txt pdfilter

bash $HOME/scripts/make_voice.sh
cp $HOME/hts_voice.pickle /mnt/ext/afr_lwazi2.voice.pickle
