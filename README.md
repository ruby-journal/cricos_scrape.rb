[![Build Status](https://travis-ci.org/ruby-journal/cricos_scrape.rb.svg)](https://travis-ci.org/ruby-journal/cricos_scrape.rb)
[![Code Climate](https://codeclimate.com/github/ruby-journal/cricos_scrape.rb/badges/gpa.svg)](https://codeclimate.com/github/ruby-journal/cricos_scrape.rb)


# CRICOS Scraper

![CRICOS Logo](http://cricos.education.gov.au/images/cricos.gif)

CRICOS lacks API for data retrieval (so are many government-based services). This gem
helps scrape data from [http://cricos.education.gov.au](http://cricos.education.gov.au).

This gem supports MRI Ruby 2.0.0+.

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
