### set-up

## packages

library(rvest)
library(stringr)
library(ggplot2)

## where to save

save_path <- "C:\\Users\\Felix Timmermans\\Desktop\\cars_arbitrage\\output\\scraping\\brand_popularity"

### get html cars page

cars_html <- read_html("http://www.kapaza.be/nl/auto")

### get urls brands

brands_xpath <- "//ul[@id='subcat_1020_level_2']//a"

brands_url <- cars_html %>% html_nodes(xpath = brands_xpath) %>% html_attr("href")

### get number of posts

## raw output

posts_xpath <- "//*[text()[contains(.,'Alle zoekertjes')]]/span"

posts <- sapply(brands_url, function(x) read_html(x) %>% html_nodes(xpath = posts_xpath) %>% html_text())

## remove superfluous punctuation

posts <- chartr(old = "().", new = "aaa", x = posts)
posts <- str_trim(gsub(pattern = "a", replacement = "", x = posts))

## change to numeric

posts <- as.numeric(posts)

### visualize

## dataframe

# extract brands

brands <- sapply(str_split(brands_url, pattern = "/"),
                 function(x) x[length(x)])

# create dataframe

posts_df <- data.frame(brand = brands,
                       posts = posts)

# auto is an aggregation, not a brand

posts_df <- posts_df[!posts_df$brand == "auto", ]

## graph

graph_posts <- ggplot(data = posts_df,
                      aes(x = reorder(brand, -posts), y = posts)) +
               geom_bar(stat = "identity") + 
               theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
               labs(x = "brand",
                    y = "number of posts",
                    title = "Popularity of car brands")

plot(graph_posts)

### save objects

## graph

ggsave(plot = graph_posts,
       filename = paste0(save_path,"\\posts_by_brand.png"))

## posts count

write.csv(posts_df, file = paste0(save_path,"\\posts_by_brand.csv"))
