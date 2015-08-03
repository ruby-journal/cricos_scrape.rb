[![Build Status](https://travis-ci.org/ruby-journal/cricos_scrape.rb.svg)](https://travis-ci.org/ruby-journal/cricos_scrape.rb)


# CRICOS Scraper

![CRICOS Logo](http://cricos.education.gov.au/images/cricos.gif)

CRICOS lacks API for data retrieval (so are many government-based services). This gem
helps scrape data from [http://cricos.education.gov.au](http://cricos.education.gov.au).

This gem supports Ruby 2+ only.

# Features

Support scrapping following entities:

* Institution
* Course
* Contact

# Usage
  
There are some rake tasks that help import data. You can follow the directions below:

## Import Institutions

Following rake task will loop through the pages with provided IDs and will store the results in `OUTPUT_DATA_FILE`. You can find default `ENVIRONMENT` settings below:


```
bundle exec rake import:institutions # MIN_ID=1, MAX_ID=10000
```

```
bundle exec rake import:institutions MIN_ID=1 MAX_ID=10000
```

```
Default ENVIRONMENT

MIN_ID = 1
MAX_ID = 10000
OUTPUT_DATA_FILE = institutions.json
OUTPUT_ID_FILE = institution_ids.json
```

If the `OUTPUT_DATA_FILE` and `OUTPUT_ID_FILE` have a value of file_name. Output results will be saved in folder "data".
Else if we use absolute path like `/root/file_name`. Data will be saved into this path

Store data to specify file
```
bundle exec rake import:institutions OUTPUT_DATA_FILE=<file_name> OUTPUT_ID_FILE=<file_name>
```
Alternatively to looping through IDs, you can specify a file with a list of IDs in `FILE_INPUT`.

Content `FILE_INPUT` should have the following form `ID1,ID2,ID3`

```
bundle exec rake import:institutions FILE_INPUT=<path>
```


## Import Courses 

Courses have similar syntax with Institutions.
```
bundle exec rake import:courses
```

## Import Contacts

Following rake task will find all contacts and will store the results into `OUTPUT_FILE`

```
OUTPUT_FILE = contacts.json
```
Or with absolute path
```
OUTPUT_FILE = /root/contacts.json
```
If enter `OVERWRITE = true`. This rake will overwrite old contacts in `OUTPUT_FILE` with new contacts
```
bundle exec rake import:contacts OVERWRITE=true
```

To get all contacts
```
bundle exec rake import:contacts
```

Store data to specify file
```
bundle exec rake import:contacts OUTPUT_FILE=<file_name>
```

# Testing
  
The tests are in the spec directory. Here syntax to test this gem.
```
bundle exec rake spec
```

# License

MIT
