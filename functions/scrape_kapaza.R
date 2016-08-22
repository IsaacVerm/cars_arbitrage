scrape <- function(url,
                   time_between_requests = 10,
                   randomization_requests = 3,
                   save_html = FALSE,
                   save_path = "C:\\Users\\Felix Timmermans\\Desktop\\cars_arbitrage\\data\\kapaza\\base") {
  
          # packages
  
          library(rvest)
          library(stringr)
          library(checkmate)
  
          # return error if arguments selected are incorrect
  
          error_messages = makeAssertCollection()
          
          assert_character(url,
                           fixed = "http://www.kapaza.be/nl/",
                           add = error_messages)
          
          assert_numeric(time_between_requests, lower = 0, upper = Inf, add = error_messages)
          assert_numeric(randomization_requests, lower = 0, upper = Inf, add = error_messages)
          
          assert_numeric(time_between_requests - randomization_requests,
                         lower = 0,
                         upper = Inf,
                         add = error_messages)
          
          assert_logical(save_html,
                         add = error_messages)
          
          assert_character(save_path,
                           add = error_messages)
          
          return(error_messages)
          
          reportAssertions(error_messages)
          
          # read html
  
          html <- read_html(url)
          
          # write to text
          
          if(save_html == TRUE) {
          
          setwd(save_path)
          
          filename <- sapply(str_split(url, "/"), function(x) x[length(x)])
          filename <- gsub(pattern = "\\?o=", replacement = "_", x = filename)
          
          write_xml(x = html, file = paste0(save_path, "\\", filename, ".xml"))
          
          }
  
          # wait
          
          wait_times <- runif(n = 1000,
                              min = time_between_requests - randomization_requests,
                              max = time_between_requests + randomization_requests)
  
          Sys.sleep(time = sample(x = wait_times, size = 1)) }

save(scrape, file = "C:\\Users\\Felix Timmermans\\Desktop\\cars_arbitrage\\functions\\scrape_kapaza.RData")

test <- scrape("kljlk", -1, -1, "kjl",TRUE)

