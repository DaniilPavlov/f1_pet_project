import 'package:f1_pet_project/core/news/models/news_article_model.dart';

/// ESPN-данные для карточки пилота: фото и новости.
class EspnDriverCardData {
  const EspnDriverCardData({
    this.photoUrl,
    this.news = const [],
  });

  final String? photoUrl;
  final List<NewsArticleModel> news;
}
