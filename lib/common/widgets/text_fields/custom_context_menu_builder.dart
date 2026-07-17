import 'package:flutter/material.dart';

/// Контекстное меню текстового поля без Live Text.
/// Обязательно использовать во всех текстовых полях.
class CustomContextMenuBuilder extends StatelessWidget {
  const CustomContextMenuBuilder(this.editableTextState, {super.key});
  final EditableTextState editableTextState;

  @override
  Widget build(BuildContext context) {
    return AdaptiveTextSelectionToolbar.editable(
      clipboardStatus: editableTextState.clipboardStatus.value,
      anchors: editableTextState.contextMenuAnchors,
      onCopy: editableTextState.copyEnabled
          ? () => editableTextState.copySelection(SelectionChangedCause.toolbar)
          : null,
      onCut: editableTextState.cutEnabled ? () => editableTextState.cutSelection(SelectionChangedCause.toolbar) : null,
      onPaste: editableTextState.pasteEnabled ? () => editableTextState.pasteText(SelectionChangedCause.toolbar) : null,
      onSelectAll: editableTextState.selectAllEnabled
          ? () => editableTextState.selectAll(SelectionChangedCause.toolbar)
          : null,
      onLookUp: editableTextState.lookUpEnabled
          ? () => editableTextState.lookUpSelection(SelectionChangedCause.toolbar)
          : null,
      onSearchWeb: editableTextState.searchWebEnabled
          ? () => editableTextState.searchWebForSelection(SelectionChangedCause.toolbar)
          : null,
      onShare: editableTextState.shareEnabled
          ? () => editableTextState.shareSelection(SelectionChangedCause.toolbar)
          : null,
      onLiveTextInput: null,
    );
  }
}
