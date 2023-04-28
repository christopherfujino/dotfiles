#!/usr/bin/env dart

import 'dart:io' as io;

void main(List<String> args) {
  if (args.length < 2) {
    throw Exception('Usage: do-until-success.dart <timeout in seconds> <command with args to execute>');
  }

  final int timeout = int.parse(args[0]);

  final List<String> subCommand = args.sublist(1);

  final result = io.Process.runSync(subCommand.first, subCommand.sublist(1));
  throw result;
}
