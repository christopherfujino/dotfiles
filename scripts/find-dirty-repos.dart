#!/usr/bin/env dart

import 'dart:io' as io;

Future<void> main(List<String> args) async {
  final root = io.Directory(args.first);
  final dirtyRepos = <io.Directory>[];
  final aheadRepos = <io.Directory>[];

  await visitDirectory(root, (dir) async {
    //print('visiting ${dir.path}');
    final childGitDirPath =
        <String>[dir.path, '.git'].join(io.Platform.pathSeparator);
    final childGitDir = io.Directory(childGitDirPath);
    bool exists;
    try {
      exists = childGitDir.existsSync();
    } on io.FileSystemException {
      // it prob exists, but if you can't access it doesn't matter
      exists = false;
    }
    if (exists) {
      if (await _hasUncommittedChanges(dir)) {
        dirtyRepos.add(dir);
      }
      if (await _isAheadOfRemote(dir)) {
        aheadRepos.add(dir);
      }
    }
  });

  print(
    '\nfound ${dirtyRepos.length} dirty repos:\n'
    '${dirtyRepos.map((repo) => repo.path).join('\n')}',
  );
  print(
    '\nfound ${aheadRepos.length} ahead repos:\n'
    '${aheadRepos.map((repo) => repo.path).join('\n')}',
  );
}

Future<bool> _isAheadOfRemote(io.Directory dir) async {
  final result = await io.Process.run(
    'git',
    const <String>['status', '-uno'],
    workingDirectory: dir.path,
  );
  return result.stdout.contains('is ahead of');
}

Future<bool> _hasUncommittedChanges(io.Directory dir) async {
  try {
    final result = await io.Process.run(
      'git',
      const <String>['diff-files', '--quiet'],
      workingDirectory: dir.path,
    );
    if (result.exitCode != 0) {
      print('Found dirty git checkout at ${dir.path}');
      final process = await io.Process.start(
        'git',
        const <String>['status'],
        workingDirectory: dir.path,
        mode: io.ProcessStartMode.inheritStdio,
      );
      await process.exitCode;
      return true;
    }
    return false;
  } on io.ProcessException {
    print('failed run git in ${dir.path}');
    rethrow;
  }
}

typedef Visit = Future<void> Function(io.Directory dir);

Future<void> visitDirectory(io.Directory dir, Visit visit) async {
  await visit(dir);
  List<io.FileSystemEntity> entities;
  try {
    entities = dir.listSync();
  } on io.PathAccessException {
    entities = const <io.FileSystemEntity>[];
  }
  final futures = <Future<void>>[];
  for (final entity in entities) {
    if (entity is! io.Directory) {
      continue;
    }
    futures.add(visitDirectory(entity, visit));
  }
  await Future.wait(futures);
}
