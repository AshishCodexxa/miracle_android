import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:miracle/color.dart';
import 'package:miracle/src/data/model/quote.dart';
import 'package:miracle/src/data/network/dio_client.dart';
import 'package:miracle/src/data/network/responses/quote_response.dart';
import 'package:miracle/src/dialogs/action_quote.dart';
import 'package:miracle/src/features/home/quote_home.dart';
import 'package:miracle/src/widget/confirmation_dialog.dart';
import 'package:miracle/src/widget/no_collection.dart';

class FavoriteQuotes extends HookWidget {
  const FavoriteQuotes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favorite = useState<List<Quote>>([]);
    final isLoading = useState<bool>(false);

    refresh() async {
      isLoading.value = true;
      final data = await DioClient().getFavorite();
      final response = QuoteResponse.fromJson(data!);
      favorite.value = response.data;
      isLoading.value = false;
    }

    useEffect(() {
      refresh();
      return;
    }, []);

    favoriteQuoteActionDialog(Quote quote) {
      showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            content: ActionQuoteDialog(
              quote: quote,
              hideFav: true,
              isFavorite: true,
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
            DioClient().deleteFavorite(quote.id).then((value) {
              favorite.value =
                  favorite.value.where((q) => q.id != quote.id).toList();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Removed from favorite'),
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
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back,
            color: Colors.white,),
        ),
        title: const Text('Favorite',
        style: TextStyle(
          color: Colors.white
        ),),
        centerTitle: true,
        actions: const [
          /* IconButton(
            icon: const Icon(Icons.search_outlined),
            tooltip: 'Search Quotes',
            onPressed: () {},
          ), */
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
                child: favorite.value.isEmpty
                    ? const NoCollection(
                        title: 'You don’t have any\n'
                            'favorites yet',
                      )
                    : ListView.builder(
                        itemCount: favorite.value.length,
                        itemBuilder: ((BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 5, right: 5),
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
                                  final qs = [...favorite.value];
                                  qs.removeAt(index);
                                  qs.insert(0, favorite.value[index]);
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
                                    favorite.value[index].quote,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                    maxLines: 1,
                                  ),
                                ),
                                subtitle: Text(
                                  DateFormat('EEE, d MMM y')
                                      .format(favorite.value[index].addedAt!),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.more_vert),
                                  onPressed: () {
                                    favoriteQuoteActionDialog(
                                        favorite.value[index]);
                                  },
                                ),
                              ),
                            ),
                          );
                        }))

                /*ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: favorite.value.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            final qs = [...favorite.value];
                            qs.removeAt(index);
                            qs.insert(0, favorite.value[index]);
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
                              favorite.value[index].quote,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          subtitle: Text(
                            DateFormat('EEE, d MMM y')
                                .format(favorite.value[index].addedAt!),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () {
                              favoriteQuoteActionDialog(favorite.value[index]);
                            },
                          ),
                        );
                      },
                    ),*/
                ),
        ],
      ),
    );
  }
}
