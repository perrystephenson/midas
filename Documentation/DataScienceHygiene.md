# Data Science Hygiene

This iLab project existed before I came along, and it will likely exist after I submit my work for assessment at the end of the semester. Whilst I'm not part of a team *now*, I will eventually be part of a virtual team, and my future team members are relying on me to kick things off in a responsible fashion. This means I need to be careful about how I document my research, write my code, present my work, track my progress, and generally manage the project. 

This document will cover my efforts to identify, create and record best practice data science hygiene practices. I will refrain from defining exactly what I mean by data science hygiene at this point, except to note that it is different to "data hygiene", which is more about data cleaning. The hygiene analogy should do most of the heavy lifting in terms of a definition:
* Good (data science) hygiene prevents the spread of disease (bugs)
* Bad (data science) hygiene often leads to things smelling off (results)
* Good hygiene comes from forming good habits early
* Bad hygiene gets a lot more attention than good hygiene
* etc

This document will be a living document, with version tracking provided through Git.

## Contents
* [Inspiration and Research](#inspiration)
* [Raw Elements](#elements)
  * [Use Source Control](#sourcecontrol)
  * [Manually Seed Random Number Generators](#seed)
  * [Write Self-Contained Scripts](#scripts)
  * [Record Software Versions](#versions)
  * [Leave Raw Data Alone](#rawdata)
  * [Save Your Models](#savemodels)
  * [Minimise, Document and Review Assumptions](#assumptions)
  * [Remain Skeptical](#skeptical)
  * [Think About Production](#production)
* [Key Elements](#keyelements)
  * [Best Bits](#bestbits)
  * [Tech Bits](#techbits)
  * [Tough Bits](#toughbits)

<a name="inspiration"></a>
## Inspiration and Research 

This body of work was inspired partly by [this blog post](https://blog.dominodatalab.com/joel-test-data-science/?imm_mid=0e6f40&cmp=em-data-na-na-newsltr_20160824) where the author proposes a "highly irresponsible sloppy test to rate the quality of a data science team". The test consists of eight questions:

1. Can new hires get set up in the environment to run analyses on their first day?
2. Can data scientists utilize the latest tools/packages without help from IT?
3. Can data scientists use on-demand and scalable compute resources without help from IT/dev ops?
4. Can data scientists find and reproduce past experiments and results, using the original code, data, parameters, and software versions?
5. Does collaboration happen through a system other than email?
6. Can predictive models be deployed to production without custom engineering or infrastructure work?
7. Is there a single place to search for past research and reusable data sets, code, etc?
8. Do your data scientists use the best tools money can buy?

Obviously most of these will not be relevant to my project, however there are a few that stood out for me as examples of "best practice":
* Can data scientists find and reproduce past experiments and results, using the original code, data, parameters, and software versions?
* Does collaboration happen through a system other than email?
* Is there a single place to search for past research and reusable data sets, code, etc?

I then went back and took a look at the blog post from 2000 which inspired the above test, which was the original [Joel Test](http://joelonsoftware.com/articles/fog0000000043.html) - a "highly irresponsible, sloppy test to rate the quality of a software team". This test has 12 questions so I won't include them all here, but I will call out the ones I think are important for Data Science Hygiene:
* Do you use source control?
* Can you make a build in one step?
* Do you have a bug database?
* Do you have an up-to-date schedule?

I admire the simplicity of these tests, which is something I hope to replicate in my own Data Science Hygiene guide.

I also did some highly targeted "Google researching" and found that [no one is really talking about data science hygiene](http://lmgtfy.com/?q=data+science+hygiene). I found a few posts related to code hygiene - whilst similar, data science is far more broad than coding. It looks like I'll be cutting a path all by myself!

<a name="elements"></a>
## Raw Elements

I'm going to use this section to record some elements that I think are important, and some supporting details. These raw elements will be refined later, and are presented in no particular order.

<a name="sourcecontrol"></a>
### Use Source Control
Source control incorporates a number of good hygiene practices:

* Version management
* Collaborative editing
* Code review
* Backup
* Reproducibility

This ticks off part of the **Joel Test for DS** point around being able to reproduce experiments and results by providing the original code.

<a name="seed"></a>
### Manually Seed Random Number Generators
Lots of different processes in data science projects use random number generators, which makes reproducibility challenging. For this reason it makes sense to manually seed these generators so that the same results can be obtained in future.

<a name="scripts"></a>
### Write Self-Contained Scripts
If your data science process requires a 15-step process to get it to run, then you have 15 chances for an error to slip into the process somewhere. Most data science languages are also scripting languages, so this isn't a particularly onerous requirement - it just takes a bit of effort to make sure that your script runs by itself. This helps to ensure that you get the same result every time you run your script, and allows your code to be more easily reviewed.

<a name="versions"></a>
### Record Software Versions
Working with new tools can bring some logistical challenges. As version numbers change:

* Bugs can introduced or fixed
* Functionality can be changed, added or removed
* Syntax can change
* etc

Whilst **_best practice_** would include using infrastructure-as-code tools like Docker to record and build the environment from scratch every time it is required (and use code control to manage the Dockerfile), it should suffice to record the versions for each tool used.

<a name="rawdata"></a>
### Leave Raw Data Alone
This one is fairly self-explanatory. You can look at the raw data, but you cannot modify it! You should also keep it as close to it's raw location as possible. For example:
* For data normally stored in a database, your script should extract it from the source database if possible, rather than keeping a cached copy. If you have to keep cached data, make sure you keep old versions of this cache so that you can replicate your experiments in future.
* For data that is delivered in files, use this data where possible rather than relying on someone else's ETL process (unless you are confident in the process)

<a name="savemodels"></a>
### Save Your Models
It is important to save models (and their associated parameters) to file any time you're publishing information about those models, such as:
* Claims about accuracy
* Claims about variable importance
* Model scores and/or predictions
* Structure uncovered in the dataset

Model parameters should also be recorded, whether they are selected manually or discovered through a parameter sweep.

Most tools which can build models have some way of saving the model to file. This could be through a standard like PMML (Predictive Model Markup Language), explicitly coding the model weights and parameters, or simply saving model objects to a file as binary data. 

<a name="assumptions"></a>
### Minimise, Document and Review Assumptions
You should mininimise the number of assumptions you make, and let the data do the talking. When you have to make an assumption, be clear what the assumption is and why you are making it, and then document it. 

Revisit assumptions regularly to ensure that they remain plausible.

<a name="skepticism"></a>
### Remain Skeptical
You should maintain a healthy level of skepticism. Results that seem too good to be true usually are, and correlations that seem causal probably aren't. If you are going to make a claim based on your analysis of a dataset, make sure that you have considered statistical significance, and be careful about implying causality.

<a name="production"></a>
### Think About Production
It is important to consider production at every stage throughout the project. If you are building a predictive model, this carefully considering what data you will have access to, when you will get access to it, and how your predictions will be used. If you are building a system that makes predictions five minutes ahead, but you only get a daily data extract, then it is best to identify this early. Knowing about the production environment also helps to make decisions around tool selection, model optimisation, etc.

<a name="keyelements"></a>
## Key Elements

In this section the Raw Elements detailed above will be whittled down into a short list, which will be my final "Data Science Hygiene" checklist. With only 9 elements above it seems like I can probably keep them all in the list if necessary - there is no requirement to drop elements at this stage.

<a name="bestbits"></a>
### Best Bits
I think that a reasonable definition for "best" includes the following considerations:
* Easy and achievable for data scientists at all levels of experience
* High impact
* Tool and process agnostic
* As general as possible
As a concrete example, the same checklist items will need to apply to someone who is just starting out with machine learning, or someone with a whole career of experience in data visualisation.

With these points in mind, I think there are some clear candidates for "best bits":
* Use Source Control
* Leave Raw Data Alone
* Remain Skeptical

<a name="techbits"></a>
### Tech Bits
There are some technical elements mentioned above which are a little bit more specific, but they're still really important habits to form. They can still be included in my checklist, but I'll need to be careful about wording, and maybe even consider broadening them a little.
* Manually Seed Random Number Generators
* Write Self-Contained Scripts
* Record Software Versions
* Save Your Models

<a name="toughbits"></a>
### Tough Bits
These elements require a bit more experience to pull off effectively. They are still great habits, but they might not be general enough for this checklist. These are prime candidates for removal.
* Think About Production
* Minimise, Document and Review Assumptions

