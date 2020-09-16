"""
usage: pa11y_runner.py <directory-name> [options]

    options:
    -h, --help                              Show this screen
    -o, --output-directory <output-dir>     Location where to save the generated reports
    -f, --file <file-name>                  Name of specific file to scan
"""
import errno
import subprocess
from typing import Union, List, Dict

from termcolor import cprint

from docopt import docopt
from pathlib import Path
import os
import glob

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
    report_file = open(report_path, 'w')
    error_filename = f'{file}_errors.txt'
    err_file = open(error_filename, 'a')

    res = subprocess.run(pa11y_cmd, stdout=report_file, stderr=err_file)
    report_file.flush()
    err_file.flush()

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

    report_file.close()
    err_file.close()


def run(arguments: Dict[str, str]) -> None:
    directory_name = arguments['<directory-name>']
    output_dir = arguments.get('--output-directory', 'reports')
    file_name = arguments.get('--file')

    if output_dir is None:
        script_dir = os.path.dirname(os.path.realpath(__file__))
        output_dir = Path(script_dir, 'reports')

    if file_name is None:
        files = build_file_list(directory_name)
    else:
        files = [Path(directory_name) / file_name]

    errors = []
    for file in files:
        errors.append(run_pa11y(file, output_dir, 'WCAG2A', 'axe'))
        errors.append(run_pa11y(file, output_dir, 'WCAG2A', 'htmlcs'))
        errors.append(run_pa11y(file, output_dir, 'WCAG2AA', 'axe'))
        errors.append(run_pa11y(file, output_dir, 'WCAG2AA', 'htmlcs'))

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


if __name__ == '__main__':
    try:
        run(docopt(__doc__))
    except SystemExit:
        print(__doc__)
