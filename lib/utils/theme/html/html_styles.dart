// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

Map<String, Style> htmlStyles = {
  'body': Style(
    margin: EdgeInsets.zero,
    padding: EdgeInsets.zero,
    color: Colors.black,
    fontWeight: FontWeight.w500,
    lineHeight: const LineHeight(20 / 16),
    fontSize: const FontSize(16),
    fontFamily: 'Inter-Regular',
  ),
  'p:first-child': Style(
    // ignore: avoid_redundant_argument_values, use_named_constants
    margin: const EdgeInsets.only(top: 0),
  ),
  // 'body > *:not(:first-child)': Style(
  //   margin: const EdgeInsets.only(top: 30),
  // ),
  // '.bc-quotes': Style(
  //   color: AppTheme.red,
  // ),
  'iframe': Style(
    height: 200,
  ),
  // 'a': Style(
  //   color: AppTheme.red,
  // ),
  'h1': headingStyles.copyWith(
    fontSize: const FontSize(34),
    lineHeight: const LineHeight(1),
  ),
  'h2': headingStyles.copyWith(
    fontSize: const FontSize(30),
    lineHeight: const LineHeight(1),
  ),
  'h3': headingStyles.copyWith(
    fontSize: const FontSize(20),
    lineHeight: const LineHeight(22 / 20),
  ),
};

final headingStyles = Style(
  fontFamily: 'HelveticaNeueCyr-Bold',
  // fontWeight: FontWeight.bold,
  textTransform: TextTransform.uppercase,
  margin: const EdgeInsets.only(
    bottom: 24,
    top: 24,
  ),
);

// final TD_TH_STYLES = Style(
//   margin: const EdgeInsets.symmetric(vertical: 12),
//   padding: const EdgeInsets.symmetric(
//     vertical: 23,
//     horizontal: 16,
//   ),
//   border: const Border(
//     bottom: BorderSide(
//       color: Colors.white,
//     ),
//     left: BorderSide(
//       color: Colors.white,
//     ),
//   ),
//   color: Colors.white,
// );
