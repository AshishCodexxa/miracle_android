// ignore_for_file: constant_identifier_names

enum SubscriptionType {
  premium,
}

enum SubscriptionStatus {
  premium,
  none,
}

SubscriptionType? getSubscriptionType(String id) {
  switch (id) {
    case ProductIdentifier.premium_1m:
      return SubscriptionType.premium;
    case ProductIdentifier.premium_1y:
      return SubscriptionType.premium;
    default:
      return null;
  }
}


const Map<SubscriptionType, String> subscriptionToOfferingMap = {
  SubscriptionType.premium: 'subscriptions',
};

const Map<String, SubscriptionType> offeringToSubscriptionMap = {
  'subscriptions': SubscriptionType.premium,

};

class EntitlementIdentifier {
  static const premium = 'all_subscriptions';

  static const values = [
    premium,
  ];
}

class ProductIdentifier {

  static const premium_1y = 'miracle_2999_1y';
  static const premium_1m = 'miracle_299_1m';



  static const values = {
    premium_1y,
    premium_1m,

  };
}

class PremiumProductIdentifiers {
  static const String monthly = ProductIdentifier.premium_1m;
  static const String yearly = ProductIdentifier.premium_1y;

  static const values = [
    monthly,
    yearly,
  ];
}

enum SubscriptionPackageType {monthly, yearly }
