scrape <- function(url,
                   time_between_requests = 10,
                   randomization_requests = 3,
                   save_html = FALSE,
                   save_path = "C:\\Users\\Felix Timmermans\\Desktop\\cars_arbitrage\\data\\kapaza\\base") {
  
          # packages
  
          library(rvest)
          
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
  
          wait_times <- rnorm(n = 1000,
                              mean = time_between_requests,
                              sd = time_between_requests/randomization_requests)
  
          Sys.sleep(time = sample(x = wait_times, size = 1)) }

save(scrape, file = "C:\\Users\\Felix Timmermans\\Desktop\\cars_arbitrage\\functions\\scrape.RData")

