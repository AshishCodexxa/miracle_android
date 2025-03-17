import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:miracle/color.dart';
import 'package:miracle/src/data/model/audio.dart';
import 'package:miracle/src/data/model/category.dart';
import 'package:miracle/src/data/model/exercise.dart';
import 'package:miracle/src/data/model/video.dart';
import 'package:miracle/src/data/network/dio_client.dart';
import 'package:miracle/src/data/network/responses/audio_response.dart';
import 'package:miracle/src/data/network/responses/exercise_response.dart';
import 'package:miracle/src/data/network/responses/video_response.dart';
import 'package:miracle/src/features/collection/favorite_quotes.dart';
import 'package:miracle/src/features/collection/own_quotes.dart';
import 'package:miracle/src/features/home/home.dart';
import 'package:miracle/src/features/learn/category_quote.dart';
import 'package:miracle/src/features/learn/learn_section.dart';
import 'package:miracle/src/features/learn/life_exercise.dart';
import 'package:miracle/src/features/learn/mmmmm.dart';
import 'package:miracle/src/features/learn/video_player.dart';
import 'package:miracle/src/features/settings/collection.dart';
import 'package:miracle/src/features/settings/subscription.dart';
import 'package:miracle/src/utils/constant.dart';
import 'package:miracle/src/widget/menu_card.dart';
import 'package:miracle/src/widget/thumbnail_card.dart';

import '../../widget/gradient_button.dart';
import '../auth/login.dart';

class Learn extends HookWidget {
  const Learn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoading = useState<bool>(false);
    final motivations = useState<List<Category>>([]);
    final affirmations = useState<List<Category>>([]);
    final videos = useState<List<Video>>([]);
    final exercises = useState<List<Exercise>>([]);
    final audioList = useState<List<Audio>>([]);
    var profile = null;
    if(GetStorage().read(kProfileData)!=null)
      {
        profile = GetStorage().read(kProfileData) as Map<String, dynamic>;
      }
    print('profile= ${profile}');
    refresh() async {
      isLoading.value = true;
      DioClient().getCategories().then((response) {
        final categories = response.data;
        motivations.value = categories
            .where((element) => element.type == 'motivation')
            .toList();
        affirmations.value = categories
            .where((element) => element.type == 'affirmation')
            .toList();
      });
      DioClient().getVideos().then((response) {
        videos.value = VideoResponse.fromJson(response!).data;
      });
      DioClient().getExercises().then((response) {
        exercises.value = ExerciseResponse.fromJson(response!).data;
      });
      DioClient().getAudio().then((response) {
        audioList.value = AudioResponse.fromJson(response!).data;
      });
      isLoading.value = false;
    }

    // refresh() async {
    //   isLoading.value = true;
    //
    //
    //   DioClient().getCategories().then((response) {
    //     final categories = response.data;
    //     motivations.value = categories
    //         .where((element) => element.type == 'motivation')
    //         .toList();
    //     affirmations.value = categories
    //         .where((element) => element.type == 'affirmation')
    //         .toList();
    //   });
    //   DioClient().getVideos().then((response) {
    //     videos.value = VideoResponse.fromJson(response!).data;
    //   });
    //   DioClient().getExercises().then((response) {
    //     exercises.value = ExerciseResponse.fromJson(response!).data;
    //   });
    //   DioClient().getAudio().then((response) {
    //     audioList.value = AudioResponse.fromJson(response!).data;
    //   });
    //
    //   isLoading.value = false;
    // }

    useEffect(() {
      refresh();
      return;
    }, []);

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

    void showAllCategories(
        {required String label,
        required Widget Function(BuildContext, int) builder,
        required int itemCount}) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          height: MediaQuery.of(context).size.height * 0.92,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Spacer(),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'))
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  physics: const BouncingScrollPhysics(),
                  itemCount: itemCount,
                  itemBuilder: builder,
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(
                    height: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final List<MenuCard> categories = [
      MenuCard(
        name: 'General',
        designation: const Home(
          comeFrom: "0",
        ),
        icon: Image.asset(
          'assets/images/placeholder.webp',
        ),
      ),
      const MenuCard(
        name: 'My Own Quotes',
        designation: OwnQuotes(),
        icon: Icon(
          Icons.edit_note_rounded,
          size: 50,
          color: Colors.white,
        ),
      ),
      const MenuCard(
        name: 'My Favorite',
        designation: FavoriteQuotes(),
        icon: Icon(
          Icons.favorite_rounded,
          size: 40,
          color: Colors.red,
        ),
      ),
      const MenuCard(
        name: 'My Collection',
        designation: CollectionSetting(),
        icon: Icon(
          Icons.library_books_outlined,
          size: 40,
          color: Colors.white,
        ),
      )
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Learn',
        style: TextStyle(
          color: Colors.white
        ),),
        centerTitle: true,
      ),
      body: profile!=null?ListView(
        padding: const EdgeInsets.all(8),
        physics: const BouncingScrollPhysics(),
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 1,
                mainAxisSpacing: 15,
                crossAxisSpacing: 10),
            itemCount: 4,
            itemBuilder: (BuildContext context, int index) {
              return categories[index];
            },
          ),
          const SizedBox(
            height: 10,
          ),
          LearnSection(
            label: '  Affirmation',
            onSeeAllClicked: () {
              showAllCategories(
                  label: 'Affirmations',
                  itemCount: affirmations.value.length,
                  builder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 7, right: 7),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            // color: Theme.of(context)
                            //     .colorScheme
                            //     .secondaryContainer,
                            gradient: LinearGradient(
                              stops: [
                                0.4,
                                900.0,
                              ],
                              colors: [
                                const Color(0xFFA6D7F3).withAlpha(150),
                                const Color(0xff8458bb).withAlpha(150),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                  offset: const Offset(6, 6)),
                            ],
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: ListTile(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CategoryQuotes(
                                  category: affirmations.value[index],
                                ),
                              ));
                            },
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: FadeInImage.assetNetwork(
                                image:
                                    '${kBaseUrl}img/category/${affirmations.value[index].image}',
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
                              affirmations.value[index].name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Playfair_Medium'),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            },
            itemBuilder: (BuildContext context, int index) {
              final category = affirmations.value[index];
              return Container(
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 6),
                          color: Colors.grey.withOpacity(0.2)),
                    ]),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 10, left: 5, right: 5, bottom: 8),
                  child: ThumbnailCard(
                    title: category.name,
                    subtitle: '${category.totalQuote} affirmations',
                    image: '${kBaseUrl}img/category/${category.image}',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryQuotes(
                            category: category,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
            itemCount: affirmations.value.length,
          ),
          Container(
            color: Colors.grey.withOpacity(0.1),
            height: 5,
          ),
          LearnSection(
            label: '  Motivation',
            onSeeAllClicked: () {
              showAllCategories(
                  label: 'Motivation',
                  itemCount: motivations.value.length,
                  builder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.only(left: 7, right: 7),
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              // color: Theme.of(context)
                              //     .colorScheme
                              //     .secondaryContainer,
                              gradient: LinearGradient(
                                stops: [
                                  0.4,
                                  900.0,
                                ],
                                colors: [
                                  const Color(0xFFA6D7F3).withAlpha(150),
                                  const Color(0xff8458bb).withAlpha(150),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                    offset: const Offset(6, 6)),
                              ],
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: ListTile(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CategoryQuotes(
                                    category: motivations.value[index],
                                  ),
                                ));
                              },
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: FadeInImage.assetNetwork(
                                  image:
                                      '${kBaseUrl}img/category/${motivations.value[index].image}',
                                  placeholder: 'assets/images/placeholder.webp',
                                  imageErrorBuilder:
                                      (context, error, stackTrace) =>
                                          Image.asset(
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
                                motivations.value[index].name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Playfair_Medium'),
                              ),
                            ),
                          ),
                        ));
                  });
            },
            itemBuilder: (BuildContext context, int index) {
              final category = motivations.value[index];
              return Container(
                // color: Colors.red,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 6),
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 10, left: 5, right: 5, bottom: 8),
                  child: ThumbnailCard(
                      title: category.name,
                      subtitle: '${category.totalQuote} motivations',
                      image: '${kBaseUrl}img/category/${category.image}',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryQuotes(
                              category: category,
                            ),
                          ),
                        );
                      }),
                ),
              );
            },
            itemCount: motivations.value.length,
          ),
          Container(
            color: Colors.grey.withOpacity(0.1),
            height: 5,
          ),
          LearnSection(
            label: '  Video Learning',
            onSeeAllClicked: () {
              showAllCategories(
                  label: 'Video Learning',
                  itemCount: videos.value.length,
                  builder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 7, right: 7),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            // color: Theme.of(context)
                            //     .colorScheme
                            //     .secondaryContainer,
                            gradient: LinearGradient(
                              stops: [
                                0.4,
                                900.0,
                              ],
                              colors: [
                                const Color(0xFFA6D7F3).withAlpha(150),
                                const Color(0xff8458bb).withAlpha(150),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                  offset: const Offset(6, 6)),
                            ],
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: ListTile(
                            onTap: () {
                              if (profile['subscription_end'] == null &&
                                  !videos.value[index].isFree) {
                                Navigator.of(context).pop();
                                showSubscriptionSheet();
                                return;
                              }
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => VideoScreen(
                                  video: videos.value[index],
                                ),
                              ));
                            },
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: FadeInImage.assetNetwork(
                                image:
                                    '${kBaseUrl}img/video/${videos.value[index].image}',
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
                              videos.value[index].title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Playfair_Medium'),
                            ),
                            trailing: profile['subscription_end'] == null &&
                                    !videos.value[index].isFree
                                ? const Icon(Icons.lock)
                                : null,
                          ),
                        ),
                      ),
                    );
                  });
            },
            itemBuilder: (BuildContext context, int index) {
              final video = videos.value[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 6),
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      ThumbnailCard(
                        title: video.title,
                        image: '${kBaseUrl}img/video/${video.image}',
                        onPressed: () {
                          profile['subscription_end'] != null || video.isFree
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VideoScreen(
                                      video: video,
                                    ),
                                  ),
                                )
                              : showSubscriptionSheet();
                        },
                      ),
                      Visibility(
                        visible: profile['subscription_end'] == null &&
                            !video.isFree,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.lock,
                            size: 20,
                            color: primaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
            itemCount: videos.value.length,
          ),
          Container(
            color: Colors.grey.withOpacity(0.1),
            height: 5,
          ),
          LearnSection(
            label: '  Audio',
            onSeeAllClicked: () {
              showAllCategories(
                  label: 'Audio',
                  itemCount: audioList.value.length,
                  builder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.only(left: 7, right: 7),
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              // color: Theme.of(context)
                              //     .colorScheme
                              //     .secondaryContainer,
                              gradient: LinearGradient(
                                stops: [
                                  0.4,
                                  900.0,
                                ],
                                colors: [
                                  const Color(0xFFA6D7F3).withAlpha(150),
                                  const Color(0xff8458bb).withAlpha(150),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                    offset: const Offset(6, 6)),
                              ],
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: ListTile(
                              onTap: () {
                                if (profile['subscription_end'] == null &&
                                    !audioList.value[index].isFree) {
                                  Navigator.of(context).pop();
                                  showSubscriptionSheet();
                                  return;
                                }
                                // Navigator.of(context).push(MaterialPageRoute(
                                //   builder: (context) => MyApp(
                                //     audio: audioList.value[index],
                                //   ),
                                // ));
                              },
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: FadeInImage.assetNetwork(
                                  image:
                                      '${kBaseUrl}img/audio/${audioList.value[index].image}',
                                  placeholder: 'assets/images/placeholder.webp',
                                  imageErrorBuilder:
                                      (context, error, stackTrace) =>
                                          Image.asset(
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
                                audioList.value[index].title,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Playfair_Medium'),
                              ),
                              trailing: profile['subscription_end'] == null &&
                                      !audioList.value[index].isFree
                                  ? const Icon(Icons.lock)
                                  : null,
                            ),
                          ),
                        ));
                  });
            },
            itemBuilder: (BuildContext context, int index) {
              final audio = audioList.value[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 6),
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 10, left: 5, right: 5, bottom: 8),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      ThumbnailCard(
                        title: audio.title,
                        image: '${kBaseUrl}img/audio/${audio.image}',
                        onPressed: () {
                          profile['subscription_end'] != null || audio.isFree
                              ? /*Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder:
                                          (context) => *//*AudioPlayerScreen(
                                audio: audio,
                              ),*//*
                                              MyApp(
                                                audio: audio,
                                              )),
                                )*/Container()
                              : showSubscriptionSheet();
                        },
                      ),
                      Visibility(
                        visible: profile['subscription_end'] == null &&
                            !audio.isFree,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.lock,
                            size: 20,
                            color: primaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
            itemCount: audioList.value.length,
          ),
          Container(
            color: Colors.grey.withOpacity(0.1),
            height: 5,
          ),
          LearnSection(
            label: '  Life Exercise',
            onSeeAllClicked: () {
              showAllCategories(
                  label: 'Life Exercise',
                  itemCount: exercises.value.length,
                  builder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 7, right: 7),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          // color:
                          //     Theme.of(context).colorScheme.secondaryContainer,
                          gradient: LinearGradient(
                            stops: [
                              0.4,
                              900.0,
                            ],
                            colors: [
                              const Color(0xFFA6D7F3).withAlpha(150),
                              const Color(0xff8458bb).withAlpha(150),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                blurRadius: 5,
                                spreadRadius: 1,
                                offset: const Offset(6, 6)),
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: ListTile(
                            onTap: () {
                              if (profile['subscription_end'] == null &&
                                  !exercises.value[index].isFree) {
                                Navigator.of(context).pop();
                                showSubscriptionSheet();
                                return;
                              }
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => LifeExerciseScreen(
                                    exercise: exercises.value[index],
                                  ),
                                ),
                              );
                            },
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: FadeInImage.assetNetwork(
                                image:
                                    '${kBaseUrl}img/life/${exercises.value[index].image}',
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
                              exercises.value[index].title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Playfair_Medium'),
                            ),
                            trailing: profile['subscription_end'] == null &&
                                    !exercises.value[index].isFree
                                ? const Icon(Icons.lock)
                                : null,
                          ),
                        ),
                      ),
                    );
                  });
            },
            itemBuilder: (BuildContext context, int index) {
              final exercise = exercises.value[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 6),
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 10, left: 5, right: 5, bottom: 8),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      ThumbnailCard(
                          title: exercise.title,
                          image: '${kBaseUrl}img/life/${exercise.image}',
                          onPressed: () {
                            profile['subscription_end'] != null ||
                                    exercise.isFree
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LifeExerciseScreen(
                                        exercise: exercise,
                                      ),
                                    ),
                                  )
                                : showSubscriptionSheet();
                          }),
                      Visibility(
                        visible: profile['subscription_end'] == null &&
                            !exercise.isFree,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.lock,
                            size: 20,
                            color: primaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
            itemCount: exercises.value.length,
          ),
        ],
      ):
        Center(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(padding: EdgeInsets.symmetric(horizontal: 25),
              child:Text(
                'Please login for more customization',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15
                ),
              ) ,),
              const SizedBox(
                height: 16,
              ),
              GradientButton(
                label: 'Continue',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ),
                  );
                },
              ),
            ],
          ) ,
        ),
    );
  }
}
