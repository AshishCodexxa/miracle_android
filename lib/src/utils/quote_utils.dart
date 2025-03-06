import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:miracle/src/data/model/collection.dart';
import 'package:miracle/src/data/model/quote.dart';
import 'package:miracle/src/data/network/dio_client.dart';
import 'package:miracle/src/data/network/responses/collection_response.dart';
import 'package:miracle/src/dialogs/add_collection.dart';
import 'package:miracle/src/dialogs/add_quote.dart';
import 'package:miracle/src/widget/no_collection.dart';
import 'package:share_plus/share_plus.dart';

void share(String massage) {
  Share.share(
    '$massage\n'
    'Hey there! Check out this app for inspiring, motivating quotes and sayings: https://play.google.com/store/apps/details?id=com.manifestmiracle.app',
  );
}

Future<bool?> addQuoteDialog(BuildContext context, Quote? quote) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: AddQuoteDialog(quote: quote),
      );
    },
  );
}

void copyText(BuildContext context, String text) {
  Clipboard.setData(
    ClipboardData(text: text),
  ).then((value) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied'),
        duration: Duration(seconds: 3),
      ),
    );
    Navigator.of(context).pop();
  });
}

void addToCollection(
  BuildContext context, {
  required int collectionId,
  required int quoteId,
}) {
  DioClient().addQuoteToCollection(collectionId, quoteId).then((value) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('added to collection'),
        duration: Duration(seconds: 3),
      ),
    );
  });
}

void showCollections(BuildContext context, {required int quoteId}) {
  // Navigator.of(context).pop();
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height * .92,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                top: 32,
              ),
              child: Text(
                'Add to Collection',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Expanded(child: CollectionDialog(quoteId)),
          ],
        ),
      );
    },
  );
}

class CollectionDialog extends HookWidget {
  const CollectionDialog(this.quoteId, {super.key});
  final int quoteId;

  @override
  Widget build(BuildContext context) {
    final collections = useState<List<Collection>>([]);
    final isLoading = useState<bool>(false);

    refresh() async {
      isLoading.value = true;
      final data = await DioClient().getCollections();
      final response = CollectionResponse.fromJson(data!);
      collections.value = response.data;
      isLoading.value = false;
    }

    useEffect(() {
      refresh();
      return;
    }, []);

    return Column(
      children: [
        if (isLoading.value)
          const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        if (!isLoading.value)
          Expanded(
            child: collections.value.isNotEmpty
                ? ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        dense: true,
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            collections.value[index].name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        subtitle: Text(
                          '${collections.value[index].quotesCount} quotes',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        onTap: () {
                          addToCollection(
                            context,
                            collectionId: collections.value[index].id,
                            quoteId: quoteId,
                          );
                        },
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: collections.value.length,
                  )
                : NoCollection(
                    title: 'You haven’t have any \n'
                        'collections yet',
                    subTitle:
                        'Collections group quotes you save together, like\n'
                        '‘Loving myself’ or ‘Reaching my goals’.',
                    btnLabel: 'Create Collections',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const AddCollectionDialog();
                        },
                      ).then((value) {
                        if (value != null) refresh();
                      });
                    },
                  ),
          ),
      ],
    );
  }
}
