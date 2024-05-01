import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppLogoWidget extends StatelessWidget {
  AppLogoWidget({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final width = ScreenUtil().screenWidth * 0.5;

    return Image.asset(
      "assets/whoRu.png",
      width: width.w,
      fit: BoxFit.contain,
      height: 80.h,
    );
  }
}
