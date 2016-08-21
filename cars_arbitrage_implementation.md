# Scraping

## brand_popularity.R

### Goal

Find out which car brands are the most popular on kapaza.be.

### Result

Volkswagen and BMW are the most popular and then popularity starts to decline gradually. The best choice seems to focus on the 4 most popular brands (Volkswagen, BMW, Opel and Mercedes-Benz) which are all German.

## scrape.R

### Goal

Function to scrape a bit more sophisticated than brute force.

### Arguments

url: url referring to the source html you want to extract

time\_between_requests: after extracting the html the function waits some time (expressed in seconds). 

randomization_requests: time waited isn't always the same but is based on a random distribution around the time between requests. The lower this number the more variation around the time between requests occurs.

save_html: do you want to save the html extracted? Defaults to FALSE in order not to pollute a folder by accident.

save_path: where do you want to save the html extracted?

## scrape\_full_kapaza.R

### Goal

Scrape all posts for some selected brands for the first time.

# Analysis

# Notifications