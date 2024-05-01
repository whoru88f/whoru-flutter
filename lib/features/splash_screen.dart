import 'dart:async';

import 'package:chatapp/common/CountryNames/res/strings/tr.dart';
import 'package:chatapp/common/utility/shared_utility.dart';
import 'package:chatapp/features/login/auth_wrapper.dart';
import 'package:chatapp/features/common_widgets/app-loading-animation.dart';
import 'package:chatapp/features/sync_service.dart';
import 'package:chatapp/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _isLoading = true;
  int _currentStep = 0;
  Timer? _timer;

  void _startLoadingAnimation() {
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {
        _currentStep = (_currentStep + 1);
        print("_currentStep is $_currentStep");
        if (_currentStep > 2) {
          _timer?.cancel();
          _isLoading = false;
          _showUserRolePage();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _startLoadingAnimation();
    fetchAllDataFromFirestore();
  }

  Future<void> fetchAllDataFromFirestore() async {
    print("Started");
    final _ = await SyncService.instance.syncAllQuestionFromFirestore();
    print("LOADED");

    setState(() {
      //  _currentStep = 15;
      if (_currentStep > 2) {
        _timer?.cancel();
        _isLoading = false;
        _showUserRolePage();
      }
      print("RRRR_currentStep is $_currentStep");
    });
  }

  void _showUserRolePage() {
    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(
    //     builder: (context) => ProviderScope(
    //       // parent: ProviderScope.containerOf(context),
    //       child: AuthenticationWrapper(),
    //     ),
    //   ),
    // );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => AuthenticationWrapper(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = ScreenUtil().screenWidth;
    final sharedUtility = ref.read(sharedUtilityProvider);
    bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    // Set scaling factor based on the device type
    //scaleFactor = isTablet ? 0.8 : 1.0;
    return Scaffold(
      backgroundColor:
          sharedUtility.isDarkModeEnabled() ? kBlackColor : kWhiteColor,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Align(
            //   alignment: Alignment.topRight,
            //   child: Image.asset(
            //     width: width * 0.8,
            //     "assets/top-bg-splash.png",
            //   ),
            // ),
            // Align(
            //   alignment: Alignment.bottomLeft,
            //   child: Image.asset(
            //     width: width * 0.7,
            //     "assets/bot_bg_splash.png",
            //   ),
            // ),
            // Center(
            //   child: Image.asset(
            //     "assets/logo.gif",
            //     height: 65,
            //   ),
            // ),
            // Image.asset(
            //   width: width * 0.7,
            //   height: 100.0,
            //   "assets/logo.gif",
            // ),

            // const SizedBox(
            //   height: 25.0,
            // ),
            Image.asset(
              "assets/whoRu.png",
              width: (width * 0.8).w,
              height: 100.0.h,
            ),
            SizedBox(
              height: 25.0.h,
            ),
            Text(
              "Ai-powered role playing.",
              style: sharedUtility.isDarkModeEnabled()
                  ? kMediumTextStyleDark
                  : kMediumTextStyle,
            ),
            SizedBox(
              height: 25.0.h,
            ),
            // LoadingAnimationWidget.staggeredDotsWave(
            //   color: kPrimary500Color,
            //   size: 50,
            // ),
            AppLoadingAnimation(),
          ],
        ),
      ),
    );
  }
}
