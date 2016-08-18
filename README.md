# goal

Find arbitrage opportunities for the cars second hand market.

Arbitrage opportunity: 
1) strong: a car can be bought and sold at the exact same moment
2) weak: a car can be bought and probably be sold for a higher price in the future

# sources
 
# high level plan

-scrape 2ehands.be cars section (server)

-analyse (locally)
	
-notifications when arbitrage opportunities arise

# scrape 2ehands.be

-[?] multiple instances
http://thestatsgeek.com/2015/11/30/running-simulations-in-r-using-amazon-web-services/
70k announcements vs 60s*60m*24h = 86400

-try to avoid doing it too suspiciously (randomize)

-[?] crawl rate of 1 request /5s?
http://stackoverflow.com/questions/22168883/whats-the-best-way-of-scraping-data-from-a-website

-[?] does AWS changes IP addresses when scraping or does the same instance always correspond with the same IP address?
https://ip-ranges.amazonaws.com/ip-ranges.json 

-scraping order:
1) scrape all cars (to test weak arbitrage opportunities)
2) refresh every once in a while

# analyse

-typical patterns of bids (once)
		-by car, brand, other interesting variables
		

- arbitrage opportunities (every time scraping takes places)
	-strong
		-compare equal cars in dataset
	-weak
		-compare price at specific moment with regular price for a car 		 at that moment



