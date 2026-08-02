import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/common/widgets/buttons/black_button.dart';
import 'package:f1_pet_project/common/widgets/text_fields/custom_text_field.dart';
import 'package:f1_pet_project/core/profile/controllers/auth_controller/auth_controller.dart';
import 'package:f1_pet_project/core/profile/utils/auth_error_l10n.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';
import 'package:f1_pet_project/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

/// Экран входа по email/password.
@RoutePage()
class AuthSignInScreen extends StatelessWidget {
  const AuthSignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => AuthController(authService: context.read<AuthService>()),
      child: Scaffold(
        appBar: CustomAppBar(
          title: context.l10n.authSignInTitle,
          showPreferences: false,
          onPop: () => context.router.maybePop(),
        ),
        body: const SafeArea(child: _AuthForm(isRegister: false)),
      ),
    );
  }
}

/// Экран регистрации по email/password.
@RoutePage()
class AuthRegisterScreen extends StatelessWidget {
  const AuthRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => AuthController(authService: context.read<AuthService>()),
      child: Scaffold(
        appBar: CustomAppBar(
          title: context.l10n.authRegisterTitle,
          showPreferences: false,
          onPop: () => context.router.maybePop(),
        ),
        body: const SafeArea(child: _AuthForm(isRegister: true)),
      ),
    );
  }
}

class _AuthForm extends StatelessWidget {
  const _AuthForm({required this.isRegister});

  final bool isRegister;

  @override
  Widget build(BuildContext context) {
    final controller = context.read<AuthController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: StaticData.defaultHorizontalPadding, vertical: 16),
      child: Observer(
        builder: (context) {
          final error = authErrorMessage(context.l10n, controller.errorKey);
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                  label: context.l10n.authEmailLabel,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onChanged: controller.setEmail,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  label: context.l10n.authPasswordLabel,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  onChanged: controller.setPassword,
                  onSubmit: (_) async {
                    final ok = isRegister ? await controller.register() : await controller.signIn();
                    if (ok && context.mounted) {
                      context.router.popUntilRouteWithName(ProfileRoute.name);
                    }
                  },
                ),
                if (error.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(error, style: AppStyles.caption.copyWith(color: context.colors.red)),
                ],
                if (!isRegister) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: controller.isLoading
                          ? null
                          : () async {
                              final ok = await controller.sendPasswordReset();
                              if (!context.mounted) {
                                return;
                              }
                              if (ok) {
                                await Fluttertoast.showToast(msg: context.l10n.authPasswordResetSent);
                              }
                            },
                      child: Text(
                        context.l10n.authForgotPassword,
                        style: AppStyles.caption.copyWith(color: context.colors.textGray),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                BlackButton(
                  text: isRegister ? context.l10n.profileRegister : context.l10n.profileSignIn,
                  isDisabled: controller.isLoading,
                  onTap: () async {
                    final ok = isRegister ? await controller.register() : await controller.signIn();
                    if (ok && context.mounted) {
                      context.router.popUntilRouteWithName(ProfileRoute.name);
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: controller.isLoading
                      ? null
                      : () {
                          if (isRegister) {
                            context.router.replace(const AuthSignInRoute());
                          } else {
                            context.router.replace(const AuthRegisterRoute());
                          }
                        },
                  child: Text(
                    isRegister ? context.l10n.authHaveAccount : context.l10n.authNoAccount,
                    style: AppStyles.body.copyWith(color: context.colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
