import 'dart:async';

import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/utils/trusted_url.dart';
import 'package:f1_pet_project/common/widgets/custom_loading_indicator.dart';
import 'package:flutter/material.dart';

/// Широкое сетевое фото с рамкой; при отсутствии URL — иконка-плейсхолдер.
///
/// Загрузка картинки ограничена по времени — иначе при «висящем» CDN
/// крутится лоадер бесконечно.
class NetworkHeroPhoto extends StatefulWidget {
  const NetworkHeroPhoto({
    required this.photoUrl,
    this.isLoading = false,
    this.placeholderIcon = Icons.person,
    this.fit = BoxFit.cover,
    this.borderColor = AppTheme.red,
    this.imageLoadTimeout = const Duration(seconds: 12),
    super.key,
  });

  final String? photoUrl;
  final bool isLoading;
  final IconData placeholderIcon;
  final BoxFit fit;
  final Color borderColor;
  final Duration imageLoadTimeout;

  @override
  State<NetworkHeroPhoto> createState() => _NetworkHeroPhotoState();
}

class _NetworkHeroPhotoState extends State<NetworkHeroPhoto> {
  Timer? _timeout;
  bool _timedOut = false;
  String? _watchedUrl;

  @override
  void initState() {
    super.initState();
    _syncTimeout();
  }

  @override
  void didUpdateWidget(covariant NetworkHeroPhoto oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.photoUrl != widget.photoUrl ||
        oldWidget.isLoading != widget.isLoading ||
        oldWidget.imageLoadTimeout != widget.imageLoadTimeout) {
      _syncTimeout();
    }
  }

  @override
  void dispose() {
    _timeout?.cancel();
    super.dispose();
  }

  void _syncTimeout() {
    _timeout?.cancel();
    final url = widget.photoUrl;
    final waiting = widget.isLoading || (url != null && url.isNotEmpty);
    if (!waiting) {
      _watchedUrl = null;
      _timedOut = false;
      return;
    }
    if (_watchedUrl != url || widget.isLoading) {
      _watchedUrl = url;
      _timedOut = false;
    }
    _timeout = Timer(widget.imageLoadTimeout, () {
      if (!mounted || _timedOut) {
        return;
      }
      setState(() => _timedOut = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final showPlaceholder = _timedOut || (!widget.isLoading && widget.photoUrl == null);

    return AspectRatio(
      aspectRatio: 3 / 2,
      child: Container(
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: context.colors.grayBG,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        foregroundDecoration: BoxDecoration(
          border: Border.all(color: widget.borderColor),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: widget.isLoading && !_timedOut
            ? const Center(child: CustomLoadingIndicator(size: 48))
            : showPlaceholder
            ? _Placeholder(icon: widget.placeholderIcon)
            : LayoutBuilder(
                builder: (context, constraints) {
                  final dpr = MediaQuery.devicePixelRatioOf(context);
                  final cacheWidth = (constraints.maxWidth * dpr).round();
                  final cacheHeight = (constraints.maxHeight * dpr).round();
                  return Image.network(
                    TrustedUrl.preferHttps(widget.photoUrl!),
                    fit: widget.fit,
                    width: double.infinity,
                    height: double.infinity,
                    cacheWidth: cacheWidth > 0 ? cacheWidth : null,
                    cacheHeight: cacheHeight > 0 ? cacheHeight : null,
                    errorBuilder: (_, _, _) => _Placeholder(icon: widget.placeholderIcon),
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) {
                        return child;
                      }
                      if (_timedOut) {
                        return _Placeholder(icon: widget.placeholderIcon);
                      }
                      return const Center(child: CustomLoadingIndicator(size: 48));
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
