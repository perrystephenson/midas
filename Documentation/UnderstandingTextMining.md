# Understanding Text Mining

Text Mining is a huge field. Knowing where to start on a text-based data science project is impossible without an understanding of what techniques are available, and what sort of problems they can be used to solve. This document is an attempt to understand the scope of available text mining techniques in 2016, but with a specific focus on the tasks involved in this iLab project. 


## Limitations and Scope

Text mining isn't wizardry. Given a suitably sized army of text-labelling humans, you could beat any of the current state-of-the-art text mining approaches. Text mining therefore aims to do things that humans can do, but aims to do those things much more quickly and with less resources. It could be said that the purpose of text mining is to:

1. minimise human effort, and
2. supply knowledge

It is worth keeping in mind that text mining typically cannot "discover" things which humans could not discover if given sufficient time and resources. Machine learning brings power, speed, complexity and consistency to the text mining problem in a way that makes it useful for extracting information from text and representing that information to make it useful for decision making.


## Text Mining

Text mining is normally focused on extracting information from text which was created by humans, as opposed to text created by machines such as access logs or SCADA events. You can view the human as performing the role of a sensor which perceives the real world and expresses that information in a semi-standardised format (in this case, the English language). Analysing collections of text produced in this way can allow you to reason about:

1. The format (language)
2. The observer's perception of the world
3. The observer (sentiment, opinion, etc)
4. The real world 
5. The reason the observer wrote the text (speech act)

These are arranged in order of difficulty - using the text alone it is hard to make meaningful generalisations about the real world, but it is possible to discover information about the format (the written English language) and perhaps even some information about the observer. The addition of non-text data can improve the ability to generalise in both directions; it can help generalise about the real world, as it adds new information with a different creation process, and it can also help provide context for the text analysis (this could be in the form of labels, or other contextual information).

This paradigm provides a nice breakdown for how different techniques apply to different objectives:

1. Understanding the individual texts ([NLP](#natural-language-processing) and [text representation](#text-representation))
2. Making generalisations about the language ([word association](#word-association))
3. Understanding the observer's perception of the world ([topic mining](#topic-mining))
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

With the exception of the step from string of characters to sequence of words, each representation is encoding *more* information along with the words, using an understanding of the language to extract more of the meaning from the text. The final dot point (sequence of words with part-of-speech tags, syntactic structures, entities and relations) represents the current bleeding edge at companies like Google, however this comes at the expense of robustness and the ability to generalise. 

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

## Topic Mining

Topic Mining aims to discover the main theme or subject of a text. This can be discovered at different levels of granularity - for example a book can have a topic, as can a sentence or a tweet. Topics will ideally provide information about the real world which can be used to generalise and make predictions or prescriptions.

We might be interested in knowing how much each topic is covered in each document - for example in this iLab you could identify how "strongly" different Research Impact Statements covered different topics.

The general steps involved in topic mining are:

1. Discover topics from the data
  - Sample and manually label topics based on inspection of the data 
  - Use an algorithm to find topics (normally a specified number of topics)
2. Figure out which documents cover which topics (probabilistically)

### Term as a Topic

One approach is to define a topic as a "term", i.e. a word or a phrase. This could be done manually, or could be obtained from the text. To obtain terms from the text:

1. Parse the text to obtain candidate terms
2. Design a scoring function to determine how good each term is as a topic
  - Favour high-frequency terms (representative)
  - Avoid words which are too frequent
  - TF-IDF weighting can be useful
  - Domain-specific heuristics can be useful (hashtags, etc)
3. Pick _**k**_ terms with the highest scores, but aiming to minimise redundancy (avoid correlations)

This approach has some issues:

* Less expressive power (general topics only, as we are limited to single words or phrases)
* Incompleteness in vocabulary coverage (missing related words, we only know about relations we can discover in the dataset)
* Word sense ambiguity (words mean different things, and this can be hard to resolve).

Basically, this approach is no good! Need to look at something more sophisticated.

### Generative Model

You could similarly look at using a **word distribution** instead of a single word or phrase. For this approach you could build a probability distribution for each topic, based on the probability of observing each specific word if you sample words at random from documents which have that topic. If you then assume that the documents were generated as random processes which can be parameterised according to such a model, then you can use gradient descent (or another optimisation algorithm) to find the set of parameters which **maximises the probability** of the observed set of documents having been created by such a system. You can then inspect the parameters to uncover the topics which were discovered, as well as the topic coverage in each of the documents.

The most simple of these is a "unigram" language model, which assumes that each word is generated independently, and that word order within a document does not matter. You can then use the observed data (the text you are mining) to build an estimate of the parameters for the model which "generated" your observations, using a maximum likelihood approach or a bayesian estimate.

### Mixture of Unigram Language Models

It would be nice to get rid of background words (A.K.A. stop words) like _the_, _a_, _is_, etc. This can be done by training a "topic model" and a "background topic model". This is still a generative model in that we're selecting one word at a time, but when selecting each word you need to choose which distribution (topic) to select from, controlled by another probability. When generalised, this means that we're training **two models** (the two unigram LMs) and learning **topic coverage** for both of those topics (the probabilistic weights of each of the distributions).

The background model should be fairly standardised for any given language, which means that it doesn't need to be **learned**, and can just be provided. This is one of the many ways in which human intervention is required for text mining to provide real value.

#### Expectation Maximisation (EM) Algorithm

This is an iterative approach with two steps (E-step and M-step) which improve the current topic parameter estimates. Given a prior background distribution, you can iterate through generations of topic distribution estimates, each generation improving upon the likelihood (actually log-likelihood) of the previous version.

#### Probabilistic Latent Semantic Analysis (PLSA)

This is quite similar to the background-topic mixture model, except that it can have more than two topics. It can find `k` topics in a dataset by considering a background word distribution, assigning random weights to the model, and then iterating through EM until it finds stable models. This is effectively like k-means for text!

You can also control PLSA using prior knowledge - this is known as a User-Controlled PLSA. This knowledge could be in the form of:

* expectations about what topics to expect
* tags (topics) dictating which documents can be used to generate topics. This is essentially applying priors to produce a Maximum a Posteriori (MAP) estimate.

It is possible to define a "model distribution" by providing some weights for a topic which is expected. For example, providing a model with the words "battery" and "life", each with a probability of 0.5, should result in a model where one topic has high probabilities for these two words.

#### Latent Dirichlet Allocation (LDA)

LDA is just a bayesian version of PLSA. By applying a dirichlet prior on the parameters we can make PLSA a generative model (a dirichlet is just a special distribution that we can use to specify a prior). 
The parameters are regularised in an LDA, and it can achieve the same goal as PLSA for text mining purposes. Topic coverage and topic word distributions can be inferred using bayesian inference.

LDA has less parameters than PLSA. Lots of different approaches. Main point is that you can provide priors. Less likely to overfit. Likely to be similar to PLSA in practice.

## Text Clustering

Topic mining (above) allows one document to cover multiple topics. Topic clustering is similar to topic mining, except that it only allows one topic per document. You can think of topic mining as identifying themes which may be present in documents, where clustering is about grouping entire documents into collections based on similarity.

#### Generative Probabilistic Models

This is very similar to PLSA, except that the selection of which distribution to draw words from is fixed for each document. This means that each document has a probability that the entire document was generated by a given distribution, which allows you to identify the distribution which was most likely to be responsible for the document.

#### Similarity-based Approaches

* Explicitly define a similarity function to measure similarity between two text objects (i.e. clustering bias)
* Find an optimal partitioning of data to:
  * Maximise intra-group similarity
  * Minimise inter-group similarity
* Two strategies for finding this partitioning:
  * Hierarchical clustering (e.g. top-down or bottom-up)
  * Flat clustering (e.g. k-means)