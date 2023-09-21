import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:miracle/color.dart';
import 'package:miracle/src/data/model/quote.dart';
import 'package:miracle/src/data/network/dio_client.dart';
import 'package:miracle/src/features/auth/login.dart';
import 'package:miracle/src/features/settings/subscription.dart';
import 'package:miracle/src/utils/constant.dart';
import 'package:miracle/src/widget/confirmation_dialog.dart';
import 'package:miracle/src/widget/quote_widget.dart';

class Home extends HookWidget {
  final String comeFrom;

  const Home({this.comeFrom = "", Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoading = useState<bool>(false);
    final quotes = useState<List<Quote>>([]);
    final startPage = useState<int>(1);
    final profile = useState<Map<String, dynamic>>({});

    loadData() async {
      final data = await DioClient().getQuotes(startPage.value);
      if (data.data.isNotEmpty) startPage.value = startPage.value++;
      quotes.value = [...quotes.value, ...data.data];
    }

    loadFreeData() async {
      final data = await DioClient().getFreeQuotes();
      if (data.data.isNotEmpty) startPage.value = startPage.value++;
      quotes.value = [...quotes.value, ...data.data];
    }

    refresh() async {
      isLoading.value = true;
      try {
        loadData();
        DioClient().getProfile().then((response) {
          profile.value = response['data'];
          GetStorage().write(kProfileData, profile.value);
        });
      }
      on DioError catch (e) {
        print('error code= ${e.response?.statusMessage}');
        if (e.response?.statusCode == 401) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const Login(),
            ),
            (route) => false,
          );
        }
      }
      if(profile.value.isEmpty)
        {
          loadFreeData();
        }
      isLoading.value = false;
    }

    subscriptionDialog() {
      if (profile.value['subscription_end'] != null) {
        showConfirmationDialog(
          context,
          heading: 'Are you sure?',
          message: 'You have active subscription\nwant to upgrade?',
          isConfirmationDialog: true,
        ).then((value) {
          if (!value) return;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SubscriptionScreen(),
            ),
          );
          return;
        });
      }
      else {
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
                      onTap: () async {
                        Navigator.of(context).pop();
                        if(profile.value.isEmpty){
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                            ),
                          );
                        }
                       else{
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SubscriptionScreen(),
                            ),
                          );
                        }
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
                            fontWeight: FontWeight.bold,
                          ),
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
    }

    final activatedTheme = GetStorage().read<String>(kActiveTheme) ?? '';

    useEffect(() {
      refresh();
      return;
    }, []);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            activatedTheme.isEmpty
                ? Image.asset(
                    'assets/images/background.jpeg',
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    File(activatedTheme),
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
            if (isLoading.value)
              const Center(
                child: CircularProgressIndicator(),
              ),
            if (!isLoading.value)
              PageView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: quotes.value.length,
                scrollDirection: Axis.vertical,
                onPageChanged: (index) {
                  if (index % 3 == 0 && profile.value['subscription_end'] == null) {
                    subscriptionDialog();
                  }
                  if (index == (quotes.value.length - 2))
                  {
                    profile.value.isEmpty?loadFreeData():loadData();
                  }
                },
                itemBuilder: (context, index) {
                  return QuoteWidget(
                    quote: quotes.value[index],
                  );
                },
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                  visible: comeFrom == "0" ? true : false,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onDoubleTap: () {},
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
               profile.value['day_remains'] ==0?
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: subscriptionDialog,
                    icon: const FaIcon(
                      FontAwesomeIcons.crown,
                      color: Colors.amber,
                    ),
                  ),
                )
                :Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
