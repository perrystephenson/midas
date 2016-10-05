# Text Mining Extras

_I've learned a few extra things about the ins and outs of text mining, and some of the notes seemed too good to go to waste. So here they are, presented in no particular order and with scant regard for formatting._

### _Attribution_

Most of the material in this document is adapted from notes that I took whilst studying the [Coursera Text Mining](https://www.coursera.org/learn/text-mining) course from the University of Illinois at Urbana-Champaign. I make no claim to copyright over any of this material.

### Scope

The lecturer in the course mentioned above makes a careful point of explaining that text mining and text retrieval are related but different fields. The lecturer indicated that "text retrieval" is used to search through a "big data" dataset and find a workable set of "relevant" data. Text mining is then used to find useful knowledge from this corpus of relevant data.

The course also specifies that **text retrieval** is an essential component of any text mining system. It can be a pre-processor for text mining, and it is needed for knowledge provenance.

They key features of this project as they relate to the selection of text mining approaches are:

* Approximately 6,000 records
* No labels available
* Several paragraphs of text in each record
* Text is highly edited and reviewed, and likely to be fairly consistent within the corpus.

Given the dataset is only 6,000 records, it seems that text retrieval techniques are overkill for this iLab project. For the sake of completion it still makes sense to understand the techniques available in text retrieval and the associated use-cases. This will be covered at the end of the iLab project, if not required organically during the project.