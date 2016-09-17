# Understanding Text Mining

Text Mining is a huge field. Knowing where to start on a text-based data science project is impossible without an understanding of what techniques are available, and what sort of problems they can be used to solve. This document is an attempt to scope out the field, but with a specific focus on the tasks involved in this iLab project. They key features of this project as they relate to the selection of text mining approaches are:

* Approximately 6,000 records
* No labels available
* Several paragraphs of text
* Text is highly edited and reviewed, and likely to be fairly consistent

### Attribution

Most of the material in this document is adapted from notes that I took whilst studying the [Coursera Text Mining](https://www.coursera.org/learn/text-mining) course from the University of Illinois at Urbana-Champaign. 

## Related Things

Two things often mentioned in the same breath as text mining are **Natural Language Processing** and **text retrieval**. It is worth considering the relationship between these things and **text mining**, and how they might be useful in the context of the iLab project.

### Natural Language Processing

Natural Language Processing (NLP) and text mining are often used interchangeably, but they have subtly different objectives. Broadly, text mining (and text retrieval) are associated with large bodies of text, and utilise techniques which scale well to large datasets. NLP techniques on the other hand are associated with deeper analysis of the text, and involves a lot more human interaction. NLP techniques tend not to scale, where Text Mining techniques are all about scale. 

This document will look at NLP where it makes sense in the context of the broader text mining process.

### Text Retrieval 

Text retrieval and text mining seem to be two different things. The [Coursera Text Mining course](https://www.coursera.org/learn/text-mining) (from the University of Illinois at Urbana-Champaign) indicated that "text retrieval" is used to search through a "big data" dataset and find a workable set of "relevant" data. Text mining is then used to find useful knowledge from this corpus of relevant data.

The course defined Text Mining as the process of turning text data into **high-quality information** or **actionable knowledge**. It should:

* minimise human effort (minimise consumption effort)
* supply knowledge for optimal decision-making

The course also specifies that **text retrieval** is an essential component of any text mining system. It can be a pre-processor for text mining, and it is needed for knowledge provenance.

Given the dataset is only 6,000 records, it seems that text retrieval techniques are overkill for this iLab project. For the sake of completion it still makes sense to understand the techniques available in text retrieval and the associated use-cases. This will be covered at the end of the iLab project, if not required organically during the project.

## Text Mining

_The following information is summarised from my study of the [Coursera Text Mining course](https://www.coursera.org/learn/text-mining)._

Text mining is normally focused on extracting information from text which was created by humans (as opposed to text created by machines, such as access logs or SCADA events). In this way, the human is performing the role of a sensor which perceives the real world and expresses that information in a semi-standardised format (in this case, the English language). Analysing collections of text produced in this way can allow you to reason about:

1. The format (language)
2. The observer's perception of the world
3. The observer (sentiment, etc)
4. The real world (including predictions)

These are arranged in order of difficulty - using the text alone it is hard to make meaningful generalisations about the real world, but relatively easy to discover information about the format (the written English language). The addition of non-text data can improve the ability to generalise in both directions. It can help generalise about the real world, as it adds new information with a different creation process. It can also help provide context for the text analysis - this could be in the form of labels, or other contextual information.

This paradigm provides a nice breakdown for how different techniques apply to different objectives:

1. Understanding the individual texts (NLP and text representation)
2. Making generalisations about the language (word association)
3. Understanding the observer's perception of the world (topic mining)
4. Inferences about the observer (Opinion mining and sentiment analysis)
5. Predictions about the real world (text-based prediction)

The rest of this document will be structured around these 5 areas.

## Natural Language Content Analysis

How can we represent text data? Which techniques can be used to analyse it?

#### Natural Language Processing

* Lexical analysis (part-of-speech tagging)
* Syntactic analysis (parsing)
* Semantic analysis - requires a mapping from the syntactic tree to the real world in order to infer meaning
* Inference
* Pragmatic Analysis (speech act - purpose)

Natural language is designed to make human communications efficient. As a result:

* we omit a lot of common sense knowledge which we assume the receipient possesses
* we keep a lot of ambiguities, which we assume the recipient knows how to resolve

This makes NLP very hard! State of the art NLP techniques are now getting >97% accuracy for POS tagging, reasonable accuracy for parsing, but that's about it. Some aspects of semantic analysis are possible (entity relation/extraction, word sense disambiguation, sentiment analysis) but that's about it. Except within very specific domains, inference and speech act analysis are not currently possible.

The key take-away from this is that the following things cannot be done:

* 100% accurate part-of-speech tagging
* General, complete parsing
* Precise deep semantic analysis

Robust and general use of NLP tends to be **shallow** whilst **deep** understanding does not scale up. Shallow NLP is the foundation for modern text mining approaches.

