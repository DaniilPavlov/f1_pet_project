import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';
import 'package:f1_pet_project/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum _PredictorAuthState { signedOut, unverified, ok }

/// Guard для экранов предиктора: нужен вход + подтверждённый email.
///
/// Слушает [AuthService.userChanges] с `distinct`, чтобы не пересоздавать
/// дерево [child] на каждый token refresh.
class PredictorAuthGate extends StatelessWidget {
  const PredictorAuthGate({required this.child, super.key});

  final Widget child;

  static _PredictorAuthState _stateOf(AuthService auth) {
    if (!auth.isSignedIn) {
      return _PredictorAuthState.signedOut;
    }
    if (!auth.canUsePredictor) {
      return _PredictorAuthState.unverified;
    }
    return _PredictorAuthState.ok;
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthService>();

    return StreamBuilder<_PredictorAuthState>(
      initialData: _stateOf(auth),
      stream: auth.userChanges.map((_) => _stateOf(auth)).distinct(),
      builder: (context, snapshot) {
        final state = snapshot.data ?? _stateOf(auth);
        if (state == _PredictorAuthState.signedOut) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) {
              return;
            }
            context.router.replace(const AuthSignInRoute());
          });
          return const Scaffold(body: SizedBox.shrink());
        }
        if (state == _PredictorAuthState.unverified) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) {
              return;
            }
            context.router.maybePop();
          });
          return const Scaffold(body: SizedBox.shrink());
        }
        return child;
      },
    );
  }
}
