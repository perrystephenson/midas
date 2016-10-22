# Reviewing Data Science Hygiene

_This is a post-project review of the Data Science Hygiene proposal I presented at the start of the iLab. This review is intended to evaluate the effectiveness of the 5 key proposals, in place of the team evaluation that I would have performed if I was part of a team._

For quick reference, the _**data science hygiene**_ proposal consists of the following:

1. Use Source Control
2. Leave Raw Data Alone
3. Remain Skeptical
4. Prioritise Repeatability
5. Minimise, Document and Test Assumptions

## Overall Impressions

The time I spent establishing these practices, and the pleasingly minimal time spent adhering to them, seems to have been entirely worthwhile. I have been able to keep my entire project in a single location, globally accessible, and I've been able to link people directly to specific components that I want them to take a look at without having to send a single email attachment. 

Initially I expected that "prioritising repeatability" was going to increase the time it took to iterate, but it ended up reducing the time. The act of simply writing down what you are doing helps significantly with the process of coding, and as a result I now don't have to spend any time writing additional documentation as it is all included with my code. I have definitely saved time through this process.

Overall I am really happy with my "Data Science Hygiene" proposal and I wouldn't change a thing! I commend the proposal to the MDSI teaching staff for them to consider including it in the teaching curriculum.

## Detailed Review of Propositions

### 1. Use Source Control

This has been fantastic. Between git and GitHub, I've been able to track all of my code through all of it's versions, and there is now a full edit history for every file which any future iLab students can look at when working out why I did something. Additionally, it means that my code is "clean" and doesn't have blocks of disused code commented out "just in case I need them later" - they are all in the commit history so they can be safely deleted.

Once I cleared the initial hurdle of learning how to use git, the process added no time at all to my workflow, and has resulted in significant benefits for me, for my client, for reviewers of my code, for people reading my project documentation, and for future iLab students who can simply fork the repository and continue working. 

### 2. Leave Raw Data Alone

This had the unexpected side effect of making my work quicker and more robust. By keeping my data in its raw form (albeit cached) I was discouraged from performing programmatic cleaning unless it was really necessary, which meant I carried out less cleaning than I probably would have otherwise. This was good for two reasons:

1. I realised that cleaning wasn't as necessary as I thought
1. My process generalises better than it would otherwise

This also lead to me writing my very first R package (now available on CRAN!) which I am very proud of. I has been downloaded by nearly 100 people, and is currently being assessed for inclusion in the **ropensci** project repository, which is very exciting.

### 3. Remain Skeptical

This has really been very easy - every time I think I've discovered something amazing I do a few quick tests to check and I'm very quickly brought crashing back down to earth. The intention of this proposition was that you should thoroughly test all of your findings (and I stand by that); I was able to dismiss any really amazing findings with only cursory testing. 

That being said, I think that I've definitely developed something of value, and I think that future development could turn it into something great.

### 4. Prioritise Repeatability

As I wasn't promoting any of my work to production, this was fulfilled through the use of R Markdown for all of the key experiments in my projects. Each line of code is visible to the lay-person, along with the key outputs, and extensive explanation about what each section of code is intended to accomplish. 

In addition I used a random number seed in the data preparation for the web application, so it should produce identical results for anyone intending to reproduce the live demonstration on their own system.

### 5. Minimise, Document and Test Assumptions

Throughout the project I was consciously avoiding making assumptions that weren't explicitly required, and for the most part let the data speak for itself. The key assumptions that I made were when tuning the GloVe model, as I knowingly chose to set the tuning parameters at values other than those which optimised the score on the standardised test. I documented the reasons for why I did not select the "optimal" values, and I documented the use of those manually-selected values whenever and wherever they were used.

## Summary

Given that I didn't have a team (at least not a team with temporal overlap) it was really important that I set this project up in such a way that my future, non-coincident team mates were able to work effectively, using my project as a self-contained starting point. The Data Science Hygiene piece of work was critical for this objective, and I am very happy with how it has all turned out. I think that the extensive use of GitHub has paid dividends for this purpose (and many others), and I think that the focus on repeatability lead me to develop significantly more documentation for my project than I would have otherwise. 

Overall, I think I am and will be an excellent team mate for my future unknown collaborators, whoever they may be.
