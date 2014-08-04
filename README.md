# CRICOS Scraper

![CRICOS Logo](http://cricos.deewr.gov.au/images/cricos.gif)

CRICOS lacks API for data retrieval (so are many government-based services). This gem
helps scrape data from [cricos.deewr.gov.au](http://cricos.deewr.gov.au/).

# Features

Support scrapping following entities:

* Institution
* Course
* Contact

# Usage

* Institution
  Get Institution with default agrument (MIN_ID=1, MAX_ID=10000)
  <code>bundle exec rake import:institution</code>

  Get Institution with specify agrument
  <code>bundle exec rake import:institution MIN_ID=1 MAX_ID=10000</code>

  Get Institution with file id list
  <code>bundle exec rake import:institution FILE_INPUT=<path></code>

  Store data to specify file
  <code>bundle exec rake import:institution OUTPUT_DATA_FILE=<file_name> OUTPUT_ID_FILE=<file_name></code>

* Course
  Similar Institution
  <code>bundle exec rake import:course</code>

TO BE DOCUMENTED

# License

GPLv2 for non-commercial.

For commercial app, please contact me in person for licensing quote.
