// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_screen_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$NewsScreenController on NewsScreenControllerBase, Store {
  Computed<CustomException?>? _$screenErrorComputed;

  @override
  CustomException? get screenError =>
      (_$screenErrorComputed ??= Computed<CustomException?>(
        () => super.screenError,
        name: 'NewsScreenControllerBase.screenError',
      )).value;

  late final _$articlesAtom = Atom(
    name: 'NewsScreenControllerBase.articles',
    context: context,
  );

  @override
  AsyncValue<List<NewsArticleModel>> get articles {
    _$articlesAtom.reportRead();
    return super.articles;
  }

  @override
  set articles(AsyncValue<List<NewsArticleModel>> value) {
    _$articlesAtom.reportWrite(value, super.articles, () {
      super.articles = value;
    });
  }

  late final _$loadArticlesAsyncAction = AsyncAction(
    'NewsScreenControllerBase.loadArticles',
    context: context,
  );

  @override
  Future<void> loadArticles({bool forceRefresh = false}) {
    return _$loadArticlesAsyncAction.run(
      () => super.loadArticles(forceRefresh: forceRefresh),
    );
  }

  late final _$NewsScreenControllerBaseActionController = ActionController(
    name: 'NewsScreenControllerBase',
    context: context,
  );

  @override
  Future<void> refreshAll() {
    final _$actionInfo = _$NewsScreenControllerBaseActionController.startAction(
      name: 'NewsScreenControllerBase.refreshAll',
    );
    try {
      return super.refreshAll();
    } finally {
      _$NewsScreenControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
articles: ${articles},
screenError: ${screenError}
    ''';
  }
}
