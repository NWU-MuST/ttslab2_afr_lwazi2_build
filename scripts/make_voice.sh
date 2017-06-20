#!/bin/bash

LANG="afrikaans"

if [ ! -e data/pronun/g2ps_jsm.pickle ]; then
    bash $HOME/scripts/do_jsm-g2ps_train.sh;
fi

ttslab_make_phoneset.py $LANG
ln -s data/pronun/g2ps_jsm.pickle main_g2ps.pickle
ttslab_make_pronundicts.py

$HOME/scripts/ttslab_make_afrproto_voice.py frontend $LANG

ttslab_make_synthesizer_hts.py \
    $HOME/data/hts \
    hts_synthesizer.pickle \
    hts

$HOME/scripts/ttslab_make_afrproto_voice.py hts_synthesizer.pickle $LANG
mv voice.pickle hts_voice.pickle
