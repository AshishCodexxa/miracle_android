import 'package:flutter/material.dart';
import 'package:miracle/src/utils/common.dart';

class ActionCollectionDialog extends StatelessWidget {
  const ActionCollectionDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void onOptionSelected(CollectionAction action) {
      Navigator.of(context).pop(action);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          onTap: () {
            onOptionSelected(CollectionAction.shareCollection);
          },
          title: const Text(
            'Share Collection',
          ),
        ),
        ListTile(
          onTap: () {
            onOptionSelected(CollectionAction.editCollection);
          },
          title: const Text(
            'Edit Name',
          ),
        ),
        ListTile(
          onTap: () {
            onOptionSelected(CollectionAction.removeCollection);
          },
          title: const Text(
            'Remove',
          ),
        ),
      ],
    );
  }
}
