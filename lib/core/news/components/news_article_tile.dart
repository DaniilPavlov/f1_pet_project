import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/utils/trusted_url.dart';
import 'package:f1_pet_project/common/utils/utils.dart';
import 'package:f1_pet_project/core/news/models/news_article_model.dart';
import 'package:f1_pet_project/services/analytics/analytics_event.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Плитка статьи: превью, заголовок, описание; тап открывает ESPN.
class NewsArticleTile extends ConsumerWidget {
  const NewsArticleTile({required this.article, required this.locale, super.key});

  final NewsArticleModel article;
  final Locale locale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final byline = article.byline;
    final published = article.published == null
        ? null
        : DateFormat.yMMMd(locale.toLanguageTag()).format(article.published!);
    final hasMeta = (byline != null && byline.isNotEmpty) || published != null;
    return Semantics(
      button: true,
      label: context.l10n.newsArticleSemantics(article.headline),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          ref.read(analyticsGatewayProvider).log(NewsOpened(headline: article.headline));
          Utils.openUrl(rawUrl: article.webUrl, externalApplication: true);
        },
        child: ExcludeSemantics(
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
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final dpr = MediaQuery.devicePixelRatioOf(context);
                        final cacheWidth = (constraints.maxWidth * dpr).round();
                        final cacheHeight = (constraints.maxHeight * dpr).round();
                        return Image.network(
                          TrustedUrl.preferHttps(article.imageUrl!),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          cacheWidth: cacheWidth > 0 ? cacheWidth : null,
                          cacheHeight: cacheHeight > 0 ? cacheHeight : null,
                          errorBuilder: (_, _, _) => const SizedBox.shrink(),
                        );
                      },
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
                              Text(
                                published,
                                style: AppStyles.caption.copyWith(color: context.colors.textGray),
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
