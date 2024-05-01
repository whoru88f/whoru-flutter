import 'package:chatapp/common/utility/shared_utility.dart';
import 'package:chatapp/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoInternetWidget extends ConsumerWidget {
  const NoInternetWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = ScreenUtil().screenHeight;
    final sharedUtility = ref.read(sharedUtilityProvider);
    return Scaffold(
      backgroundColor:
          sharedUtility.isDarkModeEnabled() ? kBlackColor : kWhiteColor,
      body: Padding(
        padding: const EdgeInsets.all(30.0).w,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/no-wifi.png",
                height: height * 0.3,
              ),
              SizedBox(
                height: 30.0.h,
              ),
              Text(
                "Whoops !!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: !isMobile ? 24 : 24.sp * scaleFactor,
                  color: sharedUtility.isDarkModeEnabled()
                      ? kMediumTextColorDark
                      : kMediumTextColor,
                ),
              ),
              SizedBox(
                height: 10.0.h,
              ),
              Text(
                "No Internet connection was found, Please check your internet connection.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: !isMobile ? 16 : 16.sp * scaleFactor,
                  color: sharedUtility.isDarkModeEnabled()
                      ? kMediumTextColorDark
                      : kMediumTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
