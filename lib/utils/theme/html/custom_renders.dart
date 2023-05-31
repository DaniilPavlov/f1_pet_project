// ignore_for_file: prefer_function_declarations_over_variables, avoid_annotating_with_dynamic

import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:f1_pet_project/utils/constants/static_data.dart';
import 'package:f1_pet_project/utils/theme/app_theme.dart';
import 'package:f1_pet_project/utils/theme/html/app_html.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

Map<bool Function(RenderContext), CustomRender> customRenders = {
  (ctx) {
    return ctx.tree.element?.localName == 'blockquote';
  }: CustomRender.widget(
    widget: (context, childrens) {
      return AppHtml(
        data:
            '<span class="bc-quotes">«</span> ${context.tree.element?.innerHtml} <span class="bc-quotes">»</span>',
      );
    },
  ),
  (ctx) {
    return ctx.tree.element?.localName == 'slider';
  }: CustomRender.widget(
    widget: (context, childrens) {
      // final List<String> images = [];

      final dynamicList =
          json.decode(context.tree.element?.text ?? '') as List<dynamic>;

      final imagesList = dynamicList.map((dynamic imageSrc) {
        return imageSrc as String;
      }).toList();

      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: StaticData.defaultHorizontalPadding,
        ),
        child: Row(
          children: imagesList.map((src) {
            return Container(
              margin: const EdgeInsets.only(
                right: StaticData.defaultHorizontalPadding,
              ),
              width: MediaQuery.of(context.buildContext).size.width -
                  StaticData.defaultHorizontalPadding * 4,
              child: ExtendedImage.network(
                src,
                loadStateChanged: loadStateChangedFunction,
              ),
            );
          }).toList(),
        ),
      );
    },
  ),
  // (ctx) {
  //   return ctx.tree.element?.localName == 'img';
  // }: CustomRender.widget(
  //   widget: (context, childrenns) {
  //     if ((context.tree.element?.attributes.isNotEmpty ?? false) &&
  //         (context.tree.element?.attributes.containsKey('src') ?? false)) {
  //       var src = '';

  //       context.tree.element!.attributes.forEach((key, value) {
  //         if (key == 'src') {
  //           src = value;
  //         }
  //       });

  //       return Container(
  //         margin: const EdgeInsets.only(top: 30),
  //         child: ExtendedImage.network('${StaticData.a}$src'),
  //       );
  //     }

  //     return const SizedBox();
  //   },
  // ),
  ...CustomRenders.ulDefault(),
  (ctx) {
    return ctx.tree.element?.localName == 'ol';
  }: CustomRender.widget(
    widget: (ctx, childrens) {
      final listElements = <Widget>[];

      for (var i = 0; i < (ctx.tree.element?.children.length ?? 0); i++) {
        final element = ctx.tree.element!.children[i];
        listElements.add(
          SizedBox(
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 4,
                  height: 4,
                  // margin: const EdgeInsets.only(top: 1),
                  color: AppTheme.red,
                ),
                const SizedBox(width: 16),
                Flexible(
                  child: AppHtml(data: element.outerHtml),
                ),
              ],
            ),
          ),
        );
      }

      return Wrap(
        runSpacing: 6,
        children: listElements,
      );
    },
  ),
  (ctx) {
    if (ctx.tree.element?.localName == 'table' &&
        !ctx.tree.element!.classes.contains('decorated-table')) {
      return true;
    }

    return false;
  }: CustomRender.widget(
    widget: (ctx, childrens) {
      return SizedBox(
        width: MediaQuery.of(ctx.buildContext).size.width -
            StaticData.defaultHorizontalPadding * 2,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          clipBehavior: Clip.none,
          scrollDirection: Axis.horizontal,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: Colors.black,
              // border: Border(
              //   top: BorderSide(color: Colors.white),
              //   right: BorderSide(color: Colors.white),
              // ),
            ),
            child: AppHtml(
              shrinkWrap: true,
              data:
                  '<table class="decorated-table">${ctx.tree.element?.innerHtml}</table>',
            ),
          ),
        ),
      );
    },
  ),
  // (ctx) {
  //   if (ctx.tree.element?.localName == 'table' &&
  //       ctx.tree.element!.classes.contains('decorated-table')) {
  //     return true;
  //   }

  //   return false;
  // }: tableRender(),
};

class CustomRenders {
  static final bool Function(RenderContext) ulDefaultPredicate =
      (ctx) => ctx.tree.element?.localName == 'ul';

  static Map<bool Function(RenderContext), CustomRender> ulDefault({
    Color? ulColor,
    double? circleSize,
    double? horizontalSpace,
    EdgeInsets Function(EdgeInsets oldMargin)? marginBuilder,
  }) {
    final size = circleSize ?? 4;
    final margin = EdgeInsets.only(
      top: size > 20 ? 0 : (20 - size) / 2,
    );

    return {
      ulDefaultPredicate: CustomRender.widget(
        widget: (ctx, childrends) {
          return Wrap(
            runSpacing: 6,
            children: ctx.tree.element?.children.map((child) {
                  return SizedBox(
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: size,
                          height: size,
                          margin: marginBuilder == null
                              ? margin
                              : marginBuilder(margin),
                          color: ulColor ?? AppTheme.red,
                        ),
                        SizedBox(width: horizontalSpace ?? 16),
                        Flexible(
                          child: AppHtml(data: child.outerHtml),
                        ),
                      ],
                    ),
                  );
                }).toList() ??
                [],
          );
        },
      ),
    };
  }
}
