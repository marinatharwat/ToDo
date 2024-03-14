import 'package:flutter/material.dart';

class Dialogs {
  static showLoadingDialog(BuildContext context, String message,
      {bool isCanceled = true}) {
    showDialog(
        barrierDismissible: isCanceled,
        context: context,
        builder: (context) => AlertDialog(
              content: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    width: 25,
                  ),
                  Text(
                    message,

                  )
                ],
              ),
            ));
  }

  static closeMessageDialog(BuildContext context) {
    Navigator.pop(context);
  }

  static showMessageDialog(
    BuildContext context,
    String message, {
    bool isClosed = true,
    String? positiveActionText,
    VoidCallback? positiveAction,
    String? negativeActionText,
    VoidCallback? negativeAction,
    Widget? icon,
  }) {
    List<Widget> actions = [];
    if (positiveActionText != null) {
      actions.add(TextButton(
          onPressed: () {
            Navigator.pop(context);
            positiveAction?.call();
          },
          child: Text(
            positiveActionText,
          )));
    }
    if (negativeActionText != null) {
      actions.add(TextButton(
          onPressed: () {
            negativeAction?.call();
          },
          child: Text(
            negativeActionText,

          )));
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: actions,
        content: Row(
          children: [
            icon != null
                ? Row(
                    children: [
                      icon,
                      SizedBox(
                        width: 10,
                      )
                    ],
                  )
                : const SizedBox(
                    width: 0,
                  ),
            Expanded(
              child: Text(
                message,
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: isClosed,
    );
  }
}
