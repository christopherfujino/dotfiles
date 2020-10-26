#!/usr/bin/env python3

import os
import re

# A path relative to DESIRED_CWD, omitting file extension (assumed to be '.py')
RECIPES_TO_BRANCH = (
        'devicelab',
        'devicelab/devicelab_drone',
        'engine/scenarios',
        'engine/web_engine_framework',
        'engine',
        'engine_builder',
        'femu_test',
        'flutter/flutter',
        'flutter/flutter_drone',
        'flutter',
        'web_engine',
        )
RECIPES_TO_SKIP = (
        'cocoon',
        'firebaselab/firebaselab',
        'fuchsia/fuchsia',
        'fuchsia_ctl',
        'ios-usb-dependencies',
        'plugins/plugins',
        'recipes',
        'tricium/tricium',
        )
# e.g. 1_23_0
VERSION = os.environ['VERSION']
# Recipe repo hash
RECIPE_REVISION = os.environ['RECIPE_REVISION']

cwd = os.getcwd()

#assert cwd == DESIRED_CWD, 'Error! CWD is %s, it should be %s' % (cwd, DESIRED_CWD)

def get_all_recipes(cwd):
    recipe_pattern = r'\.py$'
    forked_recipe_pattern = r'_\d+_\d+_\d+\.py$'
    expectation_pattern = r'\.expected$'
    accumulated_files = []
    for root, dirs, files in os.walk(cwd):
        for filename in files:
            if (re.search(recipe_pattern, filename) and not
                re.search(forked_recipe_pattern, filename)):
                accumulated_files.append(os.path.join(root, filename))
        for dir in dirs:
            if not re.search(expectation_pattern, dir):
                accumulated_files += get_all_recipes(os.path.join(root, dir))
    return accumulated_files

def contains(subject, prefix, tuple_of_candidates):
    for candidate in tuple_of_candidates:
        if subject == os.path.join(prefix, candidate + r'.py'):
            return True
    return False

recipes = get_all_recipes(cwd)
for recipe in recipes:
    if contains(recipe, cwd, RECIPES_TO_BRANCH):
        print('yay')
    else:
        assert contains(recipe, cwd, RECIPES_TO_SKIP), 'Expected %s to be branched or skipped.' % recipe
