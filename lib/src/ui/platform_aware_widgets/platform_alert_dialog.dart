import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/src/ui/platform_aware_widgets/platform_widget.dart';

class PlatformAlertDialog extends PlatformWidget<AlertDialog, CupertinoAlertDialog> {
  PlatformAlertDialog({
    required this.title,
    this.cancelText,
    required this.confirmText,
    required this.content,
    this.confirmColor,
  });

  final String title;
  final String content;
  final String? cancelText;
  final String confirmText;
  final Color? confirmColor;

  @override
  AlertDialog buildMaterialWidget(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(title),
      content: Text(content),
      actions: _actions(context, cancelText?.toUpperCase(), confirmText.toUpperCase(), confirmColor),
    );
  }

  @override
  CupertinoAlertDialog buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _actions(context, cancelText, confirmText, confirmColor),
    );
  }

  List<Widget> _actions(BuildContext context, String? cancelText, String confirmText, Color? confirmColor) {
    var actions = <Widget>[];
    if (cancelText != null) {
      actions.add(PlatformAlertDialogAction(child: Text(cancelText), onPressed: () => _dismiss(context, false)));
    }
    actions.add(PlatformAlertDialogAction(
      child: Text(
        confirmText,
        style: TextStyle(color: confirmColor),
      ),
      onPressed: () => _dismiss(context, true),
    ));
    return actions;
  }

  Future<bool> show(BuildContext context) async {
    final result = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: !Platform.isIOS,
      barrierLabel: "",
      pageBuilder: (context, animation, animation2) => this,
      transitionDuration: Duration(milliseconds: 300),
      transitionBuilder: (context, animation1, animation2, child) => ScaleTransition(
        alignment: Alignment.topRight,
        scale: CurvedAnimation(parent: animation1, curve: Curves.easeInOutQuart),
        child: this,
      ),
    );
    return Future.value(result ?? false);
  }

  void _dismiss(BuildContext context, bool value) {
    Navigator.of(context, rootNavigator: true).pop(value);
  }
}

class PlatformAlertDialogAction extends PlatformWidget<TextButton, CupertinoDialogAction> {
  PlatformAlertDialogAction({required this.child, required this.onPressed});

  final Widget child;
  final VoidCallback onPressed;

  @override
  TextButton buildMaterialWidget(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: child,
    );
  }

  @override
  CupertinoDialogAction buildCupertinoWidget(BuildContext context) {
    return CupertinoDialogAction(
      child: child,
      onPressed: onPressed,
    );
  }
}
