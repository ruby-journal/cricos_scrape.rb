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
  Get Institution with default agrument (ID_MIN=1, ID_MAX=10000)
  <code>bundle exec rake import:institution</code>

  Get Institution with specify agrument
  <code>bundle exec rake import:institution ID_MIN=1 ID_MAX=10000</code>

  Get Institution with file id list
  <code>bundle exec rake import:institution ID_FILE=<path></code>

  Store data to specify file
  <code>bundle exec rake import:institution RESULTS_DATA_FILE=<file_name> RESULTS_IDS_FILE=<file_name></code>

* Course
  Similar Institution
  <code>bundle exec rake import:course</code>

* Contact
  To get all contacts
  <code>bundle exec rake import:contact</code>

  To get all contacts and overwrite old data
  <code>bundle exec rake import:contact OVERWRITE=true</code>

# License

GPLv2 for non-commercial.

For commercial app, please contact me in person for licensing quote.
