import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/anti_glow_behavior.dart';
import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/common/widgets/buttons/black_button.dart';
import 'package:f1_pet_project/common/widgets/custom_loading_indicator.dart';
import 'package:f1_pet_project/common/widgets/error_body.dart';
import 'package:f1_pet_project/common/widgets/text_fields/custom_text_field.dart';
import 'package:f1_pet_project/core/predictor/components/predictor_auth_gate.dart';
import 'package:f1_pet_project/core/predictor/components/predictor_leaderboard_tile.dart';
import 'package:f1_pet_project/core/predictor/controllers/predictor_leaderboard_controller/predictor_leaderboard_controller.dart';
import 'package:f1_pet_project/core/predictor/utils/predictor_leaderboard_error_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

/// Лидерборд предиктора за сезон + opt-in с ником.
@RoutePage()
class PredictorLeaderboardScreen extends ConsumerWidget {
  const PredictorLeaderboardScreen({
    required this.year,
    this.myPoints = 0,
    super.key,
  });

  final String year;
  final int myPoints;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = PredictorLeaderboardArgs(year: year, myPoints: myPoints);

    return PredictorAuthGate(
      child: _LeaderboardAuthedScreen(args: args),
    );
  }
}

class _LeaderboardAuthedScreen extends ConsumerStatefulWidget {
  const _LeaderboardAuthedScreen({required this.args});

  final PredictorLeaderboardArgs args;

  @override
  ConsumerState<_LeaderboardAuthedScreen> createState() => _LeaderboardAuthedScreenState();
}

class _LeaderboardAuthedScreenState extends ConsumerState<_LeaderboardAuthedScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(predictorLeaderboardControllerProvider(widget.args).notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(predictorLeaderboardControllerProvider(widget.args));
    final controller = ref.read(predictorLeaderboardControllerProvider(widget.args).notifier);

    return Scaffold(
      appBar: CustomAppBar(
        title: context.l10n.predictorLeaderboardTitle(widget.args.year),
        onPop: () => context.router.maybePop(),
      ),
      body: SafeArea(
        child: Builder(
          builder: (context) {
            if (state.screenError != null) {
              return ErrorBody(
                onTap: controller.load,
                title: state.screenError!.title,
                subtitle: state.screenError!.subtitle,
              );
            }
            if (!state.allDataIsLoaded) {
              return const CustomLoadingIndicator();
            }
            return _LeaderboardBody(args: widget.args);
          },
        ),
      ),
    );
  }
}

class _LeaderboardBody extends ConsumerStatefulWidget {
  const _LeaderboardBody({required this.args});

  final PredictorLeaderboardArgs args;

  @override
  ConsumerState<_LeaderboardBody> createState() => _LeaderboardBodyState();
}

class _LeaderboardBodyState extends ConsumerState<_LeaderboardBody> {
  /// Высота [BlackButton]: vertical padding 12×2 + [AppStyles.h3] fontSize 25.
  static const _primaryButtonHeight = 49.0;

  late final TextEditingController _nicknameController;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(predictorLeaderboardControllerProvider(widget.args)).nicknameDraft;
    _nicknameController = TextEditingController(text: draft);
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(predictorLeaderboardControllerProvider(widget.args));
    final controller = ref.read(predictorLeaderboardControllerProvider(widget.args).notifier);
    final entries = state.rankedEntries;
    final myEntry = controller.myEntry;
    final showJoin = state.showJoinForm;
    final formError = predictorLeaderboardErrorMessage(
      context.l10n,
      state.formErrorKey,
    );

    return ScrollConfiguration(
      behavior: AntiGlowBehavior(),
      child: RefreshIndicator(
        onRefresh: controller.load,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            StaticData.defaultHorizontalPadding,
            StaticData.defaultVerticalPadding,
            StaticData.defaultHorizontalPadding,
            StaticData.defaultVerticalPadding,
          ),
          children: [
            if (showJoin) ...[
              Text(
                context.l10n.predictorLeaderboardJoinHint,
                style: AppStyles.body.copyWith(color: context.colors.textGray),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: context.l10n.predictorNicknameLabel,
                hintText: context.l10n.predictorNicknameHint,
                controller: _nicknameController,
                textInputAction: TextInputAction.done,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9_]')),
                  LengthLimitingTextInputFormatter(16),
                ],
                onChanged: controller.setNicknameDraft,
                disabled: state.isSaving,
                errorText: formError.isEmpty ? null : formError,
              ),
              const SizedBox(height: 8),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                value: state.optInAgreed,
                onChanged: state.isSaving ? null : (value) => controller.setOptInAgreed(value ?? false),
                title: Text(
                  context.l10n.predictorLeaderboardOptInLabel,
                  style: AppStyles.caption,
                ),
              ),
              const SizedBox(height: 8),
              if (state.isSaving)
                const SizedBox(
                  height: _primaryButtonHeight,
                  child: Center(child: _LeaderboardActionLoader()),
                )
              else
                BlackButton(
                  text: context.l10n.predictorLeaderboardJoin,
                  isDisabled: false,
                  onTap: controller.join,
                ),
              const SizedBox(height: 24),
            ] else ...[
              if (myEntry != null) ...[
                Text(
                  context.l10n.predictorLeaderboardYourRank(
                    myEntry.rank ?? 0,
                    myEntry.totalPoints,
                  ),
                  style: AppStyles.h3,
                ),
                const SizedBox(height: 12),
              ],
              CustomTextField(
                label: context.l10n.predictorNicknameLabel,
                hintText: context.l10n.predictorNicknameHint,
                controller: _nicknameController,
                textInputAction: TextInputAction.done,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9_]')),
                  LengthLimitingTextInputFormatter(16),
                ],
                onChanged: controller.setNicknameDraft,
                disabled: state.isSaving,
                errorText: formError.isEmpty ? null : formError,
              ),
              const SizedBox(height: 12),
              if (state.isSaving)
                const SizedBox(
                  height: _primaryButtonHeight,
                  child: Center(child: _LeaderboardActionLoader()),
                )
              else ...[
                BlackButton(
                  text: context.l10n.predictorNicknameSave,
                  isDisabled: false,
                  onTap: controller.saveNickname,
                ),
                const SizedBox(height: 12),
                _LeaveLeaderboardButton(
                  isDisabled: false,
                  onTap: controller.leave,
                ),
              ],
              const SizedBox(height: 24),
            ],
            Text(context.l10n.predictorLeaderboardListTitle, style: AppStyles.h3),
            const SizedBox(height: 12),
            if (entries.isEmpty)
              Text(
                context.l10n.predictorLeaderboardEmpty,
                style: AppStyles.caption.copyWith(color: context.colors.textGray),
              )
            else
              for (final entry in entries) ...[
                PredictorLeaderboardTile(
                  entry: entry,
                  isMe: myEntry?.uid == entry.uid,
                ),
                const SizedBox(height: 8),
              ],
          ],
        ),
      ),
    );
  }
}

/// Destructive leave action: same pill shape as [BlackButton], red fill + white label.
class _LeaveLeaderboardButton extends StatelessWidget {
  const _LeaveLeaderboardButton({
    required this.onTap,
    required this.isDisabled,
  });

  final VoidCallback onTap;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      onTap: isDisabled ? () {} : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 17),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: isDisabled ? AppTheme.red.withValues(alpha: 0.35) : AppTheme.red,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          context.l10n.predictorLeaderboardLeave,
          textAlign: TextAlign.center,
          style: AppStyles.h3.copyWith(
            color: isDisabled ? AppTheme.onChrome.withValues(alpha: 0.5) : AppTheme.onChrome,
          ),
        ),
      ),
    );
  }
}

class _LeaderboardActionLoader extends StatelessWidget {
  const _LeaderboardActionLoader();

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.twistingDots(
      leftDotColor: context.colors.black,
      rightDotColor: AppTheme.red,
      size: 28,
    );
  }
}
