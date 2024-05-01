import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';

class NoInternetBannerWidget extends StatelessWidget {
  const NoInternetBannerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kNoInternetBGColor,
      padding: EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 3.0,
      ),
      // height: 52.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.signal_wifi_connected_no_internet_4_rounded,
            color: Colors.white,
          ),
          Flexible(
            child: Text(
              "  Please check your internet connection.",
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                color: Colors.white,
                fontSize: !isMobile ? 14 : 14.sp * scaleFactor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
