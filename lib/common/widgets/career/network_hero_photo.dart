import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Широкое сетевое фото с рамкой; при отсутствии URL — иконка-плейсхолдер.
class NetworkHeroPhoto extends StatelessWidget {
  const NetworkHeroPhoto({
    required this.photoUrl,
    this.isLoading = false,
    this.placeholderIcon = Icons.person,
    this.fit = BoxFit.cover,
    super.key,
  });

  final String? photoUrl;
  final bool isLoading;
  final IconData placeholderIcon;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 2,
      child: Container(
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          color: AppTheme.grayBG,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        foregroundDecoration: BoxDecoration(
          border: Border.all(color: AppTheme.red),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.red),
                ),
              )
            : photoUrl == null
            ? _Placeholder(icon: placeholderIcon)
            : Image.network(
                photoUrl!,
                fit: fit,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (_, _, _) => _Placeholder(icon: placeholderIcon),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) {
                    return child;
                  }
                  return const Center(
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.red),
                    ),
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
    return Center(child: Icon(icon, size: 72, color: AppTheme.textGray));
  }
}
