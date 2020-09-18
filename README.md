Pa11y Runner
===
`pa11y_runner` is a simple wrapper for the [pa11y](https://pa11y.org/) CLI tool for runnign scans against local copies of websites.


Currently CSV reports are generated for WCAG2A and WCAG2AA standards using both axe and htmlcs runners.

## Features
- Written in Python
- Small, simple options list
- Short dependency list

## Requirements
- Python 3.7.1+
- npm 6.14.8

## Installation
1. clone the repo using:  
`git clone git@github.com:ryanbuhl-lab49/python_pa11y_runner.git`
2. change into the `python_pa11y_runner` directory  
`cd python_pa11y_runner`  
3. create a virtual environment:  
`python -m venv .pa11y-runner-venv`
4. activate the virtual environemnt
`. .pa11y-runner-venv/bin/activate` on *nix platforms or  
`.pa11y-runner-venv\Scripts\activate` on Windows platforms
5. install the dependencies with `pip` using:
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
- [ ] Come up with a better name for the application
- [ ] create setup.py script
- [ ] add more support for pa11y command parameters for running additional standards scans
- [ ] convert to use [click](https://click.palletsprojects.com/en/7.x/) rather than [docopt](http://docopt.org/)
- [ ] see if the runner can navigate sites directly and save the source files for scanning.  (May need Selenium or similar for IE support at which time this won't be cross platform anymore)
- [ ] restructure project file structure