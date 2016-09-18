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

1. Understanding the individual texts ([NLP](#natural-language-processing) and [text representation](#text-representation))
2. Making generalisations about the language ([word association](#word-association))
3. Understanding the observer's perception of the world (topic mining)
4. Inferences about the observer (Opinion mining and sentiment analysis)
5. Predictions about the real world (text-based prediction)

The rest of this document will be structured around these 5 areas - you can click the links above to jump straight to any of the sections below.

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

### Enabled Analysis

The [Coursera Text Mining](https://www.coursera.org/learn/text-mining) course presents an excellent overview of how each level of NLP tagging allows additional types of analysis - the table is reproduced here for quick reference.

| Text Representation | Generality | Enabled Analysis | Examples of Application |
|---|---|---|---| 
| String | Very High | String processing | Compression |
| Words | High | Word relation analysis, topic analysis, sentiment analysis | Thesaurus discovery, topic and opinion related applications |
| + Syntactic Structures | Medium | Syntactic graph analysis | Stylistic analysis, structure based feature extraction |
| + Entities and Relations | Low | Knowledge graph analysis, information network analysis | Discovery of knowledge and opinions about specific entities |
| + Logic Predicates | Very Low | Integrated analysis of scattered knowledge, logic inference | Knowledge assistant for biologists |

In terms of how this interacts with my iLab project, these new learnings are guiding me very strongly towards techniques using the "sequence of words" representation of text. These techniques are very powerful and generalise well (in English at least, where word boundaries are easily detected). There is obviously increased value available by moving up the text representation complexity chain, however I cannot see a lot of value in learning complex techniques which do not generalise well unless I have already mastered the techniques at the more general level.  

Whilst CIC have access to tools like the Xerox Incremental Parser (used as the basis for the Academic Writing Analysis tool) and these tools are showing promise in specific areas of research, I cannot envision a scenario where I would be able to learn and use these tools to provide value to my client in the time available in the iLab course. For this reason I will leave these tools out of scope for this project.

## Word Association

In general, we are interested in finding two different types of word relations:

**paradigmatic** - _substitutions_ - A & B have a paradigmatic relationship if they can be substituted for each other. Examples include "cat" and "dog", or "Monday" and "Tuesday".

**syntagmatic** - _combinations_ - A & B have a syntagmatic relationship if they can be combined with each other. Examples include "cat" and "sit", or "car" and "drive".

These two relations can be generalised to describe relations of any kind in any language.

Word associations are useful because they can be used for:

* Improving the accuracy of many NLP tasks
* They can suggest word substitutions for modifying queries in text retrieval
* Automatically construct a topic map for browsing - words as nodes and associations as edges
* Comparing and summarising opinions (what words are most strongly associated with "battery" in positive and negative reviews about the iPhone 6?)

Word association techniques involve examining the context of a word, and then making generalisations about how that word is associated with other words based on comparison of those different contexts. For example, looking at the words which appear before and after the words "cat" and "dog", you can see that the context is fairly similar, and therefore the words have a strong paragidmatic relationship. Similarly, correlated occurence of words (such as words that appear either side of the word "eats") can be used to understand which words "go together" in a syntagmatic relationship.

#### Paradigmatic Relations

* Represent each word by its context
* Compute context similarity
* Words with **high context similarity** likely have a paradigmatic relation

The techniques for discovering these relationships broadly involve representing each context (bag-of-words) as an M-dimentional vector (where M is the number of words in the document), and then calculating the dot product of vectors to calculate similarity. There are some adjustments required to help this method find more meaningful relationships by down-weighting common words and up-weighting rare words. Given that it is unlikely I will have to implement such a system from scratch, I won't go into any further detail here.

#### Syntagmatic Relations

* Count how many times two words appear together in a context
* Compare their co-occurrences with their individual occurrences
* Words with **high co-occurrences but relatively low individual occurrences** likely have a syntagmatic relation

The techniques for discovering these relationships broadly involve considering conditional entropy, an understanding of which is again beyond the scope of this iLab project.

It is worth noting that **paradigmatically** related words tend to have a **syntagmatic** relation with the same word - this allows **joint discovery** of the two relations.

It is also worth pointing out that word association approaches are **unsupervised** and are based on properties of the dataset. This is important for situations where labelled data is not available. Additionally, where a common language is used between datasets, pre-trained word associations (for example, the pre-trained **GloVe** models) can be used to provide additional information to help interpret a new text dataset.

One challenge with the application of word association approaches is that the definition of **context** is critical, and it needs to be defined with consideration of how the results will be used. This may or may not be solved by advanced off-the-shelf techniques as I progress through the course!

