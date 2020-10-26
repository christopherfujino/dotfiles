#!/usr/bin/env python2

import hashlib
import json

import subprocess # for subprocess
import os # for path
import sys # for reading args
import zipfile # for zippin'

def checksum(input_path):
  """Generates a sha256 checksum of a local file and returns its path.

  Args:
    input_path: (str) The local path to the file that will be checksummed.
  Returns:
    The checksum as a String.
  """
  sha = hashlib.sha256()

  with open(input_path, 'rb') as f:
      data = f.read(65536)
      while len(data) > 0:
          sha.update(data)
          data = f.read(65536)

  return sha.hexdigest()


def manifest(input_path):
  manifest_dict = {} # will be written to a JSON file

  # TODO(fujino): use self.m.path...
  manifest_dict['file_size'] = os.path.getsize(input_path)
  manifest_dict['checksum'] = checksum(input_path)
  # TODO(fujino): use self.m.path...
  manifest_dict['filename'] = os.path.basename(input_path)

  manifest_path = input_path + '.json'
  with zipfile.ZipFile(input_path, 'r') as zip_file:
      manifest_dict['children'] = []
      for file in zip_file.infolist():
          # Dirs have 0 file_size
          if file.file_size > 0:
              file_dict = {
                      'filename': file.filename,
                      'file_size': file.file_size,
                      # TODO(fujino) add checksum
                      }
              manifest_dict['children'].append(file_dict)

  with open(manifest_path, 'w') as manifest_file:
      json.dump(manifest_dict, manifest_file)
  #self.m.step('SHA256 checksum of %s is %s' % (input_filename, checksum), None)

  return manifest_path


zip_file = sys.argv[1]

manifest(zip_file)
print('success!')
