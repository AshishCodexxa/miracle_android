import 'dart:io';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:miracle/color.dart';
import 'package:miracle/src/di/app_module.dart';
import 'package:miracle/src/features/auth/login.dart';
import 'package:miracle/src/features/home/main_screen.dart';
import 'package:miracle/src/service/notification_service.dart';
import 'package:miracle/src/utils/constant.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:workmanager/workmanager.dart';



final userId = GetStorage().read(kUserId);


//final _configuration = PurchasesConfiguration('appl_aNHAtfjBicoofJIkqvJSrsfisIg')..appUserID = '$userId';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(options: const FirebaseOptions(
    apiKey: 'AIzaSyA3U4XyyqB7vmRJFKVSsT1MGK81Izj7bpE',
    appId: '1:894057546171:web:74510e35f0f956ab7f049e',
    messagingSenderId: '894057546171',
    projectId: 'manifest-miracle',
  ),);
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug,
    // appleProvider: AppleProvider.appAttest,
  );
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: primaryColor,
  ));
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // await Purchases.configure(_configuration);
  //
  // Purchases.logIn('$userId');
  // Purchases.logOut();
  // await setupPurchase();
  Workmanager().initialize(callbackDispatcher);
  if (!(GetStorage().read<bool>(kIsWorkManagerActive) ?? false)) {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
    scheduleNotifications();
    final current = DateTime.now();
    Workmanager().registerPeriodicTask(
      "task",
      "simpleTask",
      initialDelay: DateTime(current.year, current.month, current.day + 1, 0, 5)
          .difference(current),
      frequency: const Duration(days: 1),
    );
    GetStorage().write(kIsWorkManagerActive, true);
  }

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

Future<void> setupPurchase() async {
  await Purchases.setDebugLogsEnabled(true);

  try {
    late PurchasesConfiguration configuration;
    if (Platform.isAndroid) {
     // configuration = PurchasesConfiguration(GOOGLE_PLAY_API_KEY);
    }
    else if (Platform.isIOS) {
      configuration = PurchasesConfiguration('appl_aNHAtfjBicoofJIkqvJSrsfisIg');
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

    throw "Couldn't configure Purchase";
  }
}


const bool _kAutoConsume = true;

const String threeMonthsPlanID = '123';
const String yearlyPlan = '1_year';

const List<String> _kProductIds = <String>[
  threeMonthsPlanID,
  yearlyPlan
];


class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeModeProvider);

    final accessToken = GetStorage().read(kAccessToken);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: kTitle,
      themeMode: theme,
      color: primaryColor,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.dark,
        ),
      ),
      home:accessToken != null ? const MainScreen() : const Login(),
    );
  }
}
