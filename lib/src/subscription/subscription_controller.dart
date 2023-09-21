import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:miracle/src/subscription/subscription_services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../data/network/dio_client.dart';
import 'enums.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionController extends GetxController {
  Rx<Map<SubscriptionType, Offering>> offerings = Rx({});
  Rx<SubscriptionStatus> subscriptionStatus = Rx(SubscriptionStatus.none);

  @override
  void onInit() {
    super.onInit();
    loadProducts();
    getSubscriptionStatus();
  }
  Future<void> initialize() async {
    // Initial setup to ensure subsriptions work perfectly well.
    await SubscriptionServices.setupPurchase();

    // Load subscriptions into the controller.
    await loadProducts();

    // Listen to purchases updates.
    Purchases.addCustomerInfoUpdateListener(subscriptionStatusListener);
  }

  Future<void> loadProducts() async {
    final _prods = await SubscriptionServices.fetchOffers();
    offerings.value = _prods;
  }


  void fetchOffers() async {
    offerings.value = await SubscriptionServices.fetchOffers();
    print('fetch offers');
  }

  void subscriptionStatusListener([CustomerInfo? _purchaserInfo]) async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();

      if (customerInfo.entitlements.all.isEmpty) {
        subscriptionStatus.value = SubscriptionStatus.none;
        if (kDebugMode) {
          print('[ERROR]: Couldn\'t fetch Purchase!');
        }
      }
      else if (customerInfo.entitlements.all[EntitlementIdentifier.premium]!=null && customerInfo.entitlements.all[EntitlementIdentifier.premium]!.isActive) {
        subscriptionStatus.value = SubscriptionStatus.premium;
      }
      else {
        subscriptionStatus.value = SubscriptionStatus.none;
      }
    } on PlatformException catch (e, s) {
      if (kDebugMode) {
        print('Unsupported Platform!');
        print('[ERROR]: $e \n[STACKTRACE]: $s');
      }

      // TODO(@johnOyekanmi): Uncomment once the issue with revenueCat is fixed
      // on both Android and iOS.
      throw 'Application Error!';
    }
  }


  void getSubscriptionStatus() async {
    print('inside getsubsc');
    CustomerInfo customerInfo = await Purchases.getCustomerInfo();
    print('initial value='+subscriptionStatus.value.toString());
    if (customerInfo.entitlements.all.isEmpty) {
      subscriptionStatus.value = SubscriptionStatus.none;
      if (kDebugMode) {
        print('[ERROR]: Couldn\'t fetch Purchase!');
      }
    }
    else if (customerInfo.entitlements.all[EntitlementIdentifier.premium]!=null && customerInfo.entitlements.all[EntitlementIdentifier.premium]!.isActive) {
      subscriptionStatus.value = SubscriptionStatus.premium;
    }
    else {
      subscriptionStatus.value = SubscriptionStatus.none;
    }

    print('initial value='+subscriptionStatus.value.toString());
  }

  Future<void> makePurchase(Package package,BuildContext context) async {
    print('package type='+package.toString());
    try {
      await Purchases.purchasePackage(package).then((value) {
        print('package type='+package.toString());
        if(package.packageType==PackageType.monthly){
          DioClient()
              .subscribe(5)
              .then((value) {
                Get.defaultDialog(
                  title: "Payment Successful",
                  content: Text("Congratulation Your Subscription is Activated"),
                  textConfirm: 'Continue',
                  onConfirm: (){
                    Navigator.of(context)
                      ..pop()
                      ..pop();
                  }
                );
          });
        }
        if(package.packageType==PackageType.annual){
          DioClient()
              .subscribe(4)
              .then((value) {
            Get.defaultDialog(
                title: "Payment Successful",
                content: Text("Congratulation Your Subscription is Activated"),
                textConfirm: 'Continue',
                onConfirm: (){
                  Navigator.of(context)
                    ..pop()
                    ..pop();
                }
            );
          });
        }
      });
    }
    on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        throw 'Purchase Cancelled!'.tr;
      }
      throw "Couldn't make Purchase".tr;
    }
  }

  static SubscriptionController get instance =>
      Get.find<SubscriptionController>();
}
