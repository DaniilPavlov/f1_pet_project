import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/core/news/components/news_article_tile.dart';
import 'package:f1_pet_project/core/news/models/news_article_model.dart';
import 'package:flutter/material.dart';

/// Блок связанных новостей ESPN (пилот / конструктор; скрывается, если список пуст).
class EspnDriverNewsSection extends StatelessWidget {
  const EspnDriverNewsSection({required this.news, this.title, super.key});

  final List<NewsArticleModel> news;
  final String? title;

  @override
  Widget build(BuildContext context) {
    if (news.isEmpty) {
      return const SizedBox.shrink();
    }

    final locale = Localizations.localeOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 28),
        Text(title ?? context.l10n.driverNewsTitle, style: AppStyles.h2),
        const SizedBox(height: 12),
        ...news.map(
          (article) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: NewsArticleTile(article: article, locale: locale),
          ),
        ),
      ],
    );
  }
}
