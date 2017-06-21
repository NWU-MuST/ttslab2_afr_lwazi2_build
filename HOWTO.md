How-to guide: TTSLab Lwazi2 Afrikaans build scripts
===================================================

This guide describes how to use the setup provided to build an HMM-based Afrikaans TTS voice using the "Lwazi2 Afrikaans TTS Corpus" included in the repository. The scripts provided are intended to run in a standard [Ubuntu Linux](https://www.ubuntu.com/) environment and a [Docker](https://www.docker.com/) script (`./Dockerfile`) is provided for this purpose.


#### 1. Install Docker for your platform

You should be able to execute the build script using a Docker installation on any operating system platform (only tested on Ubuntu Linux 16.04).

 - To install Docker for your platform visit [www.docker.com](https://www.docker.com) and follow the installation instructions or install from the standard software repositories for your operating system.


#### 2. Clone this repository

This repository contains the corpus, file structure and Docker script to automatically setup and build the voice.

 - To clone the repository do the following on the command prompt (alternatively download and unzip the source):
```bash
git clone https://github.com/demitasse/ttslab2_afr_lwazi2_build.git
```

 - This should create a directory `ttslab2_afr_lwazi2_build` which we will refer to as `$TTSLAB_BUILD`.


#### 3. Download the HTK toolkit

The HTK toolkit may not be distributed by third parties and needs to be downloaded directly from Cambridge University.

 - The HTK version 3.4.1 source code should be downloaded from http://htk.eng.cam.ac.uk/ftp/software/HTK-3.4.1.tar.gz
 - The HDecode HTK extension  version 3.4.1 source code should be downloaded from http://htk.eng.cam.ac.uk/extensions/index.shtml
 - Copy the downloaded files `HTK-3.4.1.tar.gz` and `HDecode-3.4.1.tar.gz` into `$TTSLAB_BUILD/src/`


#### 4. Build and run the Docker image

The `Dockerfile` will build the image by setting up an Ubuntu environment, unpacking, fetching and building the necessary software and language resources. Running the built image will start processing the speech corpus, train the acoustic models and compile a working TTSLab voice and transfer it to the host filesystem (in `$TTSLAB_BUILD/out` if run as described below). 

 - Build the Docker image with:
```bash
docker build -t ttslab2_afr_lwazi2_build $TTSLAB_BUILD
```
 - Run the Docker image with:
```bash
docker run -v $TTSLAB_BUILD/out:/mnt/ext ttslab2_afr_lwazi2_build
```


#### 5. Install TTSLab and test the voice file

The resulting voice file `$TTSLAB_BUILD/out/afr_lwazi2.voice.pickle` can be loaded using [TTSLab](https://github.com/demitasse/ttslab2) (installed on your host system or from within the Docker image) from Python as follows:
```python
import ttslab
v = ttslab.fromfile("afr_lwazi2.voice.pickle")
u = v.synthesize(u"Toets: 1 2 3.")
#save the waveform:
u["waveform"].write("sample.wav")
#play the waveform (if scikits.audiolab has been installed -- not in the Docker image):
u["waveform"].play()
```
