import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/utils/trusted_url.dart';
import 'package:flutter/material.dart';

/// Широкое сетевое фото с рамкой; при отсутствии URL — иконка-плейсхолдер.
class NetworkHeroPhoto extends StatelessWidget {
  const NetworkHeroPhoto({
    required this.photoUrl,
    this.isLoading = false,
    this.placeholderIcon = Icons.person,
    this.fit = BoxFit.cover,
    this.borderColor = AppTheme.red,
    super.key,
  });

  final String? photoUrl;
  final bool isLoading;
  final IconData placeholderIcon;
  final BoxFit fit;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 2,
      child: Container(
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: context.colors.grayBG,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        foregroundDecoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: isLoading
            ? Center(
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(strokeWidth: 2, color: borderColor),
                ),
              )
            : photoUrl == null
            ? _Placeholder(icon: placeholderIcon)
            : LayoutBuilder(
                builder: (context, constraints) {
                  final dpr = MediaQuery.devicePixelRatioOf(context);
                  final cacheWidth = (constraints.maxWidth * dpr).round();
                  final cacheHeight = (constraints.maxHeight * dpr).round();
                  return Image.network(
                    TrustedUrl.preferHttps(photoUrl!),
                    fit: fit,
                    width: double.infinity,
                    height: double.infinity,
                    cacheWidth: cacheWidth > 0 ? cacheWidth : null,
                    cacheHeight: cacheHeight > 0 ? cacheHeight : null,
                    errorBuilder: (_, _, _) => _Placeholder(icon: placeholderIcon),
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) {
                        return child;
                      }
                      return Center(
                        child: SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(strokeWidth: 2, color: borderColor),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(child: Icon(icon, size: 72, color: context.colors.textGray));
  }
}
