import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:flutter/foundation.dart';

@immutable
class AsyncValue<T> {
  const AsyncValue({
    required this.status,
    this.value,
    this.error,
  });

  const AsyncValue.loading({
    this.value,
    this.error,
  }) : status = AsyncStatus.loading;

  const AsyncValue.value({
    this.value,
    this.error,
  }) : status = AsyncStatus.value;

  const AsyncValue.error({
    this.value,
    this.error,
  }) : status = AsyncStatus.error;

  final AsyncStatus status;
  final T? value;
  final AsyncError? error;

  bool get isLoading => status == AsyncStatus.loading;

  bool get isValue => status == AsyncStatus.value;

  bool get isError => status == AsyncStatus.error;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AsyncValue &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          value == other.value &&
          error == other.error;

  @override
  int get hashCode => Object.hashAll([status, value, error]);

  @override
  String toString() {
    return 'AsyncValue{status: $status, value: $value, error: $error}';
  }
}

enum AsyncStatus {
  loading,
  error,
  value,
}

@immutable
class AsyncError {
  const AsyncError({
    required this.errorMessage,
    this.errorObject,
  });

  final String errorMessage;
  final Object? errorObject;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AsyncError &&
          runtimeType == other.runtimeType &&
          errorMessage == other.errorMessage &&
          errorObject == other.errorObject;

  @override
  int get hashCode => Object.hashAll([errorMessage, errorObject]);

  @override
  String toString() {
    return 'AsyncError{errorMessage: $errorMessage, errorObject: $errorObject}';
  }
}

extension AsyncValueX<T> on AsyncValue<T> {
  AsyncValue<T> toLoading() => AsyncValue.loading(value: value);

  AsyncValue<T> toValue(T newValue) => AsyncValue.value(value: newValue);

  AsyncValue<T> toError(String message) => AsyncValue.error(error: AsyncError(errorMessage: message));

  AsyncValue<T> toErrorFrom(CustomException exception) => AsyncValue.error(
    error: AsyncError(errorMessage: exception.title, errorObject: exception),
  );

  CustomException? get exception => error?.errorObject as CustomException?;
}
