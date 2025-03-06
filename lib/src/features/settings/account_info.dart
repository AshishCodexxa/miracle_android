import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miracle/color.dart';
import 'package:miracle/src/data/model/subscription.dart';
import 'package:miracle/src/data/network/dio_client.dart';
import 'package:miracle/src/data/network/responses/subscription_response.dart';
import 'package:miracle/src/features/settings/subscription.dart';
import 'package:miracle/src/widget/confirmation_dialog.dart';
import 'package:miracle/src/widget/gradient_button.dart';
import 'package:miracle/src/widget/offering_dialog.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class AccountInfo extends HookWidget {
  const AccountInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profile = useState<Map<String, dynamic>>({});
    final isLoading = useState<bool>(true);
    final plans = useState<List<Subscription>>([]);

    void refresh() async{
      isLoading.value = true;
      final data = await DioClient().getSubscription();
      final response = SubscriptionResponse.fromJson(data!);
      plans.value = response.data;
      DioClient().getProfile().then((response) {
        profile.value = response['data'];
        isLoading.value = false;
      });
    }

     final _kProductIds = <String, int>{
       'miracle_299_1m': 4,
       'miracle_2999_1y': 5,
     };

    bool isSubscribed = false;

    void showAlertDialog(BuildContext context, String title, String message) {
      // set up the buttons
      Widget continueButton = TextButton(
        child: const Text("Continue"),
        onPressed: () {
          Navigator.of(context)
            ..pop()
            ..pop();
        },
      );
      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          continueButton,
        ],
      );
      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    Future updateCustomerStatus() async {
      final cutomerInfo = await Purchases.getCustomerInfo();

      final entitlements = cutomerInfo.entitlements.active['all_subscriptions'];

      isSubscribed = entitlements != null;

    }

    useEffect(() {
      refresh();

      print("plaannnnnnn ${ profile.value['plan']}");

      Purchases.addCustomerInfoUpdateListener(
              (_) => updateCustomerStatus(),
      );

      updateCustomerStatus();

      return;
    }, []);


    Future fetchOffers() async {
      final offerings = await Purchases.getOfferings();

      if(offerings.current == null) {
        final snackBar = SnackBar(content: Text("No Plans Found"));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);

      }else{

        final packages = offerings.current?.availablePackages;

        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => PaywallWidget(
              title: 'Upgrade Your Plan',
              description: 'Upgrade to a new plan to enjoy more benefits',
              packages: packages,
              onCLickedPackage: (packages) async {

                //  Purchases.purchasePackage(packages).then((value) {
                //
                //   print("yessssssssssssss $value");
                //
                //
                //
                //   DioClient()
                //       .subscribe(5)
                //       .then((value) {
                //     DioClient().getProfile().then((response) {
                //       profile.value = response['data'];
                //       isLoading.value = false;
                //     });
                //         Navigator.pop(context);
                //   });
                //
                //   // Navigator.pop(context);
                // });
                // Navigator.pop(context);

                final product = packages.storeProduct;

                print("product ${product.identifier}  ${product.price}");

                if(product.identifier == 'miracle_299_1m'){
                  Purchases.purchaseProduct("miracle_299_1m").then((value) {
                    print("yessssssssssssss $value");

                    DioClient().subscribe(5).then((value) {
                      print("Logout 5");
                      DioClient().getProfile().then((response) {
                        profile.value = response['data'];
                        isLoading.value = false;
                      });
                    });

                    Navigator.pop(context);
                  }).onError((error, stackTrace) {
                    print("errrorrrrr $error");
                    return Future.value();
                  });
                } else if(product.identifier == 'miracle_2999_1y'){
                  Purchases.purchaseProduct("miracle_2999_1y").then((value) {
                    print("yessssssssssssss $value");

                    DioClient().subscribe(4).then((value) {
                      print("Logout 4");
                      DioClient().getProfile().then((response) {
                        profile.value = response['data'];
                        isLoading.value = false;
                      });
                    });

                    Navigator.pop(context);
                  }).onError((error, stackTrace) {
                    print("errrorrrrr $error");
                    return Future.value();
                  });
                }

              }
          ),
        );
      }

    }



    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(backgroundColor: primaryColor,
        leading: const Icon(Icons.arrow_back,
          color: Colors.white,),
        title: const Text('Account Info',
        style: TextStyle(
          color: Colors.white
        ),),
        centerTitle: true,
      ),
      body: isLoading.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Name',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(profile.value['name'],
                      style: Theme.of(context).textTheme.bodySmall),
                  const Divider(),
                  Text(
                    'Email',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(profile.value['email'],
                      style: Theme.of(context).textTheme.bodySmall),
                  const Divider(),
                  Text(
                    'Renewal Date',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                      profile.value['subscription_end'] ??
                          'No Active Subscription',
                      style: Theme.of(context).textTheme.bodySmall),
                  const Divider(),
                  Text(
                    'Remaining Days',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                      profile.value['day_remains'] != null
                          ? '${profile.value['day_remains']}'
                          : 'No Active Subscription',
                      style: Theme.of(context).textTheme.bodySmall),
                  const Divider(),
                  Text(
                    'Current Plan',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(profile.value['plan'] ?? 'No Active Subscription',
                      style: Theme.of(context).textTheme.bodySmall),
                  const Divider(),
                  const Spacer(),



                //   profile.value['day_remains'] != null ? GradientButton(
                //   label: 'Upgrade Plans',
                //   onPressed: () async {
                //     print("See Plans");
                //     fetchOffers();
                //   },
                // ) :
                  profile.value['day_remains'] == null || profile.value['day_remains'] ==0?
                  GradientButton(
                    label: 'Subscribe',
                    onPressed: ()  async {
                      print("Subscribe");

                      //  Purchases.purchaseProduct("miracle_299_1m").then((value) {
                      //
                      //     print("yessssssssssssss $value");
                      //
                      //   DioClient()
                      //       .subscribe(5)
                      //       .then((value) {
                      //   });
                      //
                      //   Navigator.pop(context);
                      // }).onError((error, stackTrace) {
                      //   print("errrorrrrr $error");
                      //   return Future.value();
                      // });

                      if (profile.value['subscription_end'] != null &&
                          !await showConfirmationDialog(
                            context,
                            heading: 'Are you sure?',
                            message:
                                'You have active subscription\nwant to upgrade?',
                            isConfirmationDialog: true,
                          )) {
                        return;
                      }



                      // profile.value['subscription_end'] != null ? fetchOffers() :
                      Navigator.of(context)
                          .push(
                        MaterialPageRoute(
                          builder: (context) => const SubscriptionScreen(),
                        ),
                      )
                          .then((value) {
                        refresh();
                      });

                      /*  showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text("Already Subscribed",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),),
                          content:  Text(
                              "You Have Already Subsribed the Plan.",
                              style: Theme.of(context).textTheme.bodySmall),
                          actions: <Widget>[
                            // TextButton(
                            //   onPressed: () => Navigator.pop(context, 'Cancel'),
                            //   child: const Text('Cancel'),
                            // ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );*/
                    },
                  )
                  :Container(),


                  if (profile.value['subscription_end'] != null) ...[
                    const SizedBox(height: 10),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          showConfirmationDialog(
                            context,
                            heading: 'Are you sure!',
                            message: 'Do you want to cancel your subscription?',
                            isConfirmationDialog: true,
                          ).then((confirmation) {
                            if (confirmation) {
                              DioClient().refundRequest().then((value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Refund request submitted successfully',
                                    ),
                                  ),
                                );
                              });
                            }
                          });
                        },
                        child: const Text(
                          'If you are not happy ask for refund',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ),
    );
  }
}
