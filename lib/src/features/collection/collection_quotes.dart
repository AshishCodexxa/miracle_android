import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:miracle/color.dart';
import 'package:miracle/src/data/model/collection.dart';
import 'package:miracle/src/data/model/quote.dart';
import 'package:miracle/src/data/network/dio_client.dart';
import 'package:miracle/src/data/network/responses/quote_response.dart';
import 'package:miracle/src/dialogs/action_collection.dart';
import 'package:miracle/src/dialogs/action_quote.dart';
import 'package:miracle/src/dialogs/add_collection.dart';
import 'package:miracle/src/features/home/quote_home.dart';
import 'package:miracle/src/utils/common.dart';
import 'package:miracle/src/utils/quote_utils.dart';
import 'package:miracle/src/widget/confirmation_dialog.dart';
import 'package:miracle/src/widget/no_collection.dart';

class CollectionQuotes extends HookWidget {
  const CollectionQuotes({Key? key, required this.collection})
      : super(key: key);
  final Collection collection;
  @override
  Widget build(BuildContext context) {
    final quotes = useState<List<Quote>>([]);
    final collectionName = useState<String>(collection.name);
    final isLoading = useState<bool>(false);

    refresh() async {
      isLoading.value = true;
      final data = await DioClient().getCollectionQuotes(collection.id);
      final response = QuoteResponse.fromJson(data!);
      quotes.value = response.data;
      isLoading.value = false;
    }

    useEffect(() {
      refresh();
      return;
    }, []);

    quoteActionDialog(Quote quote) {
      showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            content: ActionQuoteDialog(
              quote: quote,
              collectionId: collection.id,
              hideCollection: true,
            ),
          );
        },
      ).then((confirmDelete) {
        if (confirmDelete == null) return;
        showConfirmationDialog(
          context,
          heading: 'Are you sure?',
          message: 'Do you want to remove quote?',
          isConfirmationDialog: true,
        ).then((confirm) {
          if (confirm) {
            DioClient()
                .deleteQuoteFromCollection(collection.id, quote.id)
                .then((value) {
              quotes.value =
                  quotes.value.where((q) => q.id != quote.id).toList();
            });
          }
        });
      });
    }

    collectionActionDialog() {
      showDialog<CollectionAction>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            content: const ActionCollectionDialog(),
          );
        },
      ).then((selectedAction) {
        if (selectedAction == null) return;

        switch (selectedAction) {
          case CollectionAction.editCollection:
            showDialog<String>(
              context: context,
              builder: (BuildContext context) {
                return AddCollectionDialog(
                  collection: collection,
                );
              },
            ).then((value) {
              if (value == null) return;
              collectionName.value = value;
            });

            break;
          case CollectionAction.removeCollection:
            showConfirmationDialog(
              context,
              heading: 'Are you sure?',
              message: 'Do you want to remove collection?',
              isConfirmationDialog: true,
            ).then((confirm) {
              if (confirm) {
                DioClient().deleteCollection(collection.id).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Collection removed Successfully'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                  Navigator.of(context).pop();
                });
              }
            });
            break;
          case CollectionAction.shareCollection:
            final msg = StringBuffer('${collectionName.value}:\n\n');
            for (final quote in quotes.value) {
              msg.write('${quote.quote}\n\n');
            }
            share(msg.toString());
            break;
          default:
        }
      });
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back,
          color: Colors.white,),
        ),
        title: Text(collectionName.value,
        style: const TextStyle(
          color: Colors.white
        ),),
        centerTitle: true,
        actions: [
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.more_horiz),
            tooltip: 'Edit Collection',
            onPressed: collectionActionDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          if (isLoading.value)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          if ((!isLoading.value))
            Expanded(
              child: quotes.value.isEmpty
                  ? const NoCollection(
                      title: 'You don’t have any\n'
                          'quotes yet',
                    )
                  : ListView.builder(
                      itemCount: quotes.value.length,
                      itemBuilder: ((BuildContext context, int index) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(top: 10, left: 5, right: 5),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white60,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.black54.withOpacity(0.1),
                                      blurRadius: 7,
                                      offset: const Offset(0.5, 2.0))
                                ],
                                borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              onTap: () {
                                final qs = [...quotes.value];
                                qs.removeAt(index);
                                qs.insert(0, quotes.value[index]);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => QuoteHome(
                                      quotes: qs,
                                    ),
                                  ),
                                );
                              },
                              title: Text(
                                quotes.value[index].quote,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              subtitle: Text(
                                DateFormat('EEE, d MMM y')
                                    .format(quotes.value[index].addedAt!),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.more_vert),
                                onPressed: () {
                                  quoteActionDialog(quotes.value[index]);
                                },
                              ),
                            ),
                          ),
                        );
                      }))

              /*ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: quotes.value.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            final qs = [...quotes.value];
                            qs.removeAt(index);
                            qs.insert(0, quotes.value[index]);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => QuoteHome(
                                  quotes: qs,
                                ),
                              ),
                            );
                          },
                          title: Text(
                            quotes.value[index].quote,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          subtitle: Text(
                            DateFormat('EEE, d MMM y')
                                .format(quotes.value[index].addedAt!),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () {
                              quoteActionDialog(quotes.value[index]);
                            },
                          ),
                        );
                      },
                    )*/
              ,
            ),
        ],
      ),
    );
  }
}
