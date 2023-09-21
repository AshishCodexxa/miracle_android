import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:miracle/src/data/model/quote.dart';
import 'package:miracle/src/data/network/dio_client.dart';
import 'package:miracle/src/widget/gradient_button.dart';

class AddQuoteDialog extends HookWidget {
  const AddQuoteDialog({
    Key? key,
    this.quote,
  }) : super(key: key);

  final Quote? quote;

  @override
  Widget build(BuildContext context) {
    final quoteController = useTextEditingController(text: quote?.quote);
    final authorController = useTextEditingController(text: quote?.author);
    final errorMessage = useState<String?>(null);

    save() {
      if (quoteController.text.isEmpty) {
        errorMessage.value = 'Field required';
        return;
      }
      errorMessage.value = null;
      final data = {
        'quote': quoteController.text,
        'author': authorController.text,
      };
      if (quote == null) {
        DioClient().addOwnQuotes(data).then((value) {
          Navigator.of(context).pop(true);
        });
      } else {
        DioClient().updateOwnQuotes(data).then((value) {
          Navigator.of(context).pop(true);
        });
      }
    }

    return SingleChildScrollView(
      child: SizedBox(
        height: 360,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.edit_note_rounded,
                    size: 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'New Quote',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Write and share your own quotes. These will only be visible to you.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: quoteController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: authorController,
                    decoration: const InputDecoration(
                      hintText: 'Author (optional)',
                      border: OutlineInputBorder(),
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
                  Navigator.of(context).pop(true);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
