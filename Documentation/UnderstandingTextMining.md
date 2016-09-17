# Understanding Text Mining

Text Mining is a huge field. Knowing where to start on a text-based data science project is impossible without an understanding of what techniques are available, and what sort of problems they can be used to solve. This document is an attempt to scope out the field, but with a specific focus on the tasks involved in this iLab project. They key features of this project as they relate to the selection of text mining approaches are:

* Approximately 6,000 records
* No labels available
* Several paragraphs of text
* Text is highly edited and reviewed, and likely to be fairly consistent

## Related Things

Two things often mentioned in the same breath as text mining are **NLP** and **text retrieval**. It is worth considering the relationship between these things and **text mining**, and how they might be useful in the context of the iLab project.

### Natural Language Processing

Natural Language Processing (NLP) and text mining are often used interchangeably, but this isn't quite accurate. Broadly, text mining (and text retrieval) are associated with large bodies of text, and utilise techniques which scale well to large datasets. NLP techniques on the other hand are associated with deeper analysis of the text, and involves a lot more human interaction. NLP techniques tend not to scale, where Text Mining techniques are all about scale. 

- [ ] Need to do further work to understand the difference.

### Text Retrieval 

Text retrieval and text mining seem to be two different things. The [Coursera Text Mining course](https://www.coursera.org/learn/text-mining) (from the University of Illinois at Urbana-Champaign) indicated that "text retrieval" is used to search through a "big data" dataset and find a workable set of "relevant" data. Text mining is then used to find useful knowledge from this corpus of relevant data.

The course defined Text Mining as the process of turning text data into **high-quality information** or **actionable knowledge**. It should:

* minimise human effort (minimise consumption effort)
* supplies knowledge for optimal decision-making

The course also specifies that **text retrieval** is an essential component of any text mining system. It can be a pre-processor for text mining, and it is needed for knowledge provenance.

Given the dataset is only 6,000 records, it seems that text retrieval techniques are overkill for this iLab project. For the sake of completion it still makes sense to understand the techniques available in text retrieval and the associated use-cases.

- [ ] Need to look into Text Retrieval techniques

## Text Mining

