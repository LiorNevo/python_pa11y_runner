Pa11y Runner
===
`pa11y_runner` is a simple wrapper for the [pa11y](https://pa11y.org/) CLI tool for running scans against HTML source files from websites downloaded using the browser's "Save as" menu.


Currently CSV reports are generated for WCAG2A and WCAG2AA standards using both [axe](https://www.deque.com/axe/) and [htmlcs](https://squizlabs.github.io/HTML_CodeSniffer/) runners.

## Features
- Written in Python
- Small, simple options list
- Short dependency list

## Requirements
- Python 3.7.1+
- npm 6.14.8

## Installation for development
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
`pip install --editable .`

## Installation for use
1. clone the repo using:  
`git clone git@github.com:ryanbuhl-lab49/python_pa11y_runner.git`
2. change into the `python_pa11y_runner` directory  
`cd python_pa11y_runner`  
3. create a virtual environment (Optional but recommended)  
`python -m venv .pa11y-runner-venv`
4. activate the virtual environment (only if a virtual environment was created)
`. .pa11y-runner-venv/bin/activate` on *nix platforms or  
`.pa11y-runner-venv\Scripts\activate` on Windows platforms
5. install the script and dependencies with `pip` using:
`pip install .`

## Usage
    Usage: pa11y_runner [OPTIONS] DIRECTORY_NAME

        This script will execute a accesibility scan of WCAG2A and WCAG2AA
        accessibility standards using axe and htmlcs runners with pa11y.

        DIRECTORY_NAME is the path to the html files to perform the accessibility
        scans on.

    Options:
      --output-directory TEXT  The path where to place the accessibility scan
                               reports relative to the current directory.  If no
                               path is specified the report are placed in a
                               "reports" sub-directory in the current directory.
    
      --file-name TEXT         Name of specific file to scan
      --help                   Show this message and exit.


`directory-name` is the absolute path to the location of the .html or .htm files to scan.  
`output-dir` is the absolute path to the location where the runner should create the csv reports.
If no value is given, the reports the reports will be saved into a `reports` directory under the current directory.  
`filename` is the name of a single .html or .htm file within `directory-name` to run the scans against.

## TODO
These items are very high level.
- [ ] Add unit tests.
- [ ] Come up with a better name for the application
- [X] create setup.py script
- [ ] add more support for pa11y command parameters for running additional standards scans
- [X] convert to use [click](https://click.palletsprojects.com/en/7.x/) rather than [docopt](http://docopt.org/)
- [ ] see if the runner can navigate sites directly and save the source files for scanning.  (May need Selenium or similar for IE support at which time this won't be cross platform anymore)
- [ ] restructure project file structure
