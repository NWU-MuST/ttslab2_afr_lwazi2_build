############################################################
#### TTSLab2 Lwazi2 Afrikaans build scripts
############################################################
FROM ubuntu:14.04

MAINTAINER Daniel van Niekerk <dvn.demitasse@gmail.com>
LABEL Description="TTSLab2 Lwazi2 Afrikaans build scripts"


## INSTALL STANDARD TOOLS FROM UBUNTU REPO
############################################################
RUN apt-get clean all && apt-get update
RUN apt-get install -y --force-yes build-essential git #Required to fetch and build source
RUN apt-get install -y --force-yes csh #Required by SPTK
RUN apt-get install -y --force-yes libx11-dev #Required by HTK
RUN apt-get install -y --force-yes gfortran #Required by HTS
RUN apt-get install -y --force-yes cmake cython python-numpy #Required to build TTSLab back-ends
RUN apt-get install -y --force-yes libncurses5-dev #Required by EST
RUN apt-get install -y --force-yes swig #Required to build Sequitur
RUN apt-get install -y --force-yes sox normalize-audio tcl-snack praat #Required tools for voice build scripts


## SETUP USER, LOCAL SOURCE, AND DATA
############################################################
ENV USERNAME=demitasse
ENV USERHOME=/home/$USERNAME
RUN useradd -ms /bin/bash $USERNAME
#external volume to transfer output to host
RUN mkdir /mnt/ext
VOLUME /mnt/ext
ENV OUTDIR=/mnt/ext

COPY src $USERHOME/src
COPY etc $USERHOME/etc
COPY lang $USERHOME/lang
COPY recs $USERHOME/recs
COPY scripts $USERHOME/scripts
COPY local $USERHOME/local
WORKDIR $USERHOME
RUN chown -R $USERNAME:$USERNAME src etc lang recs scripts local
USER $USERNAME
ENV PYTHONPATH=$USERHOME/local/lib/python2.7/site-packages:$PYTHONPATH
ENV PATH=$USERHOME/local/bin:$PATH

## FETCH, BUILD AND SETUP SPECIALISED SOFTWARE
############################################################

# ## Build Edinburgh Speech Tools (only needed for unit-selection)
# WORKDIR $USERHOME/src
# RUN tar -xzvf speech_tools-2.4-release.tar.gz
# WORKDIR $USERHOME/src/speech_tools
# RUN ./configure
# RUN make

## Build SPTK
WORKDIR $USERHOME/src
RUN tar -xzvf SPTK-3.8.tar.gz
WORKDIR $USERHOME/src/SPTK-3.8
RUN ./configure; make; mkdir bin/bin;
WORKDIR $USERHOME/src/SPTK-3.8/bin/bin
RUN ln -s `find ../ -type f -executable | grep -v ".c" | grep -v ".h"` .

## Build HTS
WORKDIR $USERHOME/src
RUN tar -xzvf HTK-3.4.1.tar.gz; tar -xzvf HDecode-3.4.1.tar.gz; mkdir htk/HTS_patch;
WORKDIR $USERHOME/src/htk/HTS_patch
RUN tar -xjvf ../../HTS-2.3beta_for_HTK-3.4.1.tar.bz2
WORKDIR $USERHOME/src/htk
RUN patch -p1 -d . < HTS_patch/HTS-2.3beta_for_HTK-3.4.1.patch; ./configure; make;

## Build Sequitur
WORKDIR $USERHOME/src
RUN tar -xzvf g2p-r1668-r3.tar.gz
WORKDIR $USERHOME/src/g2p
RUN python setup.py install --prefix=$USERHOME/local


## Fetch, build and setup TTSLab and tools
WORKDIR $USERHOME/src
RUN git clone https://github.com/demitasse/ttslab2.git
RUN git clone https://github.com/demitasse/ttslabdev2.git
#ttslab
WORKDIR $USERHOME/src/ttslab2
RUN git checkout be8f53c
RUN mkdir -p hts_engine/build
WORKDIR $USERHOME/src/ttslab2/hts_engine/build
RUN cmake ..
RUN make
WORKDIR $USERHOME/src/ttslab2/ttslab/synthesizers
RUN bash compile_relp.sh
#ttslabdev
WORKDIR $USERHOME/src/ttslabdev2
RUN git checkout 76934a6
WORKDIR $USERHOME/src/ttslabdev2/voicetools
RUN bash compile_dtw.sh
WORKDIR $USERHOME/src/ttslabdev2/voicetools/HTS-template_16k_MELP
RUN mkdir data/utts data/raw data/wav data/questions data/labels
RUN tar -czvf ../HTS-template_16k_MELP.tar.gz .
#paths
ENV PATH=$USERHOME/src/ttslabdev2/scripts:$PATH
ENV PYTHONPATH=$USERHOME/src/ttslab2:$USERHOME/src/ttslabdev2/modules:$PYTHONPATH


## FETCH LANGUAGE DATA AND BUILD VOICE FRONTENDS
############################################################

#za_lex
WORKDIR $USERHOME/src
RUN git clone https://github.com/demitasse/za_lex.git
WORKDIR $USERHOME/src/za_lex
RUN git checkout fbf1797
ENV PATH=$USERHOME/src/za_lex/scripts:$PATH

#afr dict
WORKDIR $USERHOME/lang/pronun
RUN ln -s $USERHOME/src/za_lex/data/afr/pronundict.txt
#collapse to single stress level:
RUN cut -d " " -f 1-2 > 12 < pronundict.txt; cut -d " " -f 3 > 3 < pronundict.txt; cut -d " " -f 4- > 4- < pronundict.txt; sed -i 's/2/1/g' 3; paste -d " " 12 3 4- > main.pronundict; rm 12 3 4-
