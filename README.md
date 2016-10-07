# Impact McImpactface
_A.K.A. The Derek Zoolander Centre for Researchers Who Can’t Impact Case Study Good_

### About this repository
This repo contains both code and documentation for my Impact McImpactface project, which is being completed as part of the Master of Data Science and Innovation "iLab 1" subject. Using Git for both code and documentation allows version control for both elements, and will allow future students engaging with this challenge (future MDSI students) to simply fork the repository and start working. 

## The Project
### Original Specification
In the UK academics submit 'impact case studies' as part of the Research Excellence Framework (REF) assessment of research quality across universities. These case studies were made available openly. Some analysis has been conducted on these, but further opportunities should be available. It may be possible to work with the Research and Innovation Office at UTS to explore the datasets we hold, including text data (from impact statements, funding applications and reports, publications, etc.) and other data such as collaboration networks. Outcomes might help researchers understand their reach, or flag ways that researchers could increase their impact, or foster new successful collaborations. 

The course outline for this subject can be accessed [here](https://ca.uts.edu.au/wp-content/uploads/2016/02/2016_Spring_36102_update.pdf).

### Additional Notes
The Connected Intelligence Centre (CIC) has an existing body of work aiming to use Natural Language Processing tools to parse written works and make suggestions about how to improve those works. One potential outcome for this project could be a similar system to assist researchers writing research grants, impact case studies, etc.

## Code

[refimpact](https://github.com/perrystephenson/refimpact) - I wrote some R functions to interface with the REF 2014 Impact Case Studies Database API, then turned them into a package. Version 0.1.0 coming soon to CRAN.

## Documentation

[Data Science Hygiene](./Documentation/DataScienceHygiene.md) - an attempt to distill the concept of "good practice" for a rapidly developing field into a single list. Posted to [CIC Around blog](https://15-9203.ca.uts.edu.au/data-science-hygiene/) Friday 16th September.

[Developing Data Science Hygiene](./Documentation/DevelopingDSH.md) - the process I went through when developing the above document.

[Understanding Text Mining](./Documentation/UnderstandingTextMining.md) - a thorough and detailed set of notes about current best practices in text mining.

[Text Mining in R](./Documentation/TextMiningInR.md) - a review of the set of text mining techniques which are currently available in R.

## R Packages of Interest

[text2vec](https://cran.r-project.org/web/packages/text2vec/)

[Structural Topic Modelling](https://github.com/bstewart/stm)

[tokenizers](https://cran.r-project.org/web/packages/tokenizers/index.html)

[lda](https://cran.r-project.org/web/packages/lda/lda.pdf)

[tidytext](https://github.com/juliasilge/tidytext)

[hunspell](https://github.com/ropensci/hunspell)

## Reference and Inspiration
[API for accessing the Impact Case Studies dataset](http://impact.ref.ac.uk/CaseStudies/APIhelp.aspx)

[Prior analysis of this dataset (Kings College)](http://www.kcl.ac.uk/sspp/policy-institute/publications/Analysis-of-REF-impact.pdf)

[Parsey McParseface (Google's English Language Parser)](https://research.googleblog.com/2016/05/announcing-syntaxnet-worlds-most.html)

[Coursera - Text Mining MOOC](https://www.coursera.org/learn/text-mining)

[Academic Writing Analysis - UTS CIC](https://utscic.edu.au/tools/awa/)

[Global Vectors for Word Presentation - GloVe](http://nlp.stanford.edu/projects/glove/)

[How is GloVe different to word2vec](https://www.quora.com/How-is-GloVe-different-from-word2vec)

[Song Lyrics Across the United States](http://juliasilge.com/blog/Song-Lyrics-Across/)


