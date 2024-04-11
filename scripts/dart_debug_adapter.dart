#!/usr/bin/env dart

import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

(io.IOSink, io.IOSink) _setupFiles() {
  final stdoutFile = io.File(
    '${io.Platform.environment['HOME']}/dap.stdout.txt',
  ); // TODO don't hardcode
  final stderrFile = io.File(
    '${io.Platform.environment['HOME']}/dap.stderr.txt',
  ); // TODO don't hardcode

  final stdoutSink = stdoutFile.openWrite();
  final stderrSink = stderrFile.openWrite();

  return (stdoutSink, stderrSink);
}

Future<void> main() async {
  final (stdoutFileSink, stderrFileSink) = _setupFiles();
  final server = await io.Process.start(
    'dart',
    const <String>['debug_adapter'],
  );

  final stdoutSub = (() {
    final buffer = StringBuffer();
    final subscription = server.stdout.listen((List<int> bytes) {
      stdoutFileSink.add(bytes);
      final msg = const Utf8Decoder().convert(bytes);
      buffer.write(msg);
      io.stdout.add(bytes);
    });

    return subscription;
  })();
  final stderrSub = server.stderr.listen((List<int> bytes) {
    stdoutFileSink.add(bytes);
    io.stderr.add(bytes);
  });

  final stdinSub = io.stdin.listen(server.stdin.add);

  // server should close itself
  stdinSub.onDone(() => server.stdin.close());

  final (_, _, exitCode) = await (
    stdoutSub.asFuture<void>(),
    stderrSub.asFuture<void>(),
    server.exitCode,
  ).wait;

  await Future.wait(<Future<void>>[
    stdoutFileSink.close(),
    stderrFileSink.close(),
  ]);

  io.exit(exitCode);
}
