import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:miracle/color.dart';
import 'package:miracle/src/data/model/quote.dart';
import 'package:miracle/src/data/network/dio_client.dart';
import 'package:miracle/src/data/network/responses/quote_response.dart';
import 'package:miracle/src/dialogs/action_quote.dart';
import 'package:miracle/src/features/home/quote_home.dart';
import 'package:miracle/src/utils/quote_utils.dart';
import 'package:miracle/src/widget/confirmation_dialog.dart';
import 'package:miracle/src/widget/no_collection.dart';

class OwnQuotes extends HookWidget {
  const OwnQuotes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ownQuotes = useState<List<Quote>>([]);
    final isLoading = useState<bool>(false);

    refresh() async {
      isLoading.value = true;
      final data = await DioClient().getOwnQuotes();
      final response = QuoteResponse.fromJson(data!);
      ownQuotes.value = response.data;
      isLoading.value = false;
    }

    useEffect(() {
      refresh();
      return;
    }, []);

    ownQuoteActionDialog(Quote quote) {
      showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            content: ActionQuoteDialog(
              quote: quote,
              isOwnQuote: true,
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
            DioClient().deleteOwnQuotes(quote.id).then((value) {
              ownQuotes.value =
                  ownQuotes.value.where((q) => q.id != quote.id).toList();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Removed successfully'),
                  duration: Duration(seconds: 3),
                ),
              );
            });
          }
        });
      });
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: const Icon(Icons.arrow_back,
          color: Colors.white,),
        title: const Text('Own Quotes',
        style: TextStyle(
          color: Colors.white
        ),),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Add new Quote',
            onPressed: () {
              addQuoteDialog(context, null).then((value) => refresh());
            },
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
          if (!isLoading.value)
            Expanded(
              child: ownQuotes.value.isNotEmpty
                  ? ListView.builder(
                      itemCount: ownQuotes.value.length,
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
                                final qs = [...ownQuotes.value];
                                qs.removeAt(index);
                                qs.insert(0, ownQuotes.value[index]);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => QuoteHome(
                                      quotes: qs,
                                    ),
                                  ),
                                );
                              },
                              title: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  ownQuotes.value[index].quote,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                              subtitle: Text(
                                DateFormat('EEE, d MMM y')
                                    .format(ownQuotes.value[index].createdAt!),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.more_vert),
                                onPressed: () {
                                  ownQuoteActionDialog(ownQuotes.value[index]);
                                },
                              ),
                            ),
                          ),
                        );
                      }))
                  /*ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            final qs = [...ownQuotes.value];
                            qs.removeAt(index);
                            qs.insert(0, ownQuotes.value[index]);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => QuoteHome(
                                  quotes: qs,
                                ),
                              ),
                            );
                          },
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              ownQuotes.value[index].quote,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          subtitle: Text(
                            DateFormat('EEE, d MMM y')
                                .format(ownQuotes.value[index].createdAt!),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () {
                              ownQuoteActionDialog(ownQuotes.value[index]);
                            },
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: ownQuotes.value.length,
                    )*/
                  : const NoCollection(
                      title: 'You haven’t added\n'
                          'anything yet.',
                    ),
            ),
        ],
      ),
    );
  }
}
