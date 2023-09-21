import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'enums.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionServices {

  static const APPLE_API_KEY = 'appl_aNHAtfjBicoofJIkqvJSrsfisIg';

  static Future<void> setupPurchase() async {
    await Purchases.setDebugLogsEnabled(true);

    try {
      PurchasesConfiguration configuration;
      if (Platform.isIOS) {
        configuration = PurchasesConfiguration(APPLE_API_KEY);
      }
      else {
        if (kDebugMode) {
          print('Unsupported Platform!');
        }

        throw 'Application Error';
      }

      await Purchases.configure(configuration);
      // await Purchases.logIn(userID);
    } on PlatformException catch (e, s) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (kDebugMode) {
        print('[$errorCode]$e');
        print(s);
      }

      throw "Couldn't configure Purchase".tr;
    }
  }

  static Future<Map<SubscriptionType, Offering>> fetchOffers() async {
    try {
      final offerings = await Purchases.getOfferings();
      print('offering in service= '+offerings.toString());
      if (kDebugMode) {
        print(offerings.current);
      }

      var all = offerings.all.map<SubscriptionType, Offering>((key, value) {
        print('key='+key+' value= '+value.toString());
        var subType = offeringToSubscriptionMap[key];

        if (subType == null) {
          if (kDebugMode) {
            print('Unsupported Platform!');
          }

          throw 'Application Error!';
        }

        return MapEntry(subType, value);
      });

      if (kDebugMode) {
        print(all);
      }

      return all;
    } on PlatformException catch (e, s) {
      if (kDebugMode) {
        print('Unsupported Platform!');
        print(e);
        print(s);
      }
      return <SubscriptionType, Offering>{};
    }
    // TODO(johnOyekanmi): Replace with the commented code once the
    // issue with revenueCat is resolved.
    //   throw 'Application Error!';
    // } on Exception catch (e, s) {
    //   if (kDebugMode) {
    //     print('Unsupported Platform!');
    //     print(e);
    //     print(s);
    //   }

    //   throw 'Application Error!';
    // }
  }

  static Future<String> buy(Package package) async {
    String response='';
    try {
      await Purchases.purchasePackage(package).whenComplete(() {
        response= 'buy';
      });
    }
    on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        response='cancleed';
        throw 'Purchase Cancelled!'.tr;
      }
      response='error';
      throw "Couldn't make Purchase".tr;
    }
    return response;
  }

}
