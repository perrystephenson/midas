# Brainstorming 

_...and brain dumping_

The author of an impact study might like to know how their draft compares to the other texts in the database. These comparisons could take the form of metrics (eg. word count, positive to negative word ratio, etc), themes, or targeted feedback (eg. this sentence does not look right). Based on my current understanding of techniques which could be applied to this problem, the following pieces advice could be provided to the author.

## Simple Counts

**Wordcount** - this is easy to calculate, and could be compared to the distribution of wordcounts in the corpus. Could be filtered to only consider the same unit of assessment or impact type, if that appears to be a source of variance.

**Positivity** - as with wordcount, this could be a direct comparison to the distribution in the corpus. The author could be guided by suggesting common positive words from similar documents, or highlighting uncommon positive words from the draft document. 

**Negativity** - similar to positive words. Negative words are important as they seem to be common when describing the problem being solved by the author's research.

**Sentence Length** - the author's sentence length distribution could be visually compared to the rest of the corpus. The author could be assisted to identify short or long sentences.

## Broad Themes

**Topic Coverage** - the draft document could be assessed for topic coverage as the author types, comparing against a set of topics discovered through LSA or LDA. Could be compared to the topic coverage of similar documents (where similarity could be the same unit of assessment, impact type, etc).

**Thematic Direction** - the draft could be assessed for its average position in an m-dimensional GloVe representation, and compared to the distribution of points for other documents in the same category. Give the user some hints about how to change the thematic direction by using the vector relationships - "more words like this" and "less words like this".

## Specific Passages

**Thematic Distribution** - each sentence can be individually assessed for the average position in an m-dimensional GloVe representation, and the distribution of points (sentences) within each impact case study can be quantified and compared. The distribution of points within the draft topic can then be assessed and the most "out-of-place" sentences can be identified, and alternative sentences can be proposed (by using other sentences from the corpus which would improve the distribution) and the minimum movement distance options (alternative sentences with similar meaning) are offered to the user.

## The Plan

Given the client's expectation that this project will take several iLab sessions to complete, I think it is entirely reasonable to focus on developing one key innovation and proving the concept by building a "steel thread" to demonstrate the application. With this in mind I think that I should be able to execute a static analysis of the **thematic distribution** approach detailed above, and demonstrate each element of the required pipeline. Developing a dynamic demonstration as a live presentation aid is then a reasonable stretch goal. The code and documentation for this analysis will be made available for handover to future iLab students to incorporate it into a more robust and generalised tool if they wish.

If this proves to be unachievable, then I can add a number of the other elements above into a useful but somewhat less innovative toolkit for authors. This will still add value for the client, and will still build a valuable base for future iLab projects to build upon.



