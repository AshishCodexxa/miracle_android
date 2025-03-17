import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:miracle/color.dart';
import 'package:miracle/src/data/model/collection.dart';
import 'package:miracle/src/data/network/dio_client.dart';
import 'package:miracle/src/data/network/responses/collection_response.dart';
import 'package:miracle/src/dialogs/add_collection.dart';
import 'package:miracle/src/features/collection/collection_quotes.dart';
import 'package:miracle/src/widget/no_collection.dart';

class CollectionSetting extends HookWidget {
  const CollectionSetting({Key? key}) : super(key: key);

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

    addCollectionDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AddCollectionDialog();
        },
      ).then((value) {
        if (value != null) refresh();
      });
    }

    onCollectionSelected(Collection collection) {
      Navigator.of(context)
          .push(
            MaterialPageRoute(
              builder: (context) => CollectionQuotes(
                collection: collection,
              ),

            ),
          )
          .then((value) => refresh());
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(backgroundColor: primaryColor,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back,
            color: Colors.white,),
        ),
        title: const Text('Collections',
        style: TextStyle(
          color: Colors.white
        ),),
        centerTitle: true,
        actions: [
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Add Collection',
            onPressed: addCollectionDialog,
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
              child: collections.value.isNotEmpty
                  ? ListView.builder(
                      itemCount: collections.value.length,
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
                              dense: true,
                              title: Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  collections.value[index].name,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                              subtitle: Text(
                                '${collections.value[index].quotesCount} quotes',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              trailing: const Icon(
                                Icons.chevron_right_outlined,
                              ),
                              onTap: () {
                                onCollectionSelected(collections.value[index]);
                              },
                            ),
                          ),
                        );
                      }))

                  /*ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(top: 3),
                          child: Container(
                            color: Colors.red,
                            child: ListTile(
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
                              trailing: const Icon(
                                Icons.chevron_right_outlined,
                              ),
                              onTap: () {
                                onCollectionSelected(collections.value[index]);
                              },
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: collections.value.length,
                    )*/
                  : NoCollection(
                      title: 'You haven’t have any \n'
                          'collections yet',
                      subTitle:
                          'Collections group quotes you save together, like\n'
                          '‘Loving myself’ or ‘Reaching my goals’.',
                      btnLabel: 'Create Collections',
                      onPressed: addCollectionDialog,
                    ),
            ),
        ],
      ),
    );
  }
}
