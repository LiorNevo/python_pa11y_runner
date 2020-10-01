import errno
import glob
import os
import subprocess
from pathlib import Path
from typing import Union, List

import click
from termcolor import cprint

WARNINGS_FLAG = '--include-warnings'
NOTICES_FLAG = '--include-notices'


def print_green(text, flush=False) -> None:
    cprint(text, 'green', flush=flush)


def print_red(text, flush=False) -> None:
    cprint(text, 'red', flush=flush)


def build_file_list(directory: str) -> List[Union[bytes, str]]:
    file_types = ['*.htm', '*.html']

    to_scan = directory
    if not to_scan.endswith('/'):
        to_scan = to_scan + os.sep

    files_found = []
    for file_type in file_types:
        files_found.extend(glob.glob(to_scan + file_type))

    return files_found


def run_pa11y(file: str, output_dir: str, standard: str, runner: str) -> Union[str, None]:
    print(f'running {standard} pa11y scan for {file} using runner {runner}', flush=True)
    report_name = os.path.basename(file).replace('.html', '').replace('.htm', '') +\
        f'_{standard}_{runner}.csv'
    pa11y_cmd = ['npx', 'pa11y', file, '-e', runner, '-s', standard, WARNINGS_FLAG,
                 NOTICES_FLAG, '-r', 'csv']

    try:
        os.makedirs(output_dir)
    except OSError as e:
        if e.errno != errno.EEXIST:
            raise

    report_path = Path(output_dir, report_name)
    error_filename = f'{file}_errors.txt'
    with open(report_path, 'w') as report_file, open(error_filename, 'a') as err_file:
        res = subprocess.run(pa11y_cmd, stdout=report_file, stderr=err_file)

        if res.returncode is not 2:
            report_file.write(f'{standard} scan not successfully run due to compatibility errors')
            print_red('ERROR', True)
            return f'Errors while processing {file}.\n  ' \
                   f'{error_filename} may have more information.'
        else:
            # delete error file if there were no errors for the file
            print_green('No Error with page scan', True)
    if os.path.exists(error_filename) and os.path.getsize(error_filename) == 0:
        os.remove(error_filename)


@click.command()
@click.option('--output-directory',
              help='The path where to place the accessibility scan reports relative to the '
                   'current directory.  If no path is specified the report are placed in a '
                   '"reports" sub-directory in the current directory.')
@click.option('--file-name', help='Name of specific file to scan')
@click.argument('directory-name')
def run(output_directory: str, file_name: str, directory_name: str) -> None:
    """ This script will execute a accesibility scan of WCAG2A and WCAG2AA accessibility standards using axe and htmlcs runners with pa11y.

    DIRECTORY_NAME is the path to the html files to perform the accessibility scans on.
    """

    if output_directory is None:
        script_dir = os.path.dirname(os.path.realpath(__file__))
        output_directory = Path(script_dir, 'reports')

    if file_name is None:
        files = build_file_list(directory_name)
    else:
        files = [Path(directory_name) / file_name]

    errors = []
    for file in files:
        errors.append(run_pa11y(file, output_directory, 'WCAG2A', 'axe'))
        errors.append(run_pa11y(file, output_directory, 'WCAG2A', 'htmlcs'))
        errors.append(run_pa11y(file, output_directory, 'WCAG2AA', 'axe'))
        errors.append(run_pa11y(file, output_directory, 'WCAG2AA', 'htmlcs'))

    print_green('scans complete', flush=True)

    errors = list(filter(None, set(errors)))

    if len(errors) > 0:
        print_summary(errors)


def print_summary(errors: List[str]) -> None:
    print('=' * 40)
    print_red('Errors encountered with files being scanned.')
    print('These are most likely due to issues with javascript on the pages.')
    print('=' * 40)
    for error in errors:
        if error is not None:
            print(error)

