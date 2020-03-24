# Za�adowanie bibliotek
library(tm)
library(hunspell)
library(stringr)

# Zmiana katalogu roboczego
workDir <- "D:\\DS\\TMining"
setwd(workDir)

# definicja katalog�w funkcjonalnych
inputDir <- ".\\data"
outputDir <- ".\\results"
scriptsDir <- ".\\scripts"
workspacesDir <- ".\\workspaces"
dir.create(outputDir, showWarnings = TRUE)
dir.create(workspacesDir, showWarnings = TRUE)


#Zdefiniowanie korpusu dokument�w
corpusDir <- paste(inputDir,"Literatura - streszczenia - orygina�", sep = "\\")
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

# Wst�pne przetwarzanie
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, content_transformer(tolower))
stopListFile <- paste(inputDir,"stopwords_pl.txt", sep = "\\")
stopList <- readLines(stopListFile, encoding = "UTF-8")
corpus <- tm_map(corpus, removeWords, stopList)
corpus <- tm_map(corpus, stripWhitespace)

# Usuni�cie em dash i 3/4
removeChar <- content_transformer(function(x,pattern) gsub(pattern, "", x))
corpus <- tm_map(corpus, removeChar, intToUtf8(8722))
corpus <- tm_map(corpus, removeChar, intToUtf8(190))

#lematyzacja
polish <- dictionary(lang="pl_PL")

lemmatize <- function(text){
  simpleText <-str_trim(as.character(text))
  parsedText <-strsplit(simpleText, split= " ")
  newTextVec <- hunspell_stem(parsedText[[1]], dict = polish)
  for (i in 1:length(newTextVec)) {
    if (length(newTextVec[[i]]) == 0) newTextVec[i] <- parsedText[[1]][i]
    if (length(newTextVec[[i]]) > 1) newTextVec[i] <- newTextVec[[i]][1]
  }
  newText <- paste(newTextVec, collapse = " ")
  return(newText)
}
corpus <- tm_map(corpus, content_transformer(lemmatize))

#usuni�cie rozszerze� z nazw plik�w
cutExtensions <- function(document) {
  meta(document, "id") <- gsub(pattern="\\.txt$", replacement = "", meta(document, "id"))
  return(document)
}
corpus <- tm_map(corpus, cutExtensions)

#export zawarto�ci korpusu do plik�W tekstowych
preprocessedDir <- paste(
  inputDir,
  "Literatura - streszczenia - przetworzone",
  sep = "\\"
)
dir.create(preprocessedDir)
writeCorpus(corpus, path = preprocessedDir)

#Wy�wietlanie zawarto�ci
writeLines(as.character((corpus[[1]])))



