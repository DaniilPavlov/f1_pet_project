import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/widgets/shimmer/screen_shimmer.dart';
import 'package:f1_pet_project/common/widgets/shimmer/shimmer_loading_widget.dart';
import 'package:f1_pet_project/common/widgets/shimmer/shimmer_skeleton.dart';
import 'package:f1_pet_project/core/news/components/news_article_tile.dart';
import 'package:f1_pet_project/core/news/controllers/news_screen_controller/news_screen_controller.dart';
import 'package:f1_pet_project/core/news/models/news_article_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Лента ESPN-новостей на Home (клиентская пагинация через [NewsScreenController]).
///
/// Без вложенного [ListView]: секция живёт внутри [CustomScrollView] Home.
class HomeHeadlinesSection extends ConsumerWidget {
  const HomeHeadlinesSection({this.titleKey, super.key});

  /// Ключ заголовка «Новости» — для FAB «наверх к новостям».
  final Key? titleKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final news = ref.watch(newsScreenControllerProvider);
    final articles = news.articles.value;
    final locale = Localizations.localeOf(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        StaticData.defaultHorizontalPadding,
        8,
        StaticData.defaultHorizontalPadding,
        StaticData.defaultVerticalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.homeHeadlinesTitle,
            key: titleKey,
            style: AppStyles.h3,
          ),
          const SizedBox(height: 12),
          ..._body(
            context: context,
            articles: articles,
            visible: news.visibleArticles,
            isLoading: articles == null && news.articles.isLoading,
            isError: news.articles.isError && articles == null,
            locale: locale,
          ),
        ],
      ),
    );
  }

  List<Widget> _body({
    required BuildContext context,
    required List<NewsArticleModel>? articles,
    required List<NewsArticleModel> visible,
    required bool isLoading,
    required bool isError,
    required Locale locale,
  }) {
    if (isLoading) {
      return const [_HeadlinesShimmer()];
    }
    if (isError || articles == null || articles.isEmpty) {
      return [
        Text(
          context.l10n.newsEmpty,
          style: AppStyles.caption.copyWith(color: context.colors.textGray),
        ),
      ];
    }
    return [
      for (var i = 0; i < visible.length; i++) ...[
        if (i > 0) const SizedBox(height: 12),
        NewsArticleTile(article: visible[i], locale: locale),
      ],
    ];
  }
}

/// Компактный скелет для Home (Column, не ListView).
class _HeadlinesShimmer extends StatelessWidget {
  const _HeadlinesShimmer();

  @override
  Widget build(BuildContext context) {
    return ScreenShimmer(
      child: ShimmerLoading(
        child: Column(
          children: [
            for (var i = 0; i < 3; i++) ...[
              if (i > 0) const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: context.colors.strokeGray),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                clipBehavior: Clip.hardEdge,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: ColoredBox(color: context.colors.shimmerBase),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerTextLine(height: 16, width: 220, bottomGap: 14),
                          ShimmerTextLine(),
                          ShimmerTextLine(width: 180, bottomGap: 0),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
