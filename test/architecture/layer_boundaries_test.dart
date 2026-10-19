import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Fails if the domain layer imports Flutter, Firebase, or outer layers.
void main() {
  test('domain layer has no framework or outer-layer imports', () {
    final files = Directory('lib/features/habits/domain')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) =>
            f.path.endsWith('.dart') && !f.path.endsWith('.freezed.dart'));

    const forbidden = [
      'package:flutter',
      'cloud_firestore',
      '/data/',
      '/presentation/'
    ];
    final violations = <String>[];
    for (final f in files) {
      for (final line in f
          .readAsLinesSync()
          .where((l) => l.trimLeft().startsWith('import'))) {
        if (forbidden.any(line.contains)) violations.add('${f.path}: $line');
      }
    }
    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('presentation layer does not import the data layer', () {
    final files = Directory('lib/features/habits/presentation')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) =>
            f.path.endsWith('.dart') && !f.path.endsWith('.freezed.dart'));
    final violations = <String>[];
    for (final f in files) {
      for (final line in f
          .readAsLinesSync()
          .where((l) => l.trimLeft().startsWith('import'))) {
        if (line.contains('/data/') || line.contains('cloud_firestore')) {
          violations.add('${f.path}: $line');
        }
      }
    }
    expect(violations, isEmpty, reason: violations.join('\n'));
  });
}
