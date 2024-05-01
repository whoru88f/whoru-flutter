import 'package:chatapp/common/utility/shared_utility.dart';
import 'package:chatapp/features/common_widgets/app-loading-animation.dart';
import 'package:chatapp/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatapp/features/common_widgets/app-logo-widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountVerifiedPage extends ConsumerWidget {
  const AccountVerifiedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var width = ScreenUtil().screenWidth;
    final sharedUtility = ref.read(sharedUtilityProvider);
    return Scaffold(
      backgroundColor:
          sharedUtility.isDarkModeEnabled() ? kBlackColor : kWhiteColor,
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 30.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 160.h,
            ),
            SizedBox(
              width: (width * 0.9).w,
              child: Text(
                "Account Successfully verified!",
                maxLines: 2,
                textAlign: TextAlign.center,
                style: kSemiBoldTextStyle,
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            // Image.asset(
            //   "assets/logo.gif",
            //   height: 265,
            // ),
            AppLogoWidget(),
            SizedBox(
              height: 30.h,
            ),
          ],
        ),
      ),
    );
  }
}
