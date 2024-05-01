import 'dart:io';

import 'package:chatapp/common/utility/app_theme_provider.dart';
import 'package:chatapp/common/utility/shared_utility.dart';
import 'package:chatapp/database/hive/hive_injector.dart';
import 'package:chatapp/features/common_widgets/app-loading-animation.dart';
import 'package:chatapp/features/common_widgets/no-internet-widget.dart';
import 'package:chatapp/features/login/auth_wrapper.dart';
import 'package:chatapp/features/login/dashboard_page.dart';
import 'package:chatapp/features/login/login_services.dart';
import 'package:chatapp/features/login/otp_screen.dart';
import 'package:chatapp/features/splash_screen.dart';
import 'package:chatapp/features/user_role/pages/user_role_page.dart';
import 'package:chatapp/features/user_role/services/user_role_service.dart';
import 'package:chatapp/theme.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_no_internet_widget/flutter_no_internet_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:excel/excel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await ScreenUtil.ensureScreenSize();
  await HiveInjector.setup();
  // Print the default path where Hive stores its database files
  // print('Default Hive database path: ${Hive.path}');
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Lock to portrait mode
    DeviceOrientation.portraitDown,
  ]);

  final sharedPreferences = await SharedPreferences.getInstance();

  bool isFirstTime =
      sharedPreferences.getBool('isAppLaunchedFirstTimeEver') ?? true;

  if (isFirstTime) {
    // The app is launching for the first time ever
    print('App launched for the first time');
    sharedPreferences.setBool('isAppLaunchedFirstTimeEver',
        false); // Set isFirstTime to false for subsequent launches
    // FirebaseAuth.instance.signOut();
  } else {
    // The app has been launched before
    print('App already launched before');
  }
  //FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  print('isMobile $isMobile');

  runApp(
    ProviderScope(
      overrides: [
        // override the previous value with the new object
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: ScreenUtilInit(
        designSize: Size(393, 852),
        minTextAdapt: true,
        child: InternetWidget(
          offline: FullScreenWidget(
            child: NoInternetWidget(),
          ),
          whenOffline: () => print('No Internet'),
          whenOnline: () => print('Connected to internet'),
          loadingWidget: AppLoadingAnimation(),
          online: MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorObservers: [
              FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
            ],
            routes: {
              '/': (context) {
                bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;

                scaleFactor = isTablet ? 0.6 : 1.0;
                print("scaleFactor  ${scaleFactor}");
                return SplashScreen();
              },
              '/otp': (context) {
                final routesParams = ModalRoute.of(context)?.settings.arguments
                    as Map<String, String>;

                return OTPScreen(
                  phone: routesParams["phone"] ?? "",
                  verificationCode: routesParams["verificationCode"] ?? "",
                );
              },
              '/dashboard': (context) => const DashboardPage(),
            },
          ),
        ),
      ),
    ),
  );

  // runApp(MyApp());
}
