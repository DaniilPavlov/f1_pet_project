import 'package:flutter/material.dart';

extension TextEditingControllerX on TextEditingController {
  bool get isValidYear => text.length == 4;
}
