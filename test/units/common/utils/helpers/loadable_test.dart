import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Loadable', () {
    test('flags and transitions', () {
      const loading = Loadable<int>.loading();
      expect(loading.isLoading, isTrue);

      final value = loading.toValue(7);
      expect(value.isValue, isTrue);
      expect(value.value, 7);

      final error = value.toError('boom');
      expect(error.isError, isTrue);
      expect(error.error?.errorMessage, 'boom');

      const ex = CustomException(title: 'fail');
      final fromEx = value.toErrorFrom(ex);
      expect(fromEx.exception, ex);
      expect(fromEx.value, 7);
    });

    test('equality and toString', () {
      const a = Loadable.value(value: 1);
      const b = Loadable.value(value: 1);
      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a.toString(), contains('value'));
      expect(const LoadableError(errorMessage: 'x').toString(), contains('x'));

      const errA = LoadableError(errorMessage: 'x', errorObject: 1);
      const errB = LoadableError(errorMessage: 'x', errorObject: 1);
      expect(errA, errB);
      expect(errA.hashCode, errB.hashCode);
      expect(errA == const LoadableError(errorMessage: 'y'), isFalse);

      const raw = Loadable<int>(status: LoadableStatus.value, value: 7);
      expect(raw.value, 7);
      expect(raw.isValue, isTrue);
    });
  });

  group('firstException', () {
    test('returns first CustomException', () {
      const ex = CustomException(title: 'a');
      final values = [
        const Loadable<int>.value(value: 1),
        const Loadable<int>.error(error: LoadableError(errorMessage: 'a', errorObject: ex)),
        const Loadable<int>.error(
          error: LoadableError(errorMessage: 'b', errorObject: CustomException(title: 'b')),
        ),
      ];
      expect(firstException(values)?.title, 'a');
      expect(firstException(const [Loadable.value(value: 1)]), isNull);
    });
  });

  group('runAsyncLoad', () {
    test('sets value on success', () async {
      var field = const Loadable<int>.loading();
      await runAsyncLoad<int, int>(
        fetch: () async => 42,
        getField: () => field,
        setField: (v) => field = v,
        onSuccess: (data) => field = field.toValue(data!),
      );
      expect(field.value, 42);
    });

    test('sets error on failure', () async {
      var field = const Loadable<int>.loading();
      await runAsyncLoad<int, int>(
        fetch: () async => throw Exception('nope'),
        getField: () => field,
        setField: (v) => field = v,
        onSuccess: (_) {},
        maxAttempts: 1,
      );
      expect(field.isError, isTrue);
    });
  });
}
