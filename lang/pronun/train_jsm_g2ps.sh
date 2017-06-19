#!/bin/bash

ZALEX_PATH=$HOME/workspace/za_lex
TTSLAB_PATH=$HOME/GIT/ttslab

#Scripts:
DICTMAPPHONES=$ZALEX_PATH/scripts/dictmapphones.py
DICTCONV=$ZALEX_PATH/scripts/dictconv.py
G2PS_JSM=$TTSLAB_PATH/ttslab/g2ps_jsm.py
#You need to have installed Sequitur (i.e. g2p.py should be on the PATH)
SEQUITUR=g2p.py

#Vars:
N=7

#Inputs
SOURCE_DICT_FULL=pronundict.3a14591.txt
SOURCE_PHMAP=phonememap.ipa-hts.3a14591.tsv
SOURCE_PHSET=phonemeset.3a14591.json

workdir=$PWD/tmp_train
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

$G2PS_JSM $workdir/model-${N}.pickle --dumpmodel > g2ps_jsm.pickle
