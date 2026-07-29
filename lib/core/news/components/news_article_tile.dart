import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/utils/trusted_url.dart';
import 'package:f1_pet_project/common/utils/utils.dart';
import 'package:f1_pet_project/core/news/models/news_article_model.dart';
import 'package:f1_pet_project/services/analytics/analytics_event.dart';
import 'package:f1_pet_project/services/analytics/analytics_gateway.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// Плитка статьи: превью, заголовок, описание; тап открывает ESPN.
class NewsArticleTile extends StatelessWidget {
  const NewsArticleTile({required this.article, required this.locale, super.key});

  final NewsArticleModel article;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final byline = article.byline;
    final published = article.published == null
        ? null
        : DateFormat.yMMMd(locale.toLanguageTag()).format(article.published!);
    final hasMeta = (byline != null && byline.isNotEmpty) || published != null;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        context.read<AnalyticsGateway>().log(NewsOpened(headline: article.headline));
        Utils.openUrl(rawUrl: article.webUrl, externalApplication: true);
      },
      child: Container(
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
        foregroundDecoration: BoxDecoration(
          border: Border.all(color: AppTheme.red),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.imageUrl != null)
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  TrustedUrl.preferHttps(article.imageUrl!),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(article.headline, style: AppStyles.h3.copyWith(fontSize: 18, height: 22 / 18)),
                  if (article.description.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(article.description, style: AppStyles.body),
                  ],
                  if (hasMeta) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            byline != null && byline.isNotEmpty ? byline : '',
                            style: AppStyles.caption.copyWith(color: context.colors.textGray),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (published != null)
                          Text(published, style: AppStyles.caption.copyWith(color: context.colors.textGray)),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
