import 'dart:ui' as ui;

import 'package:f1_pet_project/common/career/models/career_stats.dart';
import 'package:f1_pet_project/common/widgets/share/share_career_card.dart';
import 'package:f1_pet_project/common/widgets/share/share_race_results_card.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';

/// Шаринг карьеры и результатов гонки картинкой.
abstract class ShareHelper {
  static Future<void> shareCareerCard({
    required BuildContext context,
    required AppLocalizations l10n,
    required String title,
    required CareerStats<dynamic> stats,
  }) {
    return _shareWidgetImage(
      context: context,
      fileName: 'f1_career_${DateTime.now().millisecondsSinceEpoch}.png',
      child: ShareCareerCard(l10n: l10n, title: title, stats: stats),
    );
  }

  static Future<void> shareRaceResultsCard({
    required BuildContext context,
    required AppLocalizations l10n,
    required RacesModel race,
  }) {
    return _shareWidgetImage(
      context: context,
      fileName: 'f1_race_${race.season}_${race.round}.png',
      child: ShareRaceResultsCard(l10n: l10n, race: race),
    );
  }

  static Future<void> _shareWidgetImage({
    required BuildContext context,
    required String fileName,
    required Widget child,
  }) async {
    final overlay = Overlay.maybeOf(context);
    if (overlay == null) {
      return;
    }

    final boundaryKey = GlobalKey();
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => Positioned(
        left: -10000,
        top: 0,
        child: Material(
          type: MaterialType.transparency,
          child: RepaintBoundary(
            key: boundaryKey,
            child: child,
          ),
        ),
      ),
    );

    overlay.insert(entry);
    await WidgetsBinding.instance.endOfFrame;
    // Даём кадру дорисоваться (логотип / layout).
    await Future<void>.delayed(const Duration(milliseconds: 80));

    try {
      final boundary = boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        return;
      }
      final image = await boundary.toImage(pixelRatio: 3);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        return;
      }

      final bytes = byteData.buffer.asUint8List();

      if (!context.mounted) {
        return;
      }
      final box = context.findRenderObject() as RenderBox?;
      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile.fromData(bytes, mimeType: 'image/png', name: fileName),
          ],
          sharePositionOrigin: box == null ? null : box.localToGlobal(Offset.zero) & box.size,
        ),
      );
    } finally {
      entry.remove();
    }
  }
}
