// Załadowanie bibliotek
library(tm)

// Zmiana katalogu roboczego
workDir <- "D:\\DS\\TMining"
setwd(workDir)

// definicja katalogów funkcjonalnych
inputDir <- ".\\data"
outputDir <- ".\\results"
scriptsDir <- ".\\scripts"
workspacesDir <- ".\\workspaces"
dir.create(outputDir, showWarnings = TRUE)
dir.create(workspacesDir, showWarnings = TRUE)


/Zdefiniowanie korpusu dokumentóW
corpusDir <- paste(inputDir,"Literatura - streszczenia - oryginał", sep = "\\")
corpus <- VCorpus(
  DirSource(
    corpusDir,
    pattern = "*.txt",
    encoding = "UTF-8"
  ),
  readerControl = list(
    language = "pl_PL"
  )
)

// Wstępne przetwarzanie
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, content_transformer(tolower))
stopListFile <- paste(inputDir,"stopwords_pl.txt", sep = "\\")
stopList <- readLines(stopListFile, encoding = "UTF-8")
corpus <- tm_map(corpus, removeWords, stopList)
corpus <- tm_map(corpus, stripWhitespace)

writeLines(as.character((corpus[[1]])))



