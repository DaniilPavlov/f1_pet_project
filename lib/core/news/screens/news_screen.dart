import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/anti_glow_behavior.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/common/widgets/error_body.dart';
import 'package:f1_pet_project/common/widgets/shimmer/news_list_shimmer.dart';
import 'package:f1_pet_project/core/news/components/news_article_tile.dart';
import 'package:f1_pet_project/core/news/controllers/news_screen_controller/news_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

/// Экран ленты новостей F1 (ESPN).
@RoutePage()
class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<NewsScreenController>(
      create: (_) => NewsScreenController()..loadArticles(),
      child: Scaffold(
        appBar: CustomAppBar(title: context.l10n.newsTitle),
        body: SafeArea(
          child: Observer(
            builder: (context) {
              final controller = context.read<NewsScreenController>();
              final articles = controller.articles.value;
              if (articles == null && controller.articles.isLoading) {
                return const NewsListShimmer();
              }
              if (controller.articles.isError && articles == null) {
                return ErrorBody(
                  onTap: controller.loadArticles,
                  title: controller.screenError!.title,
                  subtitle: controller.screenError!.subtitle,
                );
              }

              final list = articles ?? [];
              if (list.isEmpty) {
                return RefreshIndicator(
                  color: AppTheme.red,
                  onRefresh: controller.refreshAll,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.5,
                        child: Center(child: Text(context.l10n.newsEmpty)),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                color: AppTheme.red,
                onRefresh: controller.refreshAll,
                child: ScrollConfiguration(
                  behavior: AntiGlowBehavior(),
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      StaticData.defaultHorizontalPadding,
                      12,
                      StaticData.defaultHorizontalPadding,
                      StaticData.defaultVerticalPadding,
                    ),
                    itemCount: list.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) => NewsArticleTile(
                      article: list[index],
                      locale: Localizations.localeOf(context),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
