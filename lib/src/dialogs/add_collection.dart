import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:miracle/src/data/model/collection.dart';
import 'package:miracle/src/data/network/dio_client.dart';
import 'package:miracle/src/widget/gradient_button.dart';

class AddCollectionDialog extends HookWidget {
  const AddCollectionDialog({
    Key? key,
    this.collection,
  }) : super(key: key);

  final Collection? collection;

  @override
  Widget build(BuildContext context) {
    final collectionNameController =
        useTextEditingController(text: collection?.name);
    final errorMessage = useState<String?>(null);

    save() {
      if (collectionNameController.text.isEmpty) {
        errorMessage.value = 'Field required';
        return;
      }
      errorMessage.value = null;
      final data = {
        'name': collectionNameController.text,
      };

      if (collection != null) {
        DioClient().updateCollection(collection!.id, data).then((value) {
          Navigator.of(context).pop(collectionNameController.text);
        });
      } else {
        DioClient().createCollection(data).then((value) {
          collectionNameController.clear();
          Navigator.of(context).pop(true);
        });
      }
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.bookmark_outline_outlined,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'New Collection',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Write a name for your new collection. You can rename it later.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: collectionNameController,
                      decoration: InputDecoration(
                        hintText: 'My New Collection',
                        border: const OutlineInputBorder(),
                        errorText: errorMessage.value,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GradientButton(
                      onPressed: save,
                      label: 'Save',
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
