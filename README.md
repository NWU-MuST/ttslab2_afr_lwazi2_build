TTSLab2 Lwazi2 Afrikaans build scripts
======================================

This repository contains pre-setup data and scripts for building an Afrikaans TTS voice using [TTSLab][1] and associated [build tools][2]. This repository should be built against TTSLab `commit be8f53c...`. The recommended way to do this is described in `./HOWTO.md` and involves cloning this repository and running the accompanying [Docker][3] script (`./Dockerfile`). 

This repository contains software and data written and developed by third parties used under licence in the `./src` and `./recs` directories. Copyright and licence information is contained in each individual sub-directory.

Since the speech corpus bundled here is specifically released under a licence that prohibits commercial use, this repository can be used as-is for research purposes or to demonstrate how to use the TTSLab toolkit to build voices (__in academic work please cite 1__).

For other uses of this software or any of the components, please refer to the specific licences and attribution requirements of the relevant components. The following sections serve to summarise this information, however the `LICENCE` and/or `COPYRIGHT` files in the source tree are definitive.


## Speech corpus and language data

### Lwazi II Afrikaans TTS Corpus

The Lwazi 2 Afrikaans text-to-speech corpus was originally developed by the CSIR in South Africa and can be used and distributed under the terms of a [Creative Commons Licence][4] which prohibits commercial use. If this corpus is used for research purposes, please refer to the CSIR technical report [1].

For more information and links to the original corpus distribution refer to `./recs/README.md`.

### 




## References

 1. K. Calteaux, F. de Wet, C. Moors, D. R. van Niekerk, B. McAlister, A. Sharma Grover, T. Reid, M. Davel, E. Barnard, and C. van Heerden, "Lwazi II Final Report: Increasing the impact of speech technologies in South Africa," Council for Scientific and Industrial Research, Pretoria, South Africa, Tech. Rep. 12045, Feb. 2013.
```bibtex
@techreport{calteaux2013lwazi2,
	author = {Calteaux, K. and de Wet, F. and Moors, C. and Van Niekerk, D. R. and McAlister, B. and Sharma Grover, A. and Reid, T. and Davel, M. and Barnard, E. and Van Heerden, C.},
	title = {{Lwazi II Final Report: Increasing the impact of speech technologies in South Africa}},
	number = {12045},
	institution = {{Council for Scientific and Industrial Research}},
	address = {Pretoria, South Africa},
	month = feb,
	year = {2013}
}
```
 2. 

[1]: https://github.com/demitasse/ttslab2
[2]: https://github.com/demitasse/ttslabdev2
[3]: https://www.docker.com/
[4]: https://creativecommons.org/licenses/by-nc-nd/3.0/