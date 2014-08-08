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

The `OUTPUT_DATA_FILE` and `OUTPUT_ID_FILE` will be saved in folder "data".

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

# License

MIT
