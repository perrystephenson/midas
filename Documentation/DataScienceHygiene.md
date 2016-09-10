# Data Science Hygiene

_A modest proposal for a standard set of healthy data science habits._

Hygiene is a term most frequently used in relation to our cleaning and grooming habits and rituals, but it is also commonly used for positive habits in other areas of our lives. 

> **hygiene** (noun) _/ˈhaɪdʒin/_
> 
> 1. the science which deals with the preservation of health.
> 2. the practices, such as keeping oneself clean, which maintain good health.
> 3. the maintenance of a required level of operational safety in various environments in relation to a specified area of possible danger: _email hygiene_; _data hygiene_.
> 4. the practices which prevent the introduction of risk in day-to-day operations, as in the workplace: _industrial hygiene_.
> 
> _Source: Macquarie Dictionary Sixth Edition (October 2013)_

Defining a new but similar term, _**data science hygiene**_, should be fairly straight forward.

> **data science hygiene** (noun) _/ˈdeɪtə ˈsaɪəns ˈhaɪdʒin/_
> 
> 1. the habits and practices which maintain good quality data science experiments, analyses, tools and processes.
> 
> _Source: Perry Stephenson - Impact McImpactface Project (September 2016)_

The habits and practices which collectively make up _**data science hygiene**_ should be:

* Easy and achievable for data scientists at all levels of experience
* Impactful
* Tool and process agnostic
* As general as possible

With these in mind, I propose the following checklist for _**data science hygiene**_.

### 1. Use source control

Using source control gives you a number of benefits which would otherwise be included as _**data science hygiene**_ practices:

* Version management and history
* Collaborative editing and merge conflict resolution
* Code review processes
* Remote backup
* Reproducibility

Source control doesn't just apply to code. Most source control systems can handle many diverse file types, which means you can include documentation or even graphics (like plot outputs) in your repository, and track them with all of the features of your source control system.

### 2. Leave Raw Data Alone

This should really be a commandment! You should always maintain the integrity of your raw data, and only ever modify copies or extracts of the data. It also helps to think of raw data in the same way police think about evidence - you need a continuous chain of custody. This means that you need to document every operation you perform on your data; this is automatic when using scripts but if your process involves manual data manipulation then you need to document every step of this manipulation.


### 3. Remain Skeptical

You should maintain a healthy level of skepticism when working on data projects, especially when working with insight-hungry stakeholders. Results that seem too good to be true usually are, and correlations that seem causal normally aren't. If you are going to make a claim based on your analysis of a dataset, make sure that you have considered statistical significance, and be careful about implying causality.

### 4. Prioritise Repeatability

Repeatability is an important way to build trust in your work. Work that is repeatable tends to be easier to review, and being repeatable means that the end-to-end results can be verified by another data scientist. Some tangible steps you can take to ensure that your work is repeatable include:

* Write self-contained scripts that run the whole pipeline without user interaction
* Record the software and package version numbers
* Manually seed random number generators
* Save model parameters

Most tools which can build models have some way of saving the model to file. This could be through a standard like PMML (Predictive Model Markup Language), explicitly coding the model weights and parameters, or simply saving model objects to a file as binary data. It is important to save models to file any time you're publishing information about those models, such as:

* Claims about accuracy
* Claims about variable importance
* Model scores and/or predictions
* Structure uncovered in the dataset

Model parameters should also be recorded, whether they are selected manually or discovered through a parameter sweep.

### 5. Minimise, Document and Test Assumptions

You should mininimise the number of assumptions you make, and let the data do the talking. When you have to make an assumption, be clear what the assumption is and why you are making it, and then document it. If it is feasible to do so, you should test assumptions to assess whether they are plausible.

<hr>

These 5 habits are clearly not an exhaustive list, but I think they are a pretty good starting point that every data scientist should be striving to incorporate into their projects. 

<strong>What do you think? Have I missed anything? Is source control a waste of time? Feel free to leave a comment below!</strong>