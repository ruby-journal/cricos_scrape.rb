[![Build Status](https://travis-ci.org/ruby-journal/cricos_scrape.rb.svg)](https://travis-ci.org/ruby-journal/cricos_scrape.rb)
[![Code Climate](https://codeclimate.com/github/ruby-journal/cricos_scrape.rb/badges/gpa.svg)](https://codeclimate.com/github/ruby-journal/cricos_scrape.rb)
[![From Vietnam with <3](https://raw.githubusercontent.com/webuild-community/badge/master/svg/love.svg)](https://webuild.community)
[![Made in Vietnam](https://raw.githubusercontent.com/webuild-community/badge/master/svg/made.svg)](https://webuild.community)
[![Built with WeBuild](https://raw.githubusercontent.com/webuild-community/badge/master/svg/WeBuild.svg)](https://webuild.community)

# CRICOS Scraper

![CRICOS Logo](http://cricos.education.gov.au/images/cricos.gif)

CRICOS lacks API for data retrieval (so do many government-based services). This gem
helps scrape data from [http://cricos.education.gov.au](http://cricos.education.gov.au).

NOTE: The [data.gov.au](https://data.gov.au) has provided basic information about
[CRICOS institutions and courses](https://data.gov.au/data/dataset/cricos)
via static Excel file and DataAPI. As of 2021, the data from this source is still
lacking information (for example contact details). But I do believe DataAPI will
eventually replace this scraper in the near future. For the time-being, please use
both sources.

# Features

Support scrapping following entities:

* Institution
* Course
* Contact

# Installation

```
gem install cricos_scrape
```

# Usage

Please consult `cricos_scrape -h` command line.

# Testing

The tests are in the spec directory. Here syntax to test this gem.

```
rspec
```

# License

MIT
