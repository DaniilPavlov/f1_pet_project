import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/common/widgets/buttons/black_button.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';
import 'package:f1_pet_project/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum _PredictorAuthState { signedOut, unverified, ok }

/// Guard для экранов предиктора: нужен вход + подтверждённый email.
///
/// [asTabRoot]: на вкладке показываем CTA вместо redirect/pop
/// (иначе вкладка «ломалась» бы при выходе из аккаунта).
class PredictorAuthGate extends StatelessWidget {
  const PredictorAuthGate({
    required this.child,
    this.asTabRoot = false,
    super.key,
  });

  final Widget child;
  final bool asTabRoot;

  static _PredictorAuthState _stateOf(AuthService auth) {
    if (!auth.isSignedIn) {
      return _PredictorAuthState.signedOut;
    }
    if (!auth.canUsePredictor) {
      return _PredictorAuthState.unverified;
    }
    return _PredictorAuthState.ok;
  }

  void _openSignIn(BuildContext context) {
    context.router.navigate(const ProfileRouter(children: [AuthSignInRoute()]));
  }

  void _openProfile(BuildContext context) {
    context.router.navigate(const ProfileRouter());
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthService>();

    return StreamBuilder<_PredictorAuthState>(
      initialData: _stateOf(auth),
      stream: auth.userChanges.map((_) => _stateOf(auth)).distinct(),
      builder: (context, snapshot) {
        final state = snapshot.data ?? _stateOf(auth);
        if (state == _PredictorAuthState.ok) {
          return child;
        }

        if (!asTabRoot) {
          if (state == _PredictorAuthState.signedOut) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!context.mounted) {
                return;
              }
              context.router.replace(const AuthSignInRoute());
            });
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!context.mounted) {
                return;
              }
              context.router.maybePop();
            });
          }
          return const Scaffold(body: SizedBox.shrink());
        }

        final message = state == _PredictorAuthState.signedOut
            ? context.l10n.profilePredictorRequiresAuth
            : context.l10n.profilePredictorRequiresVerification;
        final buttonText = state == _PredictorAuthState.signedOut
            ? context.l10n.profileSignIn
            : context.l10n.navProfile;

        return Scaffold(
          appBar: CustomAppBar(title: context.l10n.predictorTitle),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: StaticData.defaultHorizontalPadding),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: AppStyles.body.copyWith(color: context.colors.black),
                    ),
                    const SizedBox(height: 16),
                    BlackButton(
                      text: buttonText,
                      isDisabled: false,
                      onTap: () {
                        if (state == _PredictorAuthState.signedOut) {
                          _openSignIn(context);
                        } else {
                          _openProfile(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
