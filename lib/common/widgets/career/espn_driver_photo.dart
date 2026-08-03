import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/career/network_hero_photo.dart';
import 'package:flutter/material.dart';

/// Широкое фото пилота; при отсутствии URL — плейсхолдер человека.
class EspnDriverPhoto extends StatelessWidget {
  const EspnDriverPhoto({
    required this.photoUrl,
    this.isLoading = false,
    this.borderColor = AppTheme.red,
    super.key,
  });

  final String? photoUrl;
  final bool isLoading;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return NetworkHeroPhoto(
      photoUrl: photoUrl,
      isLoading: isLoading,
      borderColor: borderColor,
    );
  }
}
