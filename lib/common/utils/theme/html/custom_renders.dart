import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/utils/theme/html/app_html.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

List<HtmlExtension> htmlExtensions = [
  TagExtension(
    tagsToExtend: {'blockquote'},
    builder: (context) {
      return AppHtml(
        data: '<span class="bc-quotes">«</span> ${context.innerHtml} <span class="bc-quotes">»</span>',
      );
    },
  ),
  TagExtension(
    tagsToExtend: {'slider'},
    builder: (context) {
      final dynamicList = json.decode(context.element?.text ?? '') as List<dynamic>;

      final imagesList = dynamicList.map((dynamic imageSrc) {
        return imageSrc as String;
      }).toList();

      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: StaticData.defaultHorizontalPadding),
        child: Row(
          children: imagesList.map((src) {
            return Container(
              margin: const EdgeInsets.only(right: StaticData.defaultHorizontalPadding),
              width: MediaQuery.sizeOf(context.buildContext!).width - StaticData.defaultHorizontalPadding * 4,
              child: ExtendedImage.network(src, loadStateChanged: loadStateChangedFunction),
            );
          }).toList(),
        ),
      );
    },
  ),
  CustomRenders.ulDefault(),
  TagExtension(
    tagsToExtend: {'ol'},
    builder: (ctx) {
      final listElements = <Widget>[];

      for (final element in ctx.elementChildren) {
        listElements.add(
          SizedBox(
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 4,
                  height: 4,
                  color: AppTheme.red,
                ),
                const SizedBox(width: 16),
                Flexible(child: AppHtml(data: element.outerHtml)),
              ],
            ),
          ),
        );
      }

      return Wrap(runSpacing: 6, children: listElements);
    },
  ),
  MatcherExtension(
    matcher: (ctx) => ctx.elementName == 'table' && !ctx.classes.contains('decorated-table'),
    builder: (ctx) {
      return SizedBox(
        width: MediaQuery.sizeOf(ctx.buildContext!).width - StaticData.defaultHorizontalPadding * 2,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          clipBehavior: Clip.none,
          scrollDirection: Axis.horizontal,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: AppHtml(
              shrinkWrap: true,
              data: '<table class="decorated-table">${ctx.innerHtml}</table>',
            ),
          ),
        ),
      );
    },
  ),
];

class CustomRenders {
  static HtmlExtension ulDefault({
    Color? ulColor,
    double? circleSize,
    double? horizontalSpace,
    EdgeInsets Function(EdgeInsets oldMargin)? marginBuilder,
  }) {
    final size = circleSize ?? 4;
    final margin = EdgeInsets.only(top: size > 20 ? 0 : (20 - size) / 2);

    return TagExtension(
      tagsToExtend: {'ul'},
      builder: (ctx) {
        return Wrap(
          runSpacing: 6,
          children: ctx.elementChildren.map((child) {
            return SizedBox(
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: size,
                    height: size,
                    margin: marginBuilder == null ? margin : marginBuilder(margin),
                    color: ulColor ?? AppTheme.red,
                  ),
                  SizedBox(width: horizontalSpace ?? 16),
                  Flexible(child: AppHtml(data: child.outerHtml)),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
