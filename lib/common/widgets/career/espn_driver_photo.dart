import 'package:f1_pet_project/common/widgets/career/network_hero_photo.dart';
import 'package:flutter/material.dart';

/// Широкое фото пилота; при отсутствии URL — плейсхолдер человека.
class EspnDriverPhoto extends StatelessWidget {
  const EspnDriverPhoto({
    required this.photoUrl,
    this.isLoading = false,
    super.key,
  });

  final String? photoUrl;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return NetworkHeroPhoto(photoUrl: photoUrl, isLoading: isLoading);
  }
}
