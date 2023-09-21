// import 'dart:async';
// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:miracle/src/data/model/subscription.dart';
// import 'package:miracle/src/data/network/dio_client.dart';
// import 'package:miracle/src/data/network/responses/subscription_response.dart';
// import 'package:miracle/src/utils/constant.dart';
// import 'package:miracle/src/widget/gradient_button.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:pay/pay.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../subscription/enums.dart';
// import '../../subscription/subscription_controller.dart';
// import 'payment_config.dart' as payment_config;
//
// class SubscriptionScreen extends HookConsumerWidget {
//   const SubscriptionScreen({super.key});
//
//   getoffer() async{
//     final offerings = await Purchases.getOfferings();
//     print('offering='+offerings.all.values.toString());
//     StoreProduct product = offerings.current!.monthly!.storeProduct;
//     print('product='+product.priceString);
//   }
//
//
//   sub() async{
//     CustomerInfo customerInfo = await Purchases.getCustomerInfo();
//
//     print('active subsc=${customerInfo.entitlements.all.isEmpty}');
//   }
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//      sub();
//
//     final plans = useState<List<Subscription>>([]);
//     final isLoading = useState<bool>(false);
//     final selectedIndex = useState<int>(0);
//     final couponPrice = useState<int>(0);
//     final isApplyCouponExpanded = useState<bool>(false);
//     final couponCodeTextController = useTextEditingController();
//
//     // final String testID = '123';
//
//     const String threeMonthsPlanID = '123';
//     const String yearlyPlan = '1_year';
//
//     const List<String> _kProductIds = <String>[threeMonthsPlanID, yearlyPlan];
//
//     bool _available = true;
//
//     int _credits = 0;
//
//    // getoffer();
//
//     // ios pay
//     //
//     // Future<void> _getProducts() async {
//     //   Set<String> ids = Set.from([_kProductIds]);
//     //   ProductDetailsResponse response =
//     //       await _inAppPurchase.queryProductDetails(ids);
//     //
//     //   _products = response.productDetails;
//     // }
//     //
//     // PurchaseDetails _hasPurchased(String productID) {
//     //   return _purchases.firstWhere(
//     //       (purchase) => purchase.productID == productID,
//     //       orElse: null);
//     // }
//     //
//     // /// Your own business logic to setup a consumable
//     // void _verifyPurchase() {
//     //   PurchaseDetails purchase = _hasPurchased(_kProductIds.toString());
//     //
//     //   // TODO serverside verification & record consumable in the database
//     //
//     //   if (purchase != null && purchase.status == PurchaseStatus.purchased) {
//     //     _credits = 10;
//     //   }
//     // }
//     //
//     // initialize() async {
//     //   // Check availability of In App Purchases
//     //   _available = await _inAppPurchase.isAvailable();
//     //
//     //   if (_available) {
//     //   //  await _getProducts();
//     //     // await _getPastPurchases();
//     //
//     //     // Verify and deliver a purchase with your own business logic
//     //     _verifyPurchase();
//     //
//     //     _subscription = _inAppPurchase.purchaseStream.listen((data) {
//     //       _purchases.addAll(data);
//     //       _verifyPurchase();
//     //     });
//     //   }
//     // }
//     //
//     // void _buyProduct(ProductDetails prod) {
//     //   final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
//     //   // _iap.buyNonConsumable(purchaseParam: purchaseParam);
//     //   _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
//     // }
//
//     void _onPurchaserInfoUpdate(PromotedPurchaseResult purchaserInfo) {
//       // Check if user has an active subscription
//       if (purchaserInfo.productIdentifier.isNotEmpty) {
//         // Clear the last transaction cache
//         // purchaserInfo.productIdentifier.
//       }
//     }
//
//     refresh() async {
//       isLoading.value = true;
//       final data = await DioClient().getSubscription();
//       final response = SubscriptionResponse.fromJson(data!);
//       plans.value = response.data;
//       isLoading.value = false;
//     }
//
//     // void _onPurchaserInfoUpdate(PurchaserInfo purchaserInfo) {
//     //   // Check if user has an active subscription
//     //   if (purchaserInfo.activeSubscriptions.isNotEmpty) {
//     //
//     //     Purchases.clearCaches();
//     //   }
//     // }
//
//     Future updateCustomerStatus() async {
//       final cutomerInfo = await Purchases.getCustomerInfo();
//
//       final entitlements = cutomerInfo.entitlements.active['all_subscriptions'];
//
//       if (entitlements != null && entitlements.isActive == true) {
//
//       }
//     }
//
//     useEffect(() {
//       refresh();
//       Purchases.removeCustomerInfoUpdateListener((customerInfo) { updateCustomerStatus();});
//       return;
//     }, []);
//     void showAlertDialog(BuildContext context, String title, String message) {
//       // set up the buttons
//       Widget continueButton = TextButton(
//         child: const Text("Continue"),
//         onPressed: () {
//           Navigator.of(context)
//             ..pop()
//             ..pop();
//         },
//       );
//       // set up the AlertDialog
//       AlertDialog alert = AlertDialog(
//         title: Text(title),
//         content: Text(message),
//         actions: [
//           continueButton,
//         ],
//       );
//       // show the dialog
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return alert;
//         },
//       );
//     }
//
//     void handlePaymentErrorResponse(PaymentFailureResponse response) {
//       // showAlertDialog(context, "Payment Failed",
//       //     "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
//
//       showAlertDialog(context, "Payment Failed", "${response.message}");
//     }
//
//     void handleExternalWalletSelected(ExternalWalletResponse response) {
//       showAlertDialog(
//           context, "External Wallet Selected", "${response.walletName}");
//     }
//     // final lastPrice = useState<String>("0");
//     //
//     // lastPrice.value = "${(plans.value[selectedIndex.value].price - couponPrice.value)}";
//     // print("{(plans.value[selectedIndex.value].price - couponPrice.value)} ${(plans.value[selectedIndex.value].price - couponPrice.value)}");
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Subscription'),
//         centerTitle: true,
//       ),
//       body:GetX<SubscriptionController>(
//         init: Get.put(SubscriptionController()),
//         builder: (SubscriptionController controller){
//          // print('controller offering'+controller.offerings.value.values.toString());
//           print('sub status =${controller.subscriptionStatus.value.name}');
//           return Column(
//             children: [
//               if (isLoading.value)
//                 const Expanded(
//                   child: Center(
//                     child: CircularProgressIndicator(),
//                   ),
//                 ),
//               if (!isLoading.value) ...[
//                 Expanded(
//                   child: controller.offerings.value.isNotEmpty
//                       ? ListView.separated(
//                     physics: const BouncingScrollPhysics(),
//                     padding: const EdgeInsets.all(16),
//                     itemBuilder: (context, index) {
//                       return GestureDetector(
//                         onTap: () {
//                           selectedIndex.value = index;
//                           print("Selected ${selectedIndex.value}");
//                         },
//                         child: Card(
//                           color: Theme.of(context)
//                               .colorScheme
//                               .secondaryContainer,
//                           child: Padding(
//                             padding: const EdgeInsets.all(16),
//                             child: Row(
//                               children: [
//                                 selectedIndex.value == index
//                                     ? const Icon(
//                                   Icons.check_circle_outline,
//                                   color: Colors.green,
//                                 )
//                                     : const Icon(Icons.circle_outlined),
//                                 const SizedBox(
//                                   width: 10,
//                                 ),
//                                 Column(
//                                   crossAxisAlignment:
//                                   CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       index==0?'Yearly':'Monthly',
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .bodyLarge
//                                           ?.copyWith(
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .onSecondaryContainer,
//                                       ),
//                                     ),
//                                     Text(
//                                       index==0?'365 Day(s)':'30 Day(s)',
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .bodyText2
//                                           ?.copyWith(
//                                           color: Theme.of(context)
//                                               .colorScheme
//                                               .onSecondaryContainer),
//                                     ),
//                                   ],
//                                 ),
//                                 const Spacer(),
//                                 Text(
//                                   index==0?controller.offerings.value.values.first.annual!.storeProduct.priceString
//                                       :controller.offerings.value.values.first.monthly!.storeProduct.priceString,
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .bodyLarge
//                                       ?.copyWith(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onSecondaryContainer),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                     separatorBuilder: (context, index) => const SizedBox(
//                       height: 4,
//                     ),
//                     itemCount: 2,
//                   ) : const Text('No data'),
//                 ),
//                 /* Card(
//               margin: const EdgeInsets.symmetric(
//                 vertical: 8,
//                 horizontal: 16,
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Text(
//                           'Plan Name',
//                           style: Theme.of(context)
//                               .textTheme
//                               .titleMedium
//                               ?.copyWith(fontWeight: FontWeight.w500),
//                         ),
//                         const Spacer(),
//                         Text(
//                           plans.value[selectedIndex.value].name,
//                           style: Theme.of(context)
//                               .textTheme
//                               .titleMedium
//                               ?.copyWith(fontWeight: FontWeight.w500),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     Row(
//                       children: [
//                         const Text(
//                           'Grand Total',
//                           style: TextStyle(fontSize: 15),
//                         ),
//                         const Spacer(),
//                         Text(
//                           '₹ ${plans.value[selectedIndex.value].price}',
//                           style: const TextStyle(fontSize: 15),
//                         )
//                       ],
//                     ),
//                     if (couponPrice.value > 0)
//                       Row(
//                         children: [
//                           const Text('Coupon', style: TextStyle(fontSize: 15)),
//                           const Spacer(),
//                           Text(
//                             '- ₹ ${couponPrice.value}',
//                             style: const TextStyle(fontSize: 15),
//                           )
//                         ],
//                       ),
//                     const Divider(),
//                     Row(
//                       children: [
//                         const Text(
//                           'Net Payable',
//                           style: TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const Spacer(),
//                         Text(
//                           '₹ ${plans.value[selectedIndex.value].price - couponPrice.value}',
//                           style: const TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Card(
//               margin: const EdgeInsets.symmetric(
//                 vertical: 8,
//                 horizontal: 16,
//               ),
//               child: Column(children: [
//                 ListTile(
//                   title: const Text('Do you have coupon code?'),
//                   trailing: IconButton(
//                     icon: Icon(
//                       isApplyCouponExpanded.value
//                           ? Icons.arrow_drop_up
//                           : Icons.arrow_drop_down,
//                     ),
//                     onPressed: () {
//                       isApplyCouponExpanded.value =
//                           !isApplyCouponExpanded.value;
//                     },
//                   ),
//                 ),
//                 isApplyCouponExpanded.value
//                     ? Container(
//                         padding: const EdgeInsets.all(16),
//                         child: Row(mainAxisSize: MainAxisSize.min, children: [
//                           Expanded(
//                               flex: 3,
//                               child: TextField(
//                                 controller: couponCodeTextController,
//                                 decoration: const InputDecoration(
//                                   isDense: true,
//                                   border: OutlineInputBorder(),
//                                   hintText: 'Enter Code',
//                                 ),
//                               )),
//                           const SizedBox(
//                             width: 16,
//                           ),
//                           Expanded(
//                             flex: 2,
//                             child: OutlinedButton(
//                               onPressed: () {
//                                 if (couponCodeTextController.text.isEmpty) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                       content: Text('Please enter code'),
//                                     ),
//                                   );
//                                   return;
//                                 }
//                                 final data = {
//                                   'code': couponCodeTextController.text.trim()
//                                 };
//                                 DioClient().applyCoupon(data).then((response) {
//                                   if (response == null) return;
//                                   final data = response['data'];
//                                   if (data['discount_type'] == 'absolute') {
//                                     couponPrice.value = data['discount'] as int;
//
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                         content:
//                                             Text('Coupon applied successfully'),
//                                       ),
//                                     );
//                                     couponCodeTextController.clear();
//                                   }
//                                 }).onError((error, stackTrace) {
//                                   if (error is DioError) {
//                                     final errors = error.response?.data
//                                         as Map<String, dynamic>;
//
//                                     if (errors['message'] != null) {
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(
//                                         SnackBar(
//                                           content: Text(errors['message']),
//                                         ),
//                                       );
//                                     }
//                                   }
//                                 });
//                               },
//                               child: const Padding(
//                                 padding: EdgeInsets.symmetric(vertical: 16),
//                                 child: Text('Apply'),
//                               ),
//                             ),
//                           ),
//                         ]),
//                       )
//                     : Container()
//               ]),
//             )*/
//               ],
//
//               //rzp_test_TR10gkPm5yHKHF
//
//               // if (plans.value.isNotEmpty)
//               //
//               //   // ios pay
//               //   ApplePayButton(
//               //     paymentConfiguration: PaymentConfiguration.fromJsonString(payment_config.defaultApplePay),
//               //     paymentItems: [
//               //       PaymentItem(
//               //         label: 'Manifest Miracle',
//               //         amount: "${(plans.value[selectedIndex.value].price - couponPrice.value)}",
//               //       )
//               //     ],
//               //     style: ApplePayButtonStyle.black,
//               //     type: ApplePayButtonType.buy,
//               //     width: 200,
//               //     height: 50,
//               //     margin: const EdgeInsets.only(top: 15.0),
//               //     onPaymentResult: (value) {
//               //       print(value);
//               //       DioClient()
//               //                     .subscribe(plans.value[selectedIndex.value].id)
//               //                     .then((value) {
//               //                   showAlertDialog(context, "Payment Successful",
//               //                       "Congratulation Your Subscription is Activated");
//               //                   //Navigator.of(context).pop();
//               //                 });
//               //     },
//               //     onError: (error) {
//               //       print(error);
//               //     },
//               //     loadingIndicator: const Center(
//               //       child: CircularProgressIndicator(),
//               //     ),
//               //   ),
//
//               if (controller.offerings.value.isNotEmpty)
//                 Column(
//                   children: [
//                     GradientButton(
//                         label: 'Subscribe',
//                         onPressed: () async{
//
//                           if (selectedIndex.value == 0) {
//                            // print('pckge='+controller.offerings.value.values.first.annual!.toString());
//                            controller.makePurchase(controller.offerings.value.values.first.annual!,context);
//
//                            // controller.getSubscriptionStatus();
//                            // if(controller.subscriptionStatus==SubscriptionStatus.premium)
//                            //   {
//                            //     DioClient()
//                            //           .subscribe(4)
//                            //           .then((value) {
//                            //         showAlertDialog(context, "Payment Successful",
//                            //             "Congratulation Your Subscription is Activated");
//                            //         //Navigator.of(context).pop();
//                            //       });
//                            //   }
//                             // if(controller.subscriptionStatus==SubscriptionStatus.premium){
//                             //   DioClient()
//                             //       .subscribe(4)
//                             //       .then((value) {
//                             //     showAlertDialog(context, "Payment Successful",
//                             //         "Congratulation Your Subscription is Activated");
//                             //     //Navigator.of(context).pop();
//                             //   });
//                             // }
//
//                             // Purchases.purchaseProduct("miracle_2999_1y").then((value) {
//                             //   print("yessssssssssssss $value");
//                             //
//                             //   DioClient().subscribe(4).then((value) {
//                             //     print("Logout 4");
//                             //     // Purchases.removeCustomerInfoUpdateListener((customerInfo) { updateCustomerStatus();});
//                             //   });
//                             //
//                             //   Navigator.pop(context);
//                             // }).onError((error, stackTrace) {
//                             //   print("errrorrrrr $error");
//                             //   return Future.value();
//                             // });
//                           }
//                           else if (selectedIndex.value == 1) {
//                             print('pckge='+controller.offerings.value.values.first.monthly!.toString());
//                             controller.makePurchase(controller.offerings.value.values.first.monthly!,context);
//
//                             // if(controller.subscriptionStatus==SubscriptionStatus.premium){
//                             //   DioClient()
//                             //       .subscribe(5)
//                             //       .then((value) {
//                             //     showAlertDialog(context, "Payment Successful",
//                             //         "Congratulation Your Subscription is Activated");
//                             //     //Navigator.of(context).pop();
//                             //   });
//                             // }
//                             // Purchases.purchaseProduct("miracle_299_1m").then((value) {
//                             //   print("yessssssssssssss $value");
//                             //
//                             //   DioClient().subscribe(5).then((value) {
//                             //     print("Logout 5");
//                             //     // Purchases.removeCustomerInfoUpdateListener((customerInfo) { updateCustomerStatus();});
//                             //   });
//                             //
//                             //   Navigator.pop(context);
//                             // }).onError((error, stackTrace) {
//                             //   print("errrorrrrr $error");
//                             //   return Future.value();
//                             // });
//                           }
//                         }),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
//                       child: RichText(
//                         text: TextSpan(
//                           text: 'By subscribing, you agree to our ',
//                           style: const TextStyle(
//                             color: Colors.black,
//                             fontSize: 10,
//                           ),
//                           children: <TextSpan>[
//                             TextSpan(
//                               text: 'Purchase Terms of Service.',
//                               style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   decoration: TextDecoration.underline,
//                                   fontSize: 10),
//                               recognizer: TapGestureRecognizer()
//                                 ..onTap = () {
//                                   launchUrl(Uri.parse(kEulaTerms));
//                                 },
//                             ),
//                             const TextSpan(
//                               text:
//                               ' Subscriptions auto-renew until canceled, as described in the Terms. A verified phone number is required to subscribe. If you have subscribed on another platform, manage your subscription through that platform.',
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 10,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     )
//                   ],
//                 )
//             ],
//           );
//         },
//       )
//     );
//   }
// }

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:miracle/src/data/model/subscription.dart';
import 'package:miracle/src/data/network/dio_client.dart';
import 'package:miracle/src/data/network/responses/subscription_response.dart';
import 'package:miracle/src/widget/gradient_button.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class SubscriptionScreen extends HookConsumerWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plans = useState<List<Subscription>>([]);
    final isLoading = useState<bool>(false);
    final selectedIndex = useState<int>(0);
    final couponPrice = useState<int>(0);
    final isApplyCouponExpanded = useState<bool>(false);
    final couponCodeTextController = useTextEditingController();

    refresh() async {
      isLoading.value = true;
      final data = await DioClient().getSubscription();
      final response = SubscriptionResponse.fromJson(data!);
      plans.value = response.data;
      isLoading.value = false;
    }

    useEffect(() {
      refresh();
      return;
    }, []);
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

    void handlePaymentErrorResponse(PaymentFailureResponse response) {
      // showAlertDialog(context, "Payment Failed",
      //     "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");

      showAlertDialog(context, "Payment Failed", "${response.message}");
    }

    void handleExternalWalletSelected(ExternalWalletResponse response) {
      showAlertDialog(
          context, "External Wallet Selected", "${response.walletName}");
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          if (isLoading.value)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          if (!isLoading.value) ...[
            Expanded(
              child: plans.value.isNotEmpty
                  ? ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      selectedIndex.value = index;
                    },
                    child: Card(
                      color: Theme.of(context)
                          .colorScheme
                          .secondaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            selectedIndex.value == index
                                ? const Icon(
                              Icons.check_circle_outline,
                              color: Colors.green,
                            )
                                : const Icon(Icons.circle_outlined),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  plans.value[index].name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer,
                                  ),
                                ),
                                Text(
                                  '${plans.value[index].duration} Day(s)',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Text(
                              '₹ ${plans.value[index].price}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                  height: 4,
                ),
                itemCount: plans.value.length,
              )
                  : const Text('No data'),
            ),
            Card(
              margin: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Plan Name',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        Text(
                          plans.value[selectedIndex.value].name,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        const Text(
                          'Grand Total',
                          style: TextStyle(fontSize: 15),
                        ),
                        const Spacer(),
                        Text(
                          '₹ ${plans.value[selectedIndex.value].price}',
                          style: const TextStyle(fontSize: 15),
                        )
                      ],
                    ),
                    if (couponPrice.value > 0)
                      Row(
                        children: [
                          const Text('Coupon', style: TextStyle(fontSize: 15)),
                          const Spacer(),
                          Text(
                            '- ₹ ${couponPrice.value}',
                            style: const TextStyle(fontSize: 15),
                          )
                        ],
                      ),
                    const Divider(),
                    Row(
                      children: [
                        const Text(
                          'Net Payable',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '₹ ${plans.value[selectedIndex.value].price - couponPrice.value}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              child: Column(children: [
                ListTile(
                  title: const Text('Do you have coupon code?'),
                  trailing: IconButton(
                    icon: Icon(
                      isApplyCouponExpanded.value
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                    ),
                    onPressed: () {
                      isApplyCouponExpanded.value =
                      !isApplyCouponExpanded.value;
                    },
                  ),
                ),
                isApplyCouponExpanded.value
                    ? Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Expanded(
                        flex: 3,
                        child: TextField(
                          controller: couponCodeTextController,
                          decoration: const InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(),
                            hintText: 'Enter Code',
                          ),
                        )),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      flex: 2,
                      child: OutlinedButton(
                        onPressed: () {
                          if (couponCodeTextController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter code'),
                              ),
                            );
                            return;
                          }
                          final data = {
                            'code': couponCodeTextController.text.trim()
                          };
                          DioClient().applyCoupon(data).then((response) {
                            if (response == null) return;
                            final data = response['data'];
                            if (data['discount_type'] == 'absolute') {
                              couponPrice.value = data['discount'] as int;

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                  Text('Coupon applied successfully'),
                                ),
                              );
                              couponCodeTextController.clear();
                            }
                          }).onError((error, stackTrace) {
                            if (error is DioError) {
                              final errors = error.response?.data
                              as Map<String, dynamic>;

                              if (errors['message'] != null) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  SnackBar(
                                    content: Text(errors['message']),
                                  ),
                                );
                              }
                            }
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text('Apply'),
                        ),
                      ),
                    ),
                  ]),
                )
                    : Container()
              ]),
            )
          ],

          //rzp_test_TR10gkPm5yHKHF

          if (plans.value.isNotEmpty)
            GradientButton(
                label: 'Pay',
                onPressed: () {
                  Razorpay razorpay = Razorpay();
                  var options = {
                    'key': 'rzp_test_TR10gkPm5yHKHF',
                    'amount': (plans.value[selectedIndex.value].price -
                        couponPrice.value) *
                        100,
                    'name': 'Miracle Manifest',
                    'description':
                    'Miracle Manifest ${plans.value[selectedIndex.value].name} subscription',
                    'retry': {'enabled': true, 'max_count': 1},
                    'send_sms_hash': true,
                    'prefill': {'contact': '', 'email': ''},
                    'external': {
                      'wallets': ['paytm']
                    }
                  };
                  razorpay.on(
                      Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
                  razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (response) {
                    DioClient()
                        .subscribe(plans.value[selectedIndex.value].id)
                        .then((value) {
                      showAlertDialog(context, "Payment Successful",
                          "Congratulation Your Subscription is Activated");
                      //Navigator.of(context).pop();
                    });
                  });
                  razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
                      handleExternalWalletSelected);

                  razorpay.open(options);
                }),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
