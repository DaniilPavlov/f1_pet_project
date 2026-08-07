import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:flutter/foundation.dart';

/// Обёртка над асинхронным значением с состояниями загрузки, данных и ошибки.
///
/// GoF Behavioral State — поведение UI/контроллера зависит от текущего
/// [LoadableStatus] (loading / value / error); переходы через `toLoading` /
/// `toValue` / `toErrorFrom` вместо разрозненных флагов.
@immutable
class Loadable<T> {
  const Loadable({required this.status, this.value, this.error});

  const Loadable.loading({this.value, this.error}) : status = LoadableStatus.loading;

  const Loadable.value({this.value, this.error}) : status = LoadableStatus.value;

  const Loadable.error({this.value, this.error}) : status = LoadableStatus.error;

  final LoadableStatus status;
  final T? value;
  final LoadableError? error;

  bool get isLoading => status == LoadableStatus.loading;

  bool get isValue => status == LoadableStatus.value;

  bool get isError => status == LoadableStatus.error;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Loadable &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          value == other.value &&
          error == other.error;

  @override
  int get hashCode => Object.hashAll([status, value, error]);

  @override
  String toString() {
    return 'Loadable{status: $status, value: $value, error: $error}';
  }
}

/// Статус асинхронного значения.
enum LoadableStatus { loading, error, value }

/// Описание ошибки асинхронной операции.
@immutable
class LoadableError {
  const LoadableError({required this.errorMessage, this.errorObject});

  final String errorMessage;
  final Object? errorObject;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoadableError &&
          runtimeType == other.runtimeType &&
          errorMessage == other.errorMessage &&
          errorObject == other.errorObject;

  @override
  int get hashCode => Object.hashAll([errorMessage, errorObject]);

  @override
  String toString() {
    return 'LoadableError{errorMessage: $errorMessage, errorObject: $errorObject}';
  }
}

/// Методы преобразования [Loadable] между состояниями.
extension LoadableX<T> on Loadable<T> {
  /// Переводит значение в состояние загрузки.
  Loadable<T> toLoading() => Loadable.loading(value: value);

  /// Переводит значение в состояние успеха с данными.
  Loadable<T> toValue(T newValue) => Loadable.value(value: newValue);

  /// Переводит значение в состояние ошибки с сообщением.
  Loadable<T> toError(String message) => Loadable.error(error: LoadableError(errorMessage: message));

  /// Переводит значение в состояние ошибки из [CustomException], сохраняя данные.
  Loadable<T> toErrorFrom(CustomException exception) => Loadable.error(
    value: value,
    error: LoadableError(errorMessage: exception.title, errorObject: exception),
  );

  CustomException? get exception => error?.errorObject as CustomException?;
}
