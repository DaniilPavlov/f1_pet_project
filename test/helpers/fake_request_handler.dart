import 'package:dio/dio.dart';
import 'package:f1_pet_project/services/request_handler.dart';

/// In-memory Jolpica [RequestHandler] for repository / CareerApiHelper tests.
class FakeRequestHandler extends RequestHandler {
  FakeRequestHandler({
    Map<String, Map<String, dynamic>>? responses,
    this.resolver,
  }) : responses = responses ?? {};

  /// Exact path → full JSON body (`MRData` included).
  final Map<String, Map<String, dynamic>> responses;

  /// Optional dynamic resolver: `(path, limit, offset) → body`.
  final Map<String, dynamic> Function(String path, int limit, int offset)? resolver;

  final List<({String path, int limit, int offset})> calls = [];

  @override
  Future<Response<T>> get<T>(
    String path, {
    int limit = 100,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) async {
    final offset = (queryParameters?['offset'] as int?) ?? 0;
    calls.add((path: path, limit: limit, offset: offset));

    final body = resolver?.call(path, limit, offset) ?? responses[path];
    if (body == null) {
      throw StateError('FakeRequestHandler: no response for path "$path" (limit=$limit offset=$offset)');
    }

    return Response<T>(
      requestOptions: RequestOptions(path: path),
      data: body as T,
      statusCode: 200,
    );
  }
}
