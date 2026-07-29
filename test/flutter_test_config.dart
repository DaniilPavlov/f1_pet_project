import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// Допуск на антиалиасинг Skia (macOS ↔ Linux CI).
const _kGoldenDiffTolerance = 0.01;

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  final previous = goldenFileComparator;
  if (previous is LocalFileComparator) {
    // LocalFileComparator expects a *file* URI; basedir is derived from its directory.
    goldenFileComparator = _TolerantGoldenComparator(
      previous.basedir.resolve('golden_anchor.dart'),
      tolerance: _kGoldenDiffTolerance,
    );
  }
  await testMain();
}

final class _TolerantGoldenComparator extends LocalFileComparator {
  _TolerantGoldenComparator(super.testFile, {required this.tolerance});

  final double tolerance;

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(imageBytes, await getGoldenBytes(golden));

    if (result.passed || result.diffPercent <= tolerance * 100) {
      result.dispose();
      return true;
    }

    final error = await generateFailureOutput(result, golden, basedir);
    result.dispose();
    throw FlutterError(error);
  }
}
