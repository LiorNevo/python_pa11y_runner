Pa11y Runner
===
`pa11y_runner` is a simple wrapper for running pa11y scans against local copies of websites.

Currently CSV reports are generated for WCAG2A and WCAG2AA standards using both axe and htmlcs runners.

## Features
- Written in Python
- Small, simple options list
- Short dependency list

## Requirements
- Python 3.7.1+
- npm 6.14.8

## Installation
`pip install -r requirements.txt`

## Usage
    pa11y_runner.py <directory-name> [options]
        options:
        -h, --help                              Show this screen
        -o, --output-directory <output-dir>     Location where to save the generated reports
        -f, --file <file-name>                  Name of specific file to scan

`directory-name` is the absolute path to the location of the .html or .htm files to scan.  
`output-dir` is the absolute path to the location where the runner should create the csv reports.
If no value is given, the reports the reports will be saved into a `reports` directory under the current directory.  
`filename` is the name of a single .html or .htm file within `directory-name` to run the scans against.

## TODO
These items are very high level.
- [ ] Add unit tests.
- [ ] add option for running additional standards scans
- [ ] add option for specifying report formats