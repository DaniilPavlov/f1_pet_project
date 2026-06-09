import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

Map<String, Style> htmlStyles = {
  'body': Style(
    margin: Margins.zero,
    padding: HtmlPaddings.zero,
    color: Colors.black,
    fontWeight: FontWeight.w500,
    lineHeight: const LineHeight(20 / 16),
    fontSize: FontSize(16),
    fontFamily: 'Inter-Regular',
  ),
  'p:first-child': Style(margin: Margins.zero),
  'iframe': Style(height: Height(200)),
  'h1': headingStyles.copyWith(fontSize: FontSize(34), lineHeight: const LineHeight(1)),
  'h2': headingStyles.copyWith(fontSize: FontSize(30), lineHeight: const LineHeight(1)),
  'h3': headingStyles.copyWith(fontSize: FontSize(20), lineHeight: const LineHeight(22 / 20)),
};

final headingStyles = Style(
  fontFamily: 'HelveticaNeueCyr-Bold',
  textTransform: TextTransform.uppercase,
  margin: Margins.only(bottom: 24, top: 24),
);
