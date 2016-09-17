# Understanding Text Mining

Text Mining is a huge field. Knowing where to start on a text-based data science project is impossible without an understanding of what techniques are available, and what sort of problems they can be used to solve. This document is an attempt to understand the scope of available text mining techniques in 2016, but with a specific focus on the tasks involved in this iLab project. They key features of this project as they relate to the selection of text mining approaches are:

* Approximately 6,000 records
* No labels available
* Several paragraphs of text in each record
* Text is highly edited and reviewed, and likely to be fairly consistent within the corpus.

### _Attribution_

_Most of the material in this document is adapted from notes that I took whilst studying the [Coursera Text Mining](https://www.coursera.org/learn/text-mining) course from the University of Illinois at Urbana-Champaign. I make no claim to copyright over any of this material._

### Scope

The lecturer in the course mentioned above makes a careful point of explaining that text mining and text retrieval are related but different fields. The lecturer indicated that "text retrieval" is used to search through a "big data" dataset and find a workable set of "relevant" data. Text mining is then used to find useful knowledge from this corpus of relevant data.

The course defined Text Mining as the process of turning text data into **high-quality information** or **actionable knowledge**. It should:

* minimise human effort (minimise consumption effort)
* supply knowledge for optimal decision-making

The course also specifies that **text retrieval** is an essential component of any text mining system. It can be a pre-processor for text mining, and it is needed for knowledge provenance.

Given the dataset is only 6,000 records, it seems that text retrieval techniques are overkill for this iLab project. For the sake of completion it still makes sense to understand the techniques available in text retrieval and the associated use-cases. This will be covered at the end of the iLab project, if not required organically during the project.

## Text Mining

Text mining is normally focused on extracting information from text which was created by humans (as opposed to text created by machines, such as access logs or SCADA events). In this way, the human is performing the role of a sensor which perceives the real world and expresses that information in a semi-standardised format (in this case, the English language). Analysing collections of text produced in this way can allow you to reason about:

1. The format (language)
2. The observer's perception of the world
3. The observer (sentiment, etc)
4. The real world (including predictions)

These are arranged in order of difficulty - using the text alone it is hard to make meaningful generalisations about the real world, but it is possible to discover information about the format (the written English language). The addition of non-text data can improve the ability to generalise in both directions; it can help generalise about the real world, as it adds new information with a different creation process, and it can also help provide context for the text analysis (this could be in the form of labels, or other contextual information).

This paradigm provides a nice breakdown for how different techniques apply to different objectives:

1. Understanding the individual texts (NLP and text representation)
2. Making generalisations about the language (word association)
3. Understanding the observer's perception of the world (topic mining)
4. Inferences about the observer (Opinion mining and sentiment analysis)
5. Predictions about the real world (text-based prediction)

The rest of this document will be structured around these 5 areas.

## Natural Language Processing

Analysis of large bodies of text, with appropriate labelling by human language experts, can be used to train machine learning systems to identify and encode several levels of information within a new (unseen) text. These are presented below, in increasing order of complexity:

1. Lexical analysis (part-of-speech tagging)
2. Syntactic analysis (parsing)
3. Semantic analysis
4. Inference
5. Pragmatic Analysis (speech act - purpose)

This is really hard to do! Natural language is designed to make human communications efficient. As a result:

* we omit a lot of common sense knowledge (which we assume the receipient possesses)
* we keep a lot of ambiguities (which we assume the recipient knows how to resolve)

We're really fighting an uphill battle here. Despite the difficulty, state of the art NLP techniques are now allowing researchers to achieve >97% accuracy for POS tagging, and reasonable accuracy for parsing, but that's about it. Some aspects of semantic analysis are also possible, including entity relation/extraction, word sense disambiguation and sentiment analysis. Except within very specific domains, inference and speech act analysis are not currently possible.

The key take-away from this is that the following things cannot be done:

* 100% accurate part-of-speech tagging
* General, complete parsing
* Precise deep semantic analysis

Because of all of these facts, robust and general use of NLP tends to be **shallow** whilst **deep** understanding does not scale up. Shallow NLP is the foundation for modern text mining approaches.

## Text Representation

Text can be represented in several ways:

* string of characters
* sequence of words
* sequence of words with part-of-speech tags
* sequence of words with part-of-speech tags and syntactic structures
* sequence of words with part-of-speech tags, syntactic structures, entities and relations

With the exception of the step from string of characters to sequence of words, each representation is encoding *more* information along with the words, using an understanding of the language to extract more of the meaning from the text. The final dot point (sequence of words with part-of-speech tags, syntactic structures, entities and relations) represents the current bleeding edge at companies like Google, however this comes at the expense of robustness. 

It is also possible to encode even more information and obtain logic predicates and inference rules from the text, and even make inferences about the intent of the speaker, however this is even less robust. This is not worth pursuing for this iLab given the current level of maturity in the NLP space.

In summary, moving towards **deeper** NLP techniques involves encoding **more** information with the words to allow a better understanding of the knowledge encapsulated within the text. However these techniques come at the expense of robustness, and require orders of magnitude more human involvement.

