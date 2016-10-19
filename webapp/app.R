##### PACKAGES #####

library(shiny)
library(shinydashboard)
library(tidytext)
library(stringr)
library(dplyr)
library(magrittr)
library(text2vec)
library(Matrix)

##### DATA #####

# Import GloVe word vectors
word_vectors <- readRDS("data/word_vectors.rds")
average_sentence <- readRDS("data/average_sentence.rds")
vocab <- readRDS("data/vocab.rds")
thresholds <- readRDS("data/thresholds.rds")
tfidf <- readRDS("data/tfidf.rds")
  
##### HEAD #####

ui <- dashboardPage(title = "MIDAS alpha",
  dashboardHeader(title = tags$a(href='https://github.com/perrystephenson/midas',
                                 tags$img(src='logo.png')),titleWidth = 380),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    
##### CSS #####    
    
    tags$head(tags$style(HTML('
    /* logo */
    .skin-blue .main-header .logo {
    background-color: #19253B;
    min-height: 100px;
    }
    
    /* logo when hovered */
    .skin-blue .main-header .logo:hover {
    background-color: #19253B;
    min-height: 100px;
    }
    
    /* navbar (rest of the header) */
    .skin-blue .main-header .navbar {
    background-color: #19253B;
    min-height: 100px;
    }    

    /* navbar (rest of the header) */
    .skin-blue .content-wrapper {
    background-color: #19253B;
    }    

    /* bad sentences */
    .bad {
    color: red;
    }  
    .bad:hover {
    color: red;
    } 

    /* borderline sentences */
    .borderline {
    color: orange;
    }  
    .borderline:hover {
    color: orange;
    }  
    
    '))),
    
##### User Interface #####

    fluidRow(
      column(width = 6,
        box(width = NULL, title = "Input", solidHeader = T, status = "primary", 
            collapsible = T,
          textAreaInput("text","Type your draft impact case study here"),
          actionButton("button", "Analyse")
        ),
        box(width = NULL, title = "Feedback", solidHeader = T, 
            status = "primary", collapsible = T, 
          uiOutput("analysis")
        )
      ),
        box(
          title = "Recommendations", solidHeader = T, status = "primary",
          "To be completed..."
        )
    )
  )
)

##### Server #####

server <- shinyServer(function(input, output, session) {
  
  inputText <- eventReactive(input$button, ignoreNULL = F, {
    input$text
  })
  
  output$analysis <- renderUI({
    if (inputText() == "") {
      return(HTML("Enter your draft text above and click 'Analyse' to get feedback"))
    } else {
      # Get the unseen input data
      unseen <- data.frame(source = "Unseen", text = inputText())
      # Break into sentences
      unseen_tidy <- unnest_tokens(unseen, raw, text, token = "sentences", to_lower = F)
      # Clean text
      unseen_tidy$clean <- unseen_tidy$raw %>% 
        str_to_lower %>% 
        str_replace_all("[^[:alnum:]]", " ")
      unseen_tidy %<>% select(-source) # This was only here to cover a bug in tidytext
      # Calculate GloVe sentences
      unseen_vectors <- get_sentence_vectors(sentences = unseen_tidy$clean, 
                                             vocab = vocab, 
                                             transform = tfidf, 
                                             wv = word_vectors)
      # Calculate distances from corpus
      unseen_tidy$global_distance <- 
        dist2(x = as.matrix(unseen_vectors), y = t(as.matrix(average_sentence)), 
              method = "euclidean", norm = "l2")[,1]
      # Create a list for the number of sentences
      display <- vector("list", nrow(unseen_tidy))
      # For each element, create actionLink with sentence as text, class as good/bad
      for (i in 1:nrow(unseen_tidy)) {
        label_tag <- paste0("sentence", i)
        
        if (unseen_tidy$global_distance[i] > thresholds[2]) {
          class_tag <- "bad"
        } else if (unseen_tidy$global_distance[i] > thresholds[1]) {
          class_tag <- "borderline"
        } else {
          class_tag <- "good"
        }

        display[[i]] <- 
          actionLink(label_tag, unseen_tidy$raw[i], class=class_tag)
      }
    }
    return(display)
  })
  
})

##### FUNCTIONS #####

get_sentence_vectors <- function(sentences, vocab, transform, wv) {

  iterator <- 
    sentences %>% 
    str_to_lower() %>% 
    str_replace_all("[^[:alnum:]]", " ") %>% 
    str_replace_all("\\s+", " ") %>% 
    str_replace_all("(^\\s+)|(\\s+$)", "") %>%
    word_tokenizer() %>% 
    itoken()
  
  vectorizer <- vocab_vectorizer(vocab)
  dtm <- create_dtm(iterator, vectorizer)
  
  dtm_tfidf <- transform(dtm, transform)
  sentence_vectors <- (dtm_tfidf %*% wv) 
}

shinyApp(ui = ui, server = server)