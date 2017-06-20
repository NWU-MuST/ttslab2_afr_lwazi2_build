#!/bin/bash
set -e

ZALEX_PATH=$HOME/src/za_lex
TTSLAB_PATH=$HOME/src/ttslab2
PRONUN_DIR=$HOME/lang/pronun

#Scripts:
DICTMAPPHONES=$ZALEX_PATH/scripts/dictmapphones.py
DICTCONV=$ZALEX_PATH/scripts/dictconv.py
G2PS_JSM=$TTSLAB_PATH/ttslab/g2ps_jsm.py
#You need to have installed Sequitur (i.e. g2p.py should be on the PATH)
SEQUITUR=g2p.py

#Vars:
N=7

#Inputs
SOURCE_DICT_FULL=$PRONUN_DIR/main.pronundict
SOURCE_PHMAP=$PRONUN_DIR/phonememap.ipa-hts.tsv
SOURCE_PHSET=$PRONUN_DIR/phonemeset.json

workdir=$PRONUN_DIR/jsm_train
mkdir $workdir
source_dict_simple=$workdir/main.dict

#Full dict to simple
cat $SOURCE_DICT_FULL | \
    $DICTCONV --oformat flat --outphonemap $SOURCE_PHMAP --mapreverse $SOURCE_PHSET | \
    $DICTCONV --oformat nested $SOURCE_PHSET | \
    tr -d '12' | \
    sed 's/  / /g' | \
    sed 's/ $//g' | \
    cut -f 1,3 > $source_dict_simple

#Simple dict to JSModel
$SEQUITUR  -e UTF8 --train $source_dict_simple --devel 5% --write-model $workdir/model-1.pickle
for i in `seq 2 $N`; do
    prevmodel=$workdir/model-`expr $i - 1`.pickle
    nextmodel=$workdir/model-${i}.pickle
    $SEQUITUR -e UTF8 --model $prevmodel --ramp-up --train $source_dict_simple --devel 5% --write-model $nextmodel
done

$G2PS_JSM $workdir/model-${N}.pickle --dumpmodel > $PRONUN_DIR/g2ps_jsm.pickle
