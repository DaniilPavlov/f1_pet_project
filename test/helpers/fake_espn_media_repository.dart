import 'package:dio/dio.dart';
import 'package:f1_pet_project/common/models/espn/espn_driver_card_data.dart';
import 'package:f1_pet_project/common/repositories/espn/espn_media_repository.dart';
import 'package:f1_pet_project/core/news/models/news_article_model.dart';

/// ESPN media stub for controller unit tests (no network).
class FakeEspnMediaRepository extends EspnMediaRepository {
  FakeEspnMediaRepository({
    this.driverCard = const EspnDriverCardData(),
    this.constructorArticles = const [],
    this.throwOnDriverCard = false,
    this.throwOnConstructorNews = false,
    this.driverCardFuture,
  }) : super(dio: Dio());

  final EspnDriverCardData driverCard;
  final List<NewsArticleModel> constructorArticles;
  final bool throwOnDriverCard;
  final bool throwOnConstructorNews;
  final Future<EspnDriverCardData>? driverCardFuture;

  int driverCardCalls = 0;
  int constructorNewsCalls = 0;

  @override
  Future<EspnDriverCardData> driverCardData({required String givenName, required String familyName}) async {
    driverCardCalls++;
    if (throwOnDriverCard) {
      throw Exception('espn driver card failed');
    }
    if (driverCardFuture != null) {
      return driverCardFuture!;
    }
    return driverCard;
  }

  @override
  Future<List<NewsArticleModel>> constructorNews({
    required String constructorId,
    required String constructorName,
  }) async {
    constructorNewsCalls++;
    if (throwOnConstructorNews) {
      throw Exception('espn constructor news failed');
    }
    return constructorArticles;
  }
}
