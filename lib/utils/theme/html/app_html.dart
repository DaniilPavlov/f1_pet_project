import 'package:f1_pet_project/utils/theme/html/custom_renders.dart';
import 'package:f1_pet_project/utils/theme/html/html_styles.dart';
import 'package:f1_pet_project/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class AppHtml extends StatelessWidget {
  const AppHtml({
    required this.data,
    this.otherHtmlStyles,
    this.otherCustomRenders,
    this.shrinkWrap = false,
    this.openLinkWithExternalApplication = false,
    super.key,
  });
  final String data;
  final Map<String, Style>? otherHtmlStyles;
  final Map<bool Function(RenderContext), CustomRender>? otherCustomRenders;
  final bool shrinkWrap;
  final bool openLinkWithExternalApplication;

  String get dataLineBreaksCut {
    return data.replaceAll('\r\n\t', '').replaceAll('\r\n', '&thinsp;');
  }

  @override
  Widget build(BuildContext context) {
    final localHtmlStyles = {...htmlStyles};
    final newStyles = localHtmlStyles
      ..addAll(otherHtmlStyles ?? <String, Style>{});

    final newCustomRenders = customRenders
      ..addAll(
        otherCustomRenders ?? <bool Function(RenderContext), CustomRender>{},
      );

    return Html(
      data: dataLineBreaksCut,
      style: newStyles,
      shrinkWrap: shrinkWrap,
      customRenders: newCustomRenders,
      onLinkTap: (url, context, attributes, element) async {
        await Utils.openUrl(
          rawUrl: url ?? '',
          externalApplication: openLinkWithExternalApplication,
        );
      },
      tagsList: Html.tags..addAll(['slider']),
    );
  }
}
