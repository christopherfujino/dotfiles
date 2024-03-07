#!/usr/bin/env dart

import 'dart:convert';
import 'dart:io' as io;

Future<void> main(List<String> args) async {
  final String libraryPath = args.first;

  for (int seed = 456; seed < 1456; seed++) {
    final process = await io.Process.start(
        'dart',
        <String>[
          'test',
          libraryPath,
          '--reporter=expanded',
          '--test-randomize-ordering-seed=$seed'
        ],
        mode: io.ProcessStartMode.normal,);
    final code = await process.exitCode;
    if (code != 0) {
      print('test failed with seed=$seed');
      print(await process.stdout.transform(const Utf8Decoder()).fold<String>('', (prev, cur) => prev + cur));
      print(await process.stderr.transform(const Utf8Decoder()).fold<String>('', (prev, cur) => prev + cur));
      io.exit(code);
    }
    print('seed #${seed.toString().padRight(6)} succeeded');
  }
}
