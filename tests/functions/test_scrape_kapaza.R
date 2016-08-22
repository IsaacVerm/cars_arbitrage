### set-up

## load function

source("C:\\Users\\Felix Timmermans\\Desktop\\cars_arbitrage\\functions\\scrape_kapaza.R")

## create test

context("Scrape kapaza")

## path shortcuts

temp_test_objects_path <- "C:\\Users\\Felix Timmermans\\Desktop\\cars_arbitrage\\tests\\temporary_test_objects"

### expectations

## xmls are written to file

# urls to scrape

urls <- c("http://www.kapaza.be/nl/audi?o=10",
          "http://www.kapaza.be/nl/mercedes-benz?o=10",
          "http://www.kapaza.be/nl/renault?o=10",
          "http://www.kapaza.be/nl/mini?o=10")

# scrape

begin_time <- Sys.time()
lapply(urls, function(x) scrape(url = x,
                                save_html = TRUE,
                                save_path = temp_test_objects_path))
end_time <- Sys.time()

# test

test_that("xmls are written to file", {
  
          expect_true(all(paste0(c("audi_10","mercedes-benz_10","renault_10","mini_10"),".xml") %in% list.files(temp_test_objects_path)))
  
          })

## xml sizes are plausible

# xml sizes

xml_sizes <- file.size(list.files(temp_test_objects_path, full.names = TRUE))

# test

test_that("html sizes are plausible", {
  
          expect_true(all(xml_sizes > 50000))
  
          })

## scraping time depends on time between requests

# scraping time

scrape_time <- end_time - begin_time

# default arguments scrape

arg_scrape <- formals(scrape)

# minimum and maximum time

min_time <- length(urls) * (arg_scrape$time_between_requests - arg_scrape$randomization_requests)
max_time <- length(urls) * (arg_scrape$time_between_requests + arg_scrape$randomization_requests)

# test 

test_that("scraping time depends on time between requests", {
  
          expect_true(min_time < scrape_time & scrape_time < max_time)
  
          })

### clean temporary objects

file.remove(list.files(temp_test_objects_path, full.names = TRUE))
