#!/usr/bin/env python
'''Compare two git commit hashes'''

import subprocess
import sys


def show_fuller(revision):
    '''Show both author date & commit date of revision'''
    subprocess.call([
        'git',
        'show',
        revision,
        '-s',   # suppress diff
        '--pretty=fuller',  # show both dates
        ])


def main(first_revision, second_revision):
    '''Main execution'''
    print(first_revision)
    print(second_revision)
    output = subprocess.check_output([
        'git',
        'rev-list',
        '--date-order',
        '--all',
        ]).split('\n')
    smaller_index = min(
            output.index(first_revision),
            output.index(second_revision))
    greater_index = max(
            output.index(first_revision),
            output.index(second_revision))
    show_fuller(output[greater_index])
    show_fuller(output[smaller_index])


if len(sys.argv) != 3:
    print('Usage error!')
    sys.exit(1)

main(sys.argv[1], sys.argv[2])
