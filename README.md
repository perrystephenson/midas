# MIDAS
_Minimising Inferred Distance to Average Sentences_

### About this repository
This repo contains both code and documentation for my [UTS MDSI iLab 1](http://handbook.uts.edu.au/subjects/36102.html) project. Every component of this project other than the presentation slide deck is contained within this repository to make it as easy as possible for students undertaking iLab projects in future semesters to fork the repository and continue working on the project. Visitors to this repo who are not MDSI students are welcome to take a look around and fork the repo as well!

## The Project
### Original Specification
In the UK academics submit 'impact case studies' as part of the Research Excellence Framework (REF) assessment of research quality across universities. These case studies were made available openly. Some analysis has been conducted on these, but further opportunities should be available. It may be possible to work with the Research and Innovation Office at UTS to explore the datasets we hold, including text data (from impact statements, funding applications and reports, publications, etc.) and other data such as collaboration networks. Outcomes might help researchers understand their reach, or flag ways that researchers could increase their impact, or foster new successful collaborations. 

Additionally, the Connected Intelligence Centre (CIC) has an existing body of work aiming to use Natural Language Processing tools to parse written works and make suggestions about how to improve those works. One potential outcome for this project could be a similar system to assist researchers writing research grants, impact case studies, etc.

The course outline for this subject can be accessed [here](https://ca.uts.edu.au/wp-content/uploads/2016/02/2016_Spring_36102_update.pdf).

### Project Scope

This iLab project will establish capability for the linguistic analysis of large text datasets. The key tasks which make up this phase of the project are:

- [x] Identify and implement project structure and data science best practice to ensure project can be efficiently paused and handed over between iLab semesters
- [x] Research and document the scope of modern text mining practices, and identify suitable algorithms and approaches to meet client objectives
- [x] Implement and document proof-of-concept analysis to demonstrate the viability of specific approaches
- [x] Build an interactive tool for demonstration 
- [x] Prepare and deliver presentation for client and stakeholders

The full project plan can be viewed [here](./ProjectPlan.md).

### Vision vs. Execution

The vision for the project as delivered was:

**Can the UK REF impact case studies be used to develop a tool which can help authors improve the quality of their writing?**

I attempted to develop such a tool by breaking down the problem into two high-level tasks:

1. Sentence-level analysis to identify "bad" sentences and flag these to the user
1. Identification and presentation of semantically similar sentences

Each of these tasks is considered individually below; future students working on this project will need to understand this section completely before commencing work on improvements.

<details><summary>1. Identification of bad sentences *(click to expand)*</summary><p>
#### Identification of bad sentences
---

In an ideal world, the "bad" sentences would be the complete set of all sentences which are not subjectively rated as "good" by a majority of readers familiar with the writing style of the corpus. Clearly this is not a realistic outcome for the project, so I focused on developing a single metric for sentences which could be used to detect "outliers". I have included some thoughts below (in the "End-state" section) about how multiple metrics could be combined to improve the overall success of the system. 

This single metric could have take the form of simple measures like sentence length, average word frequency (from the corpus), number of commas, or anything that forms a standard statistical distribution. I decided to pursue the development of a new technique using the Global Vectors (GloVe) algorithm, where each sentence was given a position in m-dimensional space with a roughly multivariate normal distribution. Comparing the vector length of each sentence allows the detection of sentences which are outliers (in the long direction), and these outliers are presented to the user. The details of this method are included [here](./Implementation.md).

In effect, what I have developed is a measure of *semantic intensity*. To demonstrate how this works, consider the following sentence:

> Humans have a liver, kidney, heart, bladder and lungs.

This sentence contains 5 words which are semantically very similar, so the sentence-scoring calculation produces a GloVe-space vector which is quite long. This sentence vector is long because each of the word vectors for the 5 similar words are pointing in a similar direction, and therefore the addition of these vectors leads to a long vector in that direction. If the words in the sentence were less similar, then the sum would be closer to zero, and the sentence would not appear as an outlier. Additionally, as the vector addition includes a TF-IDF transformation, the individual word contribution to the sentence vector is *stronger* for important words (the exact meaning of important is a property of the TF-IDF transformation, if you are interested in finding out how it works you can try [Wikipedia](https://en.wikipedia.org/wiki/Tf%E2%80%93idf)). 

It is difficult to conceive a sensible measurement of "accuracy", so I would suggest that the most practically useful activity to undertake when assessing the behaviour of this algorithm is to play with the tool interactively and see how it performs. My own experimentation has confirmed that "semantically intense" sentences like the example above are marked as outliers, and this outlier status is diminished as either:

* additional stop-words are added, or
* semantically unrelated words are added.

Overall the algorithm seems to perform reasonably consistently, and considering the fact this technique does not appear to have been published previously, I am quite happy with how well it is working.

##### End-state

The use of semantic intensity may not be immediately useful in isolation, and hence the tool probably won't be overly useful in real-life situations without further development. 

My current vision for the end-state for the MIDAS project is a probabilistic outlier detection algorithm which considers multiple sentence metrics (GloVe vector length, sentence length, punctuation counts, sentiment, etc) in the context of their distributions in the training corpus, and selects outliers by considering sentences with the a joint probability lower than a specified threshold. This work can be achieved incrementally, which makes it ideal for iLab group work. 

</p></details>

<details><summary>2. Presentation of semantically similar sentences *(click to expand)*</summary><p>
#### Presentation of semantically similar sentences
---

The ideal algorithm for this component would show the user 3 (approximately) "good" sentences from the corpus, where those sentences have similar meaning to the one written by the user. These sentences are presented as guidance to the author rather than substitutions; the author is left to decide what it is about those sentences that they need to emulate to make their sentence fit more closely with the corpus. 

This is achieved using the [Word Mover's Distance](http://jmlr.org/proceedings/papers/v37/kusnerb15.pdf) which is a new and (apparently) very successful method for determine semantic distance between text passages. Given that this appears to be the best off-the-shelf technique currently available, and given that it seems to be working reasonably successfully, I am quite happy with how well it matches my vision for this component.

##### End-state

I am a lot happier with this than I am with the outlier detection, and I think it's pretty close to the best it can be with currently published approaches. Perhaps the WMD measurement can be combined with other measurements like sentence length, topic modelling, and maybe even good old-fashioned data cleaning to make this work better. The path forward is not clear, and it will require a fair bit of experimentation.

</p></details>

## Code

[refimpact](https://github.com/perrystephenson/refimpact) - I wrote some R functions to interface with the REF 2014 Impact Case Studies Database API and turned them into a package. Version 0.1.0 [now available on CRAN](https://cran.r-project.org/package=refimpact).

[Exploration](./Experimentation/exploration.md) - Exploring the dataset and basic text analytics

[Proof of Concept - GloVe distributions as a method of detecting outlier sentences](./Experimentation/GloVeDistributions.md) - Explored the use of the GloVe word embedding model to identify sentences which are potential outliers.

[Proof of Concept - Replacement Sentences](./Experimentation/Replacement.md) - Explored the use of the Word Mover's Distance as a way of identifying potential replacement sentences.

[Tuning GloVe](./Experimentation/Tuning.md) - Trained a series of GloVe models using different dimensions and skip-window lengths and evaluated the resulting model using a standard test set.

[Implementation](./Implementation.md) - A first pass at connecting all of the elements together.

[Web App](./webapp/app.R) - A live demonstration system built using the `shiny` and `shinydashboard` packages. Several computationally expensive steps are completed using the [PrepareWebApp.R](./PrepareWebApp.R) script. A copy of this live demonstration is hosted on [shinyapps.io](http://midas.perrys.cloud/)

## Documentation

In addition to the overview above, the following documentation details the process I went through to develop my approach to Data Science Hygiene, as well as my text-mining journey.

[Data Science Hygiene](./Documentation/DataScienceHygiene.md) - an attempt to distil the concept of "good practice" for a rapidly developing field into a single list. Posted to [CIC Around blog](https://15-9203.ca.uts.edu.au/data-science-hygiene/) Friday 16th September (requires UTS login). I also reviewed the Data Science Hygiene proposal at the conclusion of the project: [Reviewing Data Science Hygiene](./Documentation/ReviewingDSH.md)

[Developing Data Science Hygiene](./Documentation/DevelopingDSH.md) - the process I went through when developing the above document.

[Understanding Text Mining](./Documentation/UnderstandingTextMining.md) - a thorough and detailed set of notes about my understanding of current best practices in text mining.

[Text Mining in R](./Documentation/TextMiningInR.md) - a review of the set of text mining techniques which are currently available in R.

## Presentation

[MIDAS - turning bad sentences into GOLD](https://docs.google.com/presentation/d/145d4z3AJHKXS0dUcVHATFCTsw6XanWpE5hKwrZmhH0g/edit?usp=sharing) - Presentation for iLab assessment on 26 October 2016.

## Additional Information

### Key R packages used in this project

Aside from several packages from Hadley Wickham's tidyverse, I have used the following key packages:

[text2vec](https://cran.r-project.org/web/packages/text2vec/)

[tidytext](https://github.com/juliasilge/tidytext)

[refimpact](https://github.com/perrystephenson/refimpact)

### Reference and Inspiration

[API for accessing the Impact Case Studies dataset](http://impact.ref.ac.uk/CaseStudies/APIhelp.aspx)

[Prior analysis of this dataset (Kings College)](http://www.kcl.ac.uk/sspp/policy-institute/publications/Analysis-of-REF-impact.pdf)

[Parsey McParseface (Google's English Language Parser)](https://research.googleblog.com/2016/05/announcing-syntaxnet-worlds-most.html)

[Coursera - Text Mining MOOC](https://www.coursera.org/learn/text-mining)

[Academic Writing Analysis - UTS CIC](https://utscic.edu.au/tools/awa/)

[Global Vectors for Word Presentation - GloVe](http://nlp.stanford.edu/projects/glove/)

[How is GloVe different to word2vec](https://www.quora.com/How-is-GloVe-different-from-word2vec)

[Song Lyrics Across the United States](http://juliasilge.com/blog/Song-Lyrics-Across/)


