// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthController on AuthControllerBase, Store {
  late final _$emailAtom = Atom(
    name: 'AuthControllerBase.email',
    context: context,
  );

  @override
  String get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(String value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  late final _$passwordAtom = Atom(
    name: 'AuthControllerBase.password',
    context: context,
  );

  @override
  String get password {
    _$passwordAtom.reportRead();
    return super.password;
  }

  @override
  set password(String value) {
    _$passwordAtom.reportWrite(value, super.password, () {
      super.password = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: 'AuthControllerBase.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorKeyAtom = Atom(
    name: 'AuthControllerBase.errorKey',
    context: context,
  );

  @override
  String? get errorKey {
    _$errorKeyAtom.reportRead();
    return super.errorKey;
  }

  @override
  set errorKey(String? value) {
    _$errorKeyAtom.reportWrite(value, super.errorKey, () {
      super.errorKey = value;
    });
  }

  late final _$signInAsyncAction = AsyncAction(
    'AuthControllerBase.signIn',
    context: context,
  );

  @override
  Future<bool> signIn() {
    return _$signInAsyncAction.run(() => super.signIn());
  }

  late final _$registerAsyncAction = AsyncAction(
    'AuthControllerBase.register',
    context: context,
  );

  @override
  Future<bool> register() {
    return _$registerAsyncAction.run(() => super.register());
  }

  late final _$sendPasswordResetAsyncAction = AsyncAction(
    'AuthControllerBase.sendPasswordReset',
    context: context,
  );

  @override
  Future<bool> sendPasswordReset() {
    return _$sendPasswordResetAsyncAction.run(() => super.sendPasswordReset());
  }

  late final _$AuthControllerBaseActionController = ActionController(
    name: 'AuthControllerBase',
    context: context,
  );

  @override
  void setEmail(String value) {
    final _$actionInfo = _$AuthControllerBaseActionController.startAction(
      name: 'AuthControllerBase.setEmail',
    );
    try {
      return super.setEmail(value);
    } finally {
      _$AuthControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPassword(String value) {
    final _$actionInfo = _$AuthControllerBaseActionController.startAction(
      name: 'AuthControllerBase.setPassword',
    );
    try {
      return super.setPassword(value);
    } finally {
      _$AuthControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
email: ${email},
password: ${password},
isLoading: ${isLoading},
errorKey: ${errorKey}
    ''';
  }
}
