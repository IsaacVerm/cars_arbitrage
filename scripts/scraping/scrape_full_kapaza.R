### set-up

## packages

library(rvest)
library(dplyr)

## project path

project_path <- "C:\\Users\\Felix Timmermans\\Desktop\\cars_arbitrage"

## load

# posts

posts <- read.csv(file = paste0(project_path,
                                "\\output\\scraping\\brand_popularity\\posts_by_brand.csv"))

# function to scrape

load(paste0(project_path, "\\functions\\scrape.RData"))

### get urls pages

## get html cars page

cars_html <- scrape("http://www.kapaza.be/nl/auto")

## get html brands pages

# select brands

brands <- arrange(posts, desc(posts))
brands<- as.character(brands$brand[1:4])

# create urls brands

brands_url <- paste0("http://www.kapaza.be/nl/", brands)
  
# get html brands pages

brands_html <- lapply(brands_url, function(x) x %>% read_html())

## get number of pages per brands

nr_pages_xpath <- "//a[text()[contains(.,'Laatste pagina')]]"

nr_pages <- sapply(brands_html,
                   function(x) x %>% html_nodes(xpath = nr_pages_xpath) %>% html_attr("href"))

nr_pages <- str_split(string = nr_pages, pattern = "o=")
nr_pages <- sapply(nr_pages, function(x) as.numeric(x[length(x)]))

## create urls pages

# base url

base_url <- "http://www.kapaza.be/nl/"

# add correct number of brands

pages_url <- paste0(base_url, unlist(mapply(rep, brands, nr_pages)))

# add page number

pages_url <- paste0(pages_url, "?o=", unlist(lapply(nr_pages, function(x) 1:x)))

### get urls posts

### scrape