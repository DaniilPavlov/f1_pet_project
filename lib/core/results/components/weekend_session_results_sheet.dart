import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/bottom_sheets/default_bottom_sheet.dart';
import 'package:f1_pet_project/common/widgets/country_flag.dart';
import 'package:f1_pet_project/core/driver/repositories/driver_catalog_repository.dart';
import 'package:f1_pet_project/core/espn/models/espn_scoreboard_models.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

/// Нижний лист с протоколом сессии уикенда (ESPN).
class WeekendSessionResultsSheet extends StatefulWidget {
  const WeekendSessionResultsSheet({required this.session, super.key});

  final EspnScoreboardSession session;

  static Future<void> show(BuildContext context, EspnScoreboardSession session) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => WeekendSessionResultsSheet(session: session),
    );
  }

  @override
  State<WeekendSessionResultsSheet> createState() => _WeekendSessionResultsSheetState();
}

class _WeekendSessionResultsSheetState extends State<WeekendSessionResultsSheet> {
  String? _openingDisplayName;

  Future<void> _openDriver(EspnScoreboardResultEntry entry) async {
    if (_openingDisplayName != null) {
      return;
    }

    setState(() => _openingDisplayName = entry.displayName);
    try {
      final router = context.router;
      final driver = await context.read<DriverCatalogRepository>().findByDisplayName(entry.displayName);
      if (!mounted) {
        return;
      }
      if (driver == null) {
        await Fluttertoast.showToast(msg: context.l10n.driverNotFound, backgroundColor: AppTheme.red);
        return;
      }

      Navigator.of(context).pop();
      await router.push(DriverRoute(driver: driver));
    } finally {
      if (mounted) {
        setState(() => _openingDisplayName = null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = widget.session;
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.65,
      child: DefaultBottomSheet(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.weekendSessionResultsTitle(session.abbreviation), style: AppStyles.h2),
            if (session.statusDetail.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(session.statusDetail, style: AppStyles.caption.copyWith(color: AppTheme.textGray)),
            ],
            const SizedBox(height: 16),
            Expanded(
              child: session.hasResults
                  ? ListView.separated(
                      itemCount: session.results.length,
                      separatorBuilder: (_, _) => const Divider(height: 1, color: AppTheme.strokeGray),
                      itemBuilder: (context, index) {
                        final entry = session.results[index];
                        final isOpening = _openingDisplayName == entry.displayName;
                        return InkWell(
                          onTap: () => _openDriver(entry),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 32,
                                  child: Text(
                                    '${entry.position}',
                                    style: AppStyles.body.copyWith(
                                      color: entry.isWinner ? AppTheme.red : AppTheme.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    entry.displayName,
                                    style: AppStyles.body.copyWith(
                                      color: entry.isWinner ? AppTheme.red : AppTheme.black,
                                    ),
                                  ),
                                ),
                                if (isOpening)
                                  const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.red),
                                  )
                                else if (entry.country != null)
                                  CountryFlag(countryOrNationality: entry.country, fontSize: 20),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        context.l10n.weekendSessionResultsEmpty,
                        style: AppStyles.body.copyWith(color: AppTheme.textGray),
                        textAlign: TextAlign.center,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
