#!/usr/bin/env dart

import 'dart:async';
import 'dart:io';

const totalRuns = 100;

const String _frames = '-*Ox';

Future<void> main(List<String> args) async {
  int x = 0;
  String message = '';
  final timer = Timer.periodic(const Duration(milliseconds: 100), (Timer _) {
    stdout.write('\r$message ${_frames[x]}');
    x++;
    if (x == _frames.length) {
      x = 0;
    }
  });
  if (args.length != 2) {
    throw 'Usage: <script> <test file> <regex pattern>';
  }
  final testPath = args.first;
  final pattern = args[1];
  for (int testsRun = 0; testsRun < totalRuns; testsRun++) {
    final result = await Process.run(
      'dart',
      <String>['test', testPath, '--reporter=expanded', '-n', pattern],
    );
    //final RegExpMatch? match = RegExp(r'^got (.*$)', multiLine: true).firstMatch(result.stdout as String);
    if (result.exitCode != 0) {
      print('');
      print('Found a failure after ${testsRun + 1} runs.');
      print('exit code: ${result.exitCode}');
      print('stderr: ${result.stderr}');
      print('stdout: ${result.stdout}');
      exit(1);
    }
    //print(match.group(1));

    message = 'Successful run ${testsRun + 1}.';
  }
  print('\nDone!');
  timer.cancel();
}
