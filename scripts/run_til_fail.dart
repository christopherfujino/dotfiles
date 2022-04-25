#!/usr/bin/env dart

import 'dart:io';

const totalRuns = 1000;

void main(List<String> args) {
  if (args.length != 1) {
    throw 'Usage: pass dart test file as only arg';
  }
  final testPath = args.first.trim();
  for (int testsRun = 0; testsRun < totalRuns; testsRun++) {
    final result = Process.runSync(
      'dart',
      <String>['test', testPath, '-n', 'Clients of flutter run on web with DDS enabled can validate flutter version in parallel'],
    );
    if (result.exitCode != 0) {
      print('Found a failure after ${testsRun + 1} runs.');
      print('exit code: ${result.exitCode}');
      print('stderr: ${result.stderr}');
      print('stdout: ${result.stdout}');
      exit(1);
    }
    print('Successful run ${testsRun + 1}.');
  }
}
