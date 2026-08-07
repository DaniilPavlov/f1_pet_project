import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/localization/locale_controller.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/anti_glow_behavior.dart';
import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/utils/theme/theme_controller.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/common/widgets/buttons/black_button.dart';
import 'package:f1_pet_project/core/profile/controllers/notifications_preference_controller/notifications_preference_controller.dart';
import 'package:f1_pet_project/core/profile/utils/auth_error_l10n.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Вкладка профиля: аккаунт, тема/язык, уведомления.
@RoutePage()
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authServiceProvider);

    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.profileTitle, showPreferences: false),
      body: SafeArea(
        child: StreamBuilder<User?>(
          stream: auth.userChanges,
          initialData: auth.currentUser,
          builder: (context, snapshot) {
            final user = snapshot.data;
            final verified = user?.emailVerified ?? false;
            return ScrollConfiguration(
              behavior: AntiGlowBehavior(),
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: StaticData.defaultHorizontalPadding,
                  vertical: 16,
                ),
                children: [
                  _SectionTitle(context.l10n.profileAccountSection),
                  const SizedBox(height: 8),
                  Text(
                    user?.email == null
                        ? context.l10n.profileNotSignedIn
                        : context.l10n.profileSignedInAs(user!.email!),
                    style: AppStyles.body.copyWith(color: context.colors.black),
                  ),
                  if (user != null && !verified) ...[
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.profileEmailNotVerified,
                      style: AppStyles.caption.copyWith(color: context.colors.textGray),
                    ),
                    const SizedBox(height: 12),
                    BlackButton(
                      text: context.l10n.profileResendVerification,
                      isDisabled: false,
                      onTap: () async {
                        final result = await auth.sendEmailVerification();
                        if (!context.mounted) {
                          return;
                        }
                        final failMsg = authErrorMessage(context.l10n, result.errorMessage);
                        await Fluttertoast.showToast(
                          msg: result.isSuccess
                              ? context.l10n.profileVerificationSent
                              : (failMsg.isEmpty ? context.l10n.authErrorGeneric : failMsg),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    BlackButton(
                      text: context.l10n.profileRefreshVerification,
                      isDisabled: false,
                      onTap: () async {
                        final ok = await auth.refreshEmailVerification();
                        if (!context.mounted) {
                          return;
                        }
                        await Fluttertoast.showToast(
                          msg: ok ? context.l10n.profileEmailVerified : context.l10n.profileStillNotVerified,
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: 12),
                  if (user == null)
                    BlackButton(
                      text: context.l10n.profileSignIn,
                      isDisabled: false,
                      onTap: () => context.router.push(const AuthSignInRoute()),
                    )
                  else
                    BlackButton(
                      text: context.l10n.profileSignOut,
                      isDisabled: false,
                      onTap: () async {
                        await auth.signOut();
                        if (context.mounted) {
                          ref.read(predictorRepositoryProvider).clearMemoryCache();
                          ref.read(predictorLeaderboardRepositoryProvider).clearMemoryCache();
                        }
                      },
                    ),
                  const SizedBox(height: 28),
                  _SectionTitle(context.l10n.profileAppearanceSection),
                  const SizedBox(height: 8),
                  const _ThemeRow(),
                  const SizedBox(height: 8),
                  const _LocaleRow(),
                  const SizedBox(height: 28),
                  _SectionTitle(context.l10n.profileNotificationsSection),
                  const SizedBox(height: 8),
                  const _NotificationsRow(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppStyles.h3.copyWith(color: context.colors.black, fontSize: 18, height: 1.2));
  }
}

class _ThemeRow extends ConsumerWidget {
  const _ThemeRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeControllerProvider);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(context.l10n.profileTheme, style: AppStyles.body.copyWith(color: context.colors.black)),
      trailing: Icon(themeState.preferenceIcon, color: AppTheme.red),
      onTap: () => ref.read(themeControllerProvider.notifier).cycle(),
    );
  }
}

class _LocaleRow extends ConsumerWidget {
  const _LocaleRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeState = ref.watch(localeControllerProvider);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(context.l10n.profileLanguage, style: AppStyles.body.copyWith(color: context.colors.black)),
      trailing: Text(
        localeState.localeCodeLabel,
        style: AppStyles.body.copyWith(color: AppTheme.red, fontWeight: FontWeight.w600),
      ),
      onTap: () async {
        await ref.read(localeControllerProvider.notifier).toggle();
        if (!context.mounted) {
          return;
        }
        final prefs = ref.read(notificationsPreferenceControllerProvider);
        if (prefs.effectivelyEnabled) {
          await ref.read(notificationsPreferenceControllerProvider.notifier).resync(
            locale: ref.read(localeControllerProvider).locale,
          );
        }
      },
    );
  }
}

class _NotificationsRow extends ConsumerWidget {
  const _NotificationsRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(notificationsPreferenceControllerProvider);
    final locale = ref.watch(localeControllerProvider).locale;
    final canToggle = prefs.canToggle;
    final canTogglePractice = prefs.canTogglePractice;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            context.l10n.profileRaceReminders,
            style: AppStyles.body.copyWith(color: context.colors.black),
          ),
          subtitle: Text(
            canToggle
                ? context.l10n.profileRaceRemindersSubtitle
                : context.l10n.profileRaceRemindersDisabledByRemote,
            style: AppStyles.caption.copyWith(color: context.colors.textGray),
          ),
          value: prefs.effectivelyEnabled,
          activeThumbColor: AppTheme.red,
          onChanged: !canToggle
              ? null
              : (value) => ref.read(notificationsPreferenceControllerProvider.notifier).setEnabled(
                    enabled: value,
                    locale: locale,
                  ),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            context.l10n.profilePracticeReminders,
            style: AppStyles.body.copyWith(
              color: canTogglePractice ? context.colors.black : context.colors.textGray,
            ),
          ),
          subtitle: Text(
            context.l10n.profilePracticeRemindersSubtitle,
            style: AppStyles.caption.copyWith(color: context.colors.textGray),
          ),
          value: prefs.practiceRemindersEffectivelyEnabled,
          activeThumbColor: AppTheme.red,
          onChanged: !canTogglePractice
              ? null
              : (value) => ref.read(notificationsPreferenceControllerProvider.notifier).setPracticeRemindersEnabled(
                    enabled: value,
                    locale: locale,
                  ),
        ),
      ],
    );
  }
}
