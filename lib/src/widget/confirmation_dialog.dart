import 'package:flutter/material.dart';

Future<bool> showConfirmationDialog(
  BuildContext context, {
  required String heading,
  required String message,
  bool isConfirmationDialog = false,
}) async {
  return (await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(heading),
          content: Text(message),
          actions: <Widget>[
            if (isConfirmationDialog)
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(isConfirmationDialog ? 'Yes' : 'Okay'),
            ),
          ],
        ),
      )) ??
      false;
}
