import 'dart:io' as io;

const int N = 1000;

Future<void> main(List<String> args) async {
  if (args.length != 1) {
    throw ArgumentError(
      'Please provide a single argument as a path to the test file to run',
    );
  }
  final String testFile = args.first;
  final DateTime now = DateTime.now();
  for (int i = 0; i < N; i += 1) {
    final DateTime then = now.add(Duration(days: i));
    print('using seed $then');
    final io.Process process = await io.Process.start(
      'dart',
      <String>[
        'test',
        testFile,
        '--test-randomize-ordering-seed=${_getSeed(then)}',
        '--reporter=expanded',
      ],
      mode: io.ProcessStartMode.inheritStdio,
    );
    final int exitCode = await process.exitCode;
    if (exitCode != 0) {
      throw Exception('Got one!');
    }
  }
  print('success!');
}

int _getSeed(DateTime then) {
  return then.year * 10000 + then.month * 100 + then.day;
}
