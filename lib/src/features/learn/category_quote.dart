import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:miracle/color.dart';
import 'package:miracle/src/data/model/category.dart';
import 'package:miracle/src/data/network/dio_client.dart';
import 'package:miracle/src/data/network/responses/quote_response.dart';
import 'package:miracle/src/features/home/quote_home.dart';
import 'package:miracle/src/features/settings/subscription.dart';
import 'package:miracle/src/utils/constant.dart';

class CategoryQuotes extends StatelessWidget {
  const CategoryQuotes({Key? key, required this.category}) : super(key: key);
  final Category category;

  @override
  Widget build(BuildContext context) {
    final profile = GetStorage().read(kProfileData) as Map<String, dynamic>;
    showSubscriptionSheet() {
      final features = [
        // 'Enjoy your first 7 days free trial',
        'Cancel anytime from the app',
        'Quotes you can\'t find anywhere else',
        'Categories for any situation',
        'Billed annually, half yearly, quarterly'
      ];
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            // gradient: LinearGradient(
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter,
            //   colors: [Color(0xFFFFEFFE), Color(0xFFFFC9FD)],
            // ),
          ),
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 45, left: 23, right: 23),
                    child: Text(
                      'Subscribe to Access Premium Content of Manifest Miracle Plan',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: primaryColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: FaIcon(
                      FontAwesomeIcons.crown,
                      color: crown,
                      size: 64,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  for (String feature in features)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 16,
                      ),
                      child: Row(children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Icon(
                            Icons.check_circle_outline,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(
                            feature,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ]),
                    ),
                  const SizedBox(
                    height: 80,
                  ),
                  GestureDetector(
                    onDoubleTap: () {},
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SubscriptionScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: 50,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFA6D7F3), Color(0xff8458bb)],
                        ),
                      ),
                      child: const Center(
                          child: Text(
                        "Subscribe",
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onDoubleTap: () {},
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      color: Colors.transparent,
                      child: const Icon(
                        Icons.clear,
                        color: Colors.black,
                      )),
                ),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back,
            color: Colors.white,),
        ),
        title: Text(category.name,
        style: const TextStyle(
          color: Colors.white
        ),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: category.name,
              child: AspectRatio(
                aspectRatio: 13 / 7,
                child: PhysicalModel(
                  elevation: 8,
                  color: Colors.black12,
                  shadowColor: Colors.black12,
                  borderRadius: BorderRadius.circular(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      '${kBaseUrl}img/category/${category.image}',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              child: FutureBuilder<QuoteResponse>(
                  future: DioClient().getQuotesByCategory(category.id),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData && !snapshot.hasError) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final quotes = snapshot.data!.data;

                    if (quotes.isEmpty) {
                      return const Center(
                        child: Text('no quotes found'),
                      );
                    }

                    return Card(
                      elevation: 1,
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount: quotes.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              if (!quotes[index].isFree &&
                                  profile['subscription_end'] == null) {
                                showSubscriptionSheet();
                                return;
                              }

                              final qs =
                                  [...quotes].where((e) => e.isFree || profile['subscription_end'] != null).toList();
                              qs.remove(quotes[index]);
                              qs.insert(0, quotes[index]);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => QuoteHome(
                                    quotes: qs,
                                  ),
                                ),
                              );
                            },
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: FadeInImage.assetNetwork(
                                image:
                                    '${kBaseUrl}img/quote/${quotes[index].image}',
                                placeholder: 'assets/images/placeholder.webp',
                                imageErrorBuilder:
                                    (context, error, stackTrace) => Image.asset(
                                  'assets/images/placeholder.webp',
                                  width: 50,
                                  height: 50,
                                ),
                                fit: BoxFit.cover,
                                width: 50,
                                height: 50,
                              ),
                            ),
                            title: Text(
                              quotes[index].quote,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            subtitle: Text(quotes[index].author ?? ''),
                            trailing: profile['subscription_end'] == null &&
                                    !quotes[index].isFree
                                ? const Icon(Icons.lock)
                                : null,
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(
                          thickness: 1.2,
                          indent: 16,
                          endIndent: 16,
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
