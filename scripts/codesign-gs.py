#!/usr/bin/env python
"""Hello world"""

import datetime
import json
import os
import re
import shutil
import subprocess
import sys
import time


class Cd(object):
    """Context manager for changing the current working directory"""

    def __init__(self, newPath):
        self.new_path = os.path.expanduser(newPath)
        self.saved_path = ''

    def __enter__(self):
        self.saved_path = os.getcwd()
        os.chdir(self.new_path)

    def __exit__(self, etype, value, traceback):
        os.chdir(self.saved_path)


def usage():
    '''Prints usage for this script'''

    print '''
    Usage:
    codesign.py /path/to/archive /path/to/config.json
    '''


def validate_command(command_name):
    '''Validate the given command exists on PATH'''
    if subprocess.call(['which', command_name]) != 0:
        print 'You don\'t appear to have "%s" installed.' % command_name
        exit(1)


def validate(args_list):
    '''Validate command-line args are valid, return normalized paths if so'''
    if len(args_list) <= 2:
        print 'Not all required arguments provided!'
        usage()
        exit(1)

    validate_command('gsutil')

    target_cloud_path = args_list[1]
    config_path = os.path.abspath(args_list[2])

    if not target_cloud_path.startswith('gs://'):
        print(
            'The target archive should be of the form '
            '"gs://[bucket]/[object-name]"'
            )
        exit(1)

    if not os.path.isfile(config_path):
        print 'Cannot find config file %s' % config_path
        exit(1)

    return target_cloud_path, config_path


def clean():
    '''Clean our build folders'''
    for dirname in ['staging', 'output']:
        print os.path.join(dirname, '*')
        shutil.rmtree(dirname, ignore_errors=True)
        os.mkdir(dirname)


def ensure_entitlements_file():
    '''Write entitlements file if it does not exist'''
    entitlements_path = os.path.join(CWD, 'Entitlements.plist')
    if not os.path.isfile(entitlements_path):
        print 'Writing Entitlements.plist file...\n'
        entitlements_file = open(entitlements_path, 'w')
        entitlements_file.write('''<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <key>com.apple.security.cs.allow-jit</key>
        <true/>
        <key>com.apple.security.cs.allow-unsigned-executable-memory</key>
        <true/>
    </dict>
</plist>
''')
        entitlements_file.close()


def download(cloud_path):
    '''Download supplied Google Storage URI'''
    local_dest_path = os.path.join(CWD, os.path.basename(cloud_path))
    command = [
        'gsutil',
        'cp',
        cloud_path,
        local_dest_path,
        ]
    exit_code = subprocess.call(command)
    if exit_code != 0:
        print 'Download of %s failed!' % cloud_path
        exit(exit_code)
    exit(1)
    return local_dest_path


def upload(cloud_path, local_path):
    '''Upload local_path to GCP cloud_path'''
    command = [
        'gsutil',
        'cp',
        local_path,
        cloud_path,
        ]
    exit_code = subprocess.call(command)
    if exit_code != 0:
        print 'Upload of %s failed!' % local_path
        exit(exit_code)


def read_json_file(file_path):
    '''Given the path to a JSON file, returns dict'''
    with open(file_path, 'r') as config_file:
        config_string = config_file.read()
        config_dict = json.loads(config_string)
        return config_dict


def unzip_archive(file_path):
    '''Calls subprocess to unzip archive'''
    exit_code = subprocess.call(['unzip', file_path, '-d', 'staging'])
    if exit_code != 0:
        exit(exit_code)


def get_binary_names(config):
    '''Returns names of binary files to sign/notarize from dict'''
    return config['binary_paths']


def validate_binary_exists(path):
    '''Validate a binary file listed in config exists'''
    appended_path = os.path.join('staging', path)
    return os.path.isfile(appended_path)


def sign(path, with_entitlements=False):
    '''Sign a single binary'''
    command = [
        'codesign',
        '-f',  # force
        '-s',  # use the cert provided by next argument
        CODESIGN_CERT_NAME,
        path,
        '--timestamp',  # add a secure timestamp
        '--options=runtime',  # hardened runtime
        ]
    if with_entitlements:
        command += ['--entitlements', './Entitlements.plist']
    exit_code = subprocess.call(command)
    if exit_code != 0:
        print 'Error while attempting to sign %s' % path
        exit(exit_code)
    print 'Success: %s' % ' '.join(command)


def zip_dir(path, destination_path):
    '''Zips up a directory to the destination path'''
    with Cd(path):
        subprocess.call([
            'zip',
            '-r',
            destination_path,
            '.',
            '-i',
            '*',
            ])


def upload_zip_to_notary(archive_path):
    '''Uploads zip file to the notary service'''
    print 'Initiating upload of file %s...' % archive_path
    command = [
        'xcrun',
        'altool',
        '--notarize-app',
        '--primary-bundle-id',
        CODESIGN_PRIMARY_BUNDLE_ID,
        '--username',
        CODESIGN_USERNAME,
        '--password',
        APP_SPECIFIC_PASSWORD,
        '--file',
        archive_path,
        # Note that this tool outputs to STDERR, even on success
        ]
    # proc = subprocess.Popen('fake-notarize.sh',stderr=subprocess.PIPE)
    proc = subprocess.Popen(command, stderr=subprocess.PIPE)
    out = '\n'.join(proc.stderr.readlines())
    print out

    match = re.search('RequestUUID = ([a-z0-9-]+)', out)
    if not match:
        print 'Unrecognized output from command: %s' % ' '.join(command)
        exit(1)

    request_uuid = match.group(1)
    print 'Your RequestUUID is: %s' % request_uuid

    return request_uuid


def poll_and_check_status(uuid):
    '''Poll and check the status of our request'''
    command = [
        'xcrun',
        'altool',
        '--notarization-info',
        uuid,
        '-u',
        CODESIGN_USERNAME,
        '--password',
        APP_SPECIFIC_PASSWORD,
        # Note that this tool outputs to STDERR, even on success
        ]
    timeout = 15

    # Checking immediately will lead to the request not being found
    print 'Pausing %i seconds until the first status check...\n' % timeout
    time.sleep(timeout)
    while True:
        print 'Checking on the status of request: %s' % uuid
        proc = subprocess.Popen(command, stderr=subprocess.PIPE)
        output = '\n'.join(proc.stderr.readlines())
        print output

        match = re.search('[ ]*Status: ([a-z ]+)', output)
        if not match:
            print 'Unrecognized output from command: %s' % ' '.join(command)
            print match.group(1)
            exit(1)

        status = match.group(1)
        if status == 'success':
            return True
        elif status == 'in progress':
            print 'Notarization is still pending...\n'
        else:
            print 'Notarization failed!'
            print status
            exit(1)

        print 'Pausing %i seconds until the next check...\n' % timeout
        time.sleep(timeout)


def notarize(archive_path):
    '''Notarize given archive zip'''
    request_uuid = upload_zip_to_notary(archive_path)
    start = time.time()
    poll_and_check_status(request_uuid)
    end = time.time()
    print 'Notarizing took %s' % str(datetime.timedelta(seconds=(end - start)))


def success_message(output_archive):
    '''Print success message.'''
    print 'Your notarization was successful.'
    print 'You should now move your archive from %s' % output_archive
    print 'Re-running this tool will clean this directory.'


def main(input_cloud_path, config_path):
    '''Main execution'''
    config = read_json_file(config_path)

    print 'Clean build folders...\n'
    clean()

    ensure_entitlements_file()

    print 'Downloading %s' % input_cloud_path

    input_archive = download(input_cloud_path)

    print 'Beginning processing of %s...\n' % input_archive

    print 'Unzipping archive...\n'
    unzip_archive(input_archive)

    print 'Validating config...\n'
    for name in config['paths_to_sign'] + config['paths_to_sign_with_entitlements']:
        if not validate_binary_exists(name):
            print 'Cannot find file %s listed in config!' % name
            exit(1)

    print 'Signing binaries...\n'
    for binary_path in config['paths_to_sign']:
        appended_path = os.path.join(CWD, 'staging', binary_path)
        sign(appended_path)

    for binary_path in config['paths_to_sign_with_entitlements']:
        appended_path = os.path.join(CWD, 'staging', binary_path)
        sign(appended_path, True)

    output_zip_path = os.path.abspath(
        os.path.join(
            CWD,
            'output',
            os.path.basename(input_archive)
            )
        )
    signed_files_path = os.path.abspath(
        os.path.join(CWD, 'staging')
        )

    print 'Zipping signed files for notarization...\n'
    zip_dir(signed_files_path, output_zip_path)

    print 'Uploading zip file to notary service...\n'
    notarize(output_zip_path)

    success_message(output_zip_path)


CWD = os.getcwd()
for key in [
        'APP_SPECIFIC_PASSWORD',
        'CODESIGN_USERNAME',
        'CODESIGN_CERT_NAME']:
    if os.environ.get(key, None) is None:
        print 'Please provide the env variable %s' % key
        exit(1)

APP_SPECIFIC_PASSWORD = os.environ['APP_SPECIFIC_PASSWORD']
CODESIGN_PRIMARY_BUNDLE_ID = os.environ.get(
    'CODESIGN_PRIMARY_BUNDLE_ID',
    'com.example.arbitrary')
CODESIGN_USERNAME = os.environ['CODESIGN_USERNAME']
CODESIGN_CERT_NAME = os.environ['CODESIGN_CERT_NAME']
TARGET_ARCHIVE, CONFIG_PATH = validate(sys.argv)

main(TARGET_ARCHIVE, CONFIG_PATH)
