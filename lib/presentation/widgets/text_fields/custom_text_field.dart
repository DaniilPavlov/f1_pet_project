// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:f1_pet_project/presentation/widgets/text_fields/custom_context_menu_builder.dart';
import 'package:f1_pet_project/utils/theme/app_styles.dart';
import 'package:f1_pet_project/utils/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.focusNode,
    this.hintText,
    this.errorText,
    this.label,
    this.maxLines = 1,
    this.disabled = false,
    this.inputFormatters,
    this.onSubmit,
    this.onChanged,
    this.textCapitalization = TextCapitalization.none,
    this.rightWidget,
    this.borderColor,
    this.cursorColor,
    this.textColor,

    this.readOnly = false,
    TextAlign? textAlign,
    EdgeInsets? scrollPadding,
    this.suffix,
    this.borderRadius,
    super.key,
  }) : scrollPadding = scrollPadding ?? const EdgeInsets.all(20),
       textAlign = textAlign ?? TextAlign.start;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final String? hintText;
  final String? errorText;
  final String? label;
  final int? maxLines;
  final bool disabled;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmit;
  final TextCapitalization textCapitalization;
  final Widget? rightWidget;
  final Color? textColor;
  final Color? borderColor;
  final Color? cursorColor;
  final TextAlign textAlign;
  final EdgeInsets scrollPadding;
  final bool readOnly;
  final Widget? suffix;
  final BorderRadius? borderRadius;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late final FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = widget.focusNode == null ? FocusNode() : widget.focusNode!;
    focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null && widget.label!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(widget.label!, style: AppStyles.caption.copyWith(color: AppTheme.black)),
          ),
        Container(
          padding: Platform.isIOS ? const EdgeInsets.symmetric(horizontal: 16) : EdgeInsets.zero,
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.disabled
                  ? AppTheme.strokeGray
                  : widget.errorText != null
                  ? AppTheme.red
                  : widget.readOnly
                  ? widget.borderColor ?? AppTheme.strokeGray
                  : focusNode.hasFocus
                  ? AppTheme.black
                  : widget.borderColor ?? AppTheme.strokeGray,
            ),
            color: Colors.transparent,
            borderRadius:
                widget.borderRadius ??
                (widget.maxLines == null || widget.maxLines! > 1
                    ? const BorderRadius.all(Radius.circular(20))
                    : const BorderRadius.all(Radius.circular(100))),
          ),
          child: Row(
            children: [
              if (Platform.isIOS)
                Expanded(
                  child: CupertinoTextField.borderless(
                    inputFormatters: widget.inputFormatters,
                    cursorRadius: Radius.zero,
                    cursorWidth: 1,
                    suffix: widget.suffix,
                    readOnly: widget.readOnly,
                    scrollPadding: widget.scrollPadding,
                    // autofocus: widget.autofocus,
                    controller: widget.controller,
                    maxLines: widget.maxLines,
                    keyboardType: widget.keyboardType,
                    textInputAction: widget.textInputAction,
                    onChanged: widget.onChanged,
                    style: AppStyles.caption.copyWith(
                      color: widget.disabled
                          ? AppTheme.textGray
                          : widget.errorText != null
                          ? AppTheme.red
                          : widget.textColor ?? AppTheme.black,
                    ),
                    cursorColor: widget.cursorColor ?? AppTheme.black,
                    textAlign: widget.textAlign,
                    onSubmitted: widget.onSubmit,
                    focusNode: focusNode,
                    contextMenuBuilder: (context, editableTextState) {
                      return CustomContextMenuBuilder(editableTextState);
                    },
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    placeholder: widget.disabled ? null : widget.hintText,
                    enabled: !widget.disabled,
                    placeholderStyle: AppStyles.caption.copyWith(color: AppTheme.strokeGray),
                    textCapitalization: widget.textCapitalization,
                  ),
                )
              else
                Expanded(
                  child: TextSelectionTheme(
                    data: const TextSelectionThemeData(selectionColor: AppTheme.textGray),
                    child: TextFormField(
                      inputFormatters: widget.inputFormatters,
                      cursorRadius: Radius.zero,
                      cursorWidth: 1,
                      scrollPadding: widget.scrollPadding,
                      readOnly: widget.readOnly,
                      cursorColor: widget.cursorColor ?? AppTheme.black,
                      controller: widget.controller,
                      keyboardType: widget.keyboardType,
                      textInputAction: widget.textInputAction,
                      onChanged: widget.onChanged,
                      contextMenuBuilder: (context, editableTextState) {
                        return CustomContextMenuBuilder(editableTextState);
                      },
                      style: AppStyles.caption.copyWith(
                        decorationThickness: 0,
                        color: widget.disabled
                            ? AppTheme.strokeGray
                            : widget.errorText != null
                            ? AppTheme.red
                            : widget.textColor ?? AppTheme.black,
                      ),
                      textAlign: widget.textAlign,
                      onFieldSubmitted: widget.onSubmit,
                      focusNode: focusNode,
                      maxLines: widget.maxLines,
                      enabled: !widget.disabled,
                      decoration: InputDecoration(
                        isDense: true,
                        suffix: widget.suffix,
                        hintText: widget.disabled ? null : widget.hintText,
                        hintStyle: AppStyles.caption.copyWith(color: AppTheme.strokeGray),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      textCapitalization: widget.textCapitalization,
                    ),
                  ),
                ),
              if (widget.rightWidget != null) widget.rightWidget!,
            ],
          ),
        ),
        if (widget.errorText != null && widget.errorText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 2, 16, 0),
            child: Text(widget.errorText!, style: AppStyles.caption.copyWith(color: AppTheme.red)),
          ),
      ],
    );
  }
}
