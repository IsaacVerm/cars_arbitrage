# Car arbitrage strategy

## Goal

Find arbitrage opportunities for the cars second hand market. Arbitrage opportunities can be defined as follows:

- strong
- weak

### Strong arbitrage opportunities

Strong arbitrage opportunities are situations in which a car can be bought and sold at the exact same moment so theoretically there's no risk. 

### Weak arbitrage opportunities

Weak arbitrage opportunities are situations in which a car can be bought at a specific moment and can probably be sold for a higher price later. Probably depends here on the analysis of previous prices of a car of the same type.

## Sources

### Data

As many data sources as possible will be used since this way [the scraping load can be divided](http://programmers.stackexchange.com/questions/91760/how-to-be-a-good-citizen-when-crawling-web-sites)  among many different sites and it's not that bad to be banned on a single site. The following second hand sites contain decent amounts of car posts:

-  [2ehands.be](http://www.2dehands.be/autos/)
-  [autoscout24.be](http://nl.autoscout24.be/)
-  [kapaza.be](http://www.kapaza.be/nl/auto)

All data sources have their advantages and disadvantages:

- 2ehands.be
	- information about users who want to buy by day
	- they sent a mail not to scrape
	- old so easy to scrape
- autoscout24.be
	- very detailed information
	- no information about users willing to buy
	- seems up to date so might be more difficult to crawl
- kapaza.be
	- detailed information
	- no information about users willing to buy
	- information about users who want to buy by day

Kapaza seems like the preferred data source because its information is detailed and, it's easy to crawl and user information is available.

## High level steps

- scrape
- transfer data
- analyse 
- automatic notifications

The scraping takes place on an Amazon AWS, the rest of the steps are done locally. 

### Scraping

Scraping can be divided in two phases:

- get all posts
- update posts

We want to get all posts first since we base our scraping strategy on the results of analyzing this information. Later on we just update.

The following issues may arise:

- number of instances
- intelligence
- crawl rate
- when to scrape
- detection

#### Number of instances

More instances costs more but the exact cost is unclear at the moment since [so many different server types](http://thestatsgeek.com/2015/11/30/running-simulations-in-r-using-amazon-web-services/) exist. If scraping can be limited intelligently only 1 instance may be enough.

#### Intelligence

*Don't scrape all brands*

Let's take 2ehands.be as an example. At the moment there are about 80k of posts regarding cars. Some brands are very popular (e.g. BMW, about 8k of posts) while other brands are not (e.g. Buick, 32 posts). Since unpopular brands don't have a lot of volume anyway it will probably be hard to draw conclusions about arbitrage opportunities for these cars. So maybe it's best to focus on just one or a few popular brands and avoid scraping other brands than these.

*Not all posts should be scraped at the same frequency*

Bids will occur probably mostly at the time a post is put online. It makes sense to crawl a lot when a post is new and then start crawling the same post less and less.

#### Crawl rate

Experiment with different crawl rates to find the exact point at which you get [banned](http://programmers.stackexchange.com/questions/91760/how-to-be-a-good-citizen-when-crawling-web-sites). Randomize the time between requests as well.

#### When to scrape

Should scraping take place at night when it bothers the server less but it's more conspicuous or just during waking hours in which case it might be possible to blend in with the human users?

In any case the scraping code probably won't run 24/7 so the AWS should be configured so that the code's only executed at specific moments? Scheduling scripts locally on Windows can be done using [Task Manager](https://www.r-bloggers.com/taskscheduler-r-package-to-schedule-r-scripts-with-the-windows-task-manager/). Does an alternative for this exist for Ubuntu servers?

#### Detection

When scraping locally only 1 IP address is used. Does AWS uses 1 IP address as well or does it [switches between IP addresses](https://ip-ranges.amazonaws.com/ip-ranges.json)?

### Data transfer

After scraping the data should be made available locally. This involves two steps:

- transfer from [Amazon EC2](https://aws.amazon.com/ec2/) to [Amazon S3](https://aws.amazon.com/s3/)
- transfer from Amazon S3 to local

The second step is trivial: the bucket (collection of data) in S3 can be made publicly available so it's possible to access it by selecting the [correct url](http://strimas.com/r/rstudio-cloud-2/). 

The first step is somewhat harder. At the moment a command has to be typed manually in the [AWS Command Line](https://aws.amazon.com/cli/). It would be easier if this command could be integrated in the scraping code.

### Analysis

The goal of analyzing the cars data is to spot arbitrage opportunities. Spotting strong opportunities is easiest as it's just a matter of finding the price of a comparable other car.

Spotting weak opportunities is a bit harder. We have to compare the price at a specific moment with the general trend of biddings for that type of car. 

What exactly constitutes an opportunity has to be decided based on an initial analysis of the data.

The following issues may arise:

- finding an exact match is impossible
- car info differs across sites

#### Exact match is impossible 

Finding exact matches will severely limit the level of opportunities so categories of comparable cars will have to be defined. Cars can be seen as equal if people are willing to pay the same price for them.

Suppose we have two cars of the same type but one of the cars has automatic gears and one has manual gears. There will probably be a price difference here so these should be divided in two separate categories. Suppose now one car is black while the other one is brown and black and brown are equally popular. In this case the two cars can be put in the same category. We need a model which makes sure we're not comparing apples with oranges.

#### Car info differs across sites
 
Most likely cars names and additional info will be displayed differently according to the site used. Before analyzing this info must be aligned.

### Notifications

Whenever an opportunity arises, a mail is automatically sent.

## To do

### Programming

- find out which brands are popular
- find out at what point most of the bids occur
- find out what bidding trends exist (by car type,...)
- write Kapaza scrape script
- experiment with crawl rate
- divide cars in categories of equal pricing using a model

### Technical info

- how many instances are required?
- when to scrape?
- how does AWS handle IP addresses?
- can the transfer of data between AWS EC2 and AWS S3 be automated using an R script?
- scheduling scripts locally on Windows can be done using Task Manager. Does an alternative for this exist for Ubuntu servers?

### Domain related info

- find someone who knows about cars

## Future improvements

### Component info

Adding component info would offer the possibility to exploit additional arbitrage opportunities. E.g. you have car A and car B which are identical except for the fact car B has an upgrade X which car A doesn't. Suppose upgrade X only costs €200 and car B costs €500 more than car A. In that case an arbitrage opportunity would exist.
