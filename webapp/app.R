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
dtm <- readRDS("data/dtm.rds")
tidy_ref <- readRDS("data/tidy_ref.rds")

  
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
          textAreaInput("text","Type your draft impact case study here",
                        height = "200px", resize = "vertical"),
          actionButton("button", "Analyse")
        ),
        box(width = NULL, title = "Feedback", solidHeader = T, 
            status = "primary", collapsible = T, 
          uiOutput("analysis")
        )
      ),
        box(
          title = "Recommendations", solidHeader = T, status = "primary",
          htmlOutput("recommendations")
        )
    )
  )
)

##### Server #####

server <- shinyServer(function(input, output, session) {
  
  label_tag <- NULL
  button_state <- NULL
  unseen_tidy <- NULL
  
  inputText <- eventReactive(input$button, ignoreNULL = F, {
    input$text
  })
  
  selectedText <- eventReactive(button_clicked(), ignoreNULL = F, {
    
    if (button_clicked() == 0) return(0)
    current_state <- rep(NA, length(button_state))
    for (i in 1:length(button_state)) {
      current_state[i] <- input[[label_tag[i]]]
    }
    output <- which(current_state != button_state)
    button_state <<- current_state
    return(output)
  })
  
  button_clicked <- reactive({
    total <- 0
    for (i in seq_along(label_tag)) {
      total <- total + input[[label_tag[i]]]
    }
    return(total)
  })
  
  output$analysis <- renderUI({
    if (inputText() == "") {
      return(HTML("Enter your draft text above and click 'Analyse' to get feedback"))
    } else {
      # Get the unseen input data
      unseen <- data.frame(source = "Unseen", text = inputText())
      # Break into sentences
      unseen_tidy <<- unnest_tokens(unseen, raw, text, token = "sentences", to_lower = F)
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
      # Prepare the function labels (and make them globally available)
      label_tag <<- paste0("sentence", 1:nrow(unseen_tidy))
      # Prepare the button-state memory vector
      button_state <<- rep(0, nrow(unseen_tidy))
      
      # For each element, create actionLink with sentence as text, class as good/bad
      for (i in 1:nrow(unseen_tidy)) {
        
        if (unseen_tidy$global_distance[i] > thresholds[2]) {
          class_tag <- "bad"
        } else if (unseen_tidy$global_distance[i] > thresholds[1]) {
          class_tag <- "borderline"
        } else {
          class_tag <- "good"
        }

        display[[i]] <- 
          actionLink(label_tag[i], unseen_tidy$raw[i], class=class_tag)
      }
    }
    return(display)
  })
  
  output$recommendations <- renderUI({
    if (inputText() == "") {
      return(HTML("<- Look over there"))
    } else if (selectedText() == 0) {
      return(HTML("Click a sentence to see suggested replacements"))
    } else {
      sentence_number <- selectedText()
      midas_similar <- get_midas_suggestions(unseen_tidy$raw[sentence_number])
      HTML("You wrote:<BR><STRONG>",
            unseen_tidy$raw[sentence_number],
            "</STRONG><BR><BR>",
            "MIDAS thinks that these sentences from the corpus are similar:<BR><BR><STRONG>",
            midas_similar[1],"<BR><BR>",
            midas_similar[2],"<BR><BR>",
            midas_similar[3],"</STRONG><BR><BR>",
            "Try to rewrite your sentence in a similar style.")
    }
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

get_midas_suggestions <- function(sentence) {
  tokens <- 
    sentence %>% 
    str_to_lower() %>% 
    str_replace_all("[^[:alnum:]]", " ") %>% 
    str_replace_all("\\s+", " ") %>% 
    str_replace_all("(^\\s+)|(\\s+$)", "") %>% 
    word_tokenizer()
  it <- itoken(tokens)
  vectorizer <- vocab_vectorizer(vocab)
  unseen_dtm <- create_dtm(it, vectorizer)
  
  rwmd <- RelaxedWordMoversDistance$new(word_vectors)
  rwmd$verbose <- FALSE
  tidy_ref$rwmd_distance <- dist2(dtm, unseen_dtm, 
                                  method = rwmd, 
                                  norm = "none")[,1]
  suggestions <- tidy_ref %>% 
    arrange(rwmd_distance) %>% 
    head(3)
  
  return(suggestions$Sentence)
}

shinyApp(ui = ui, server = server)