import 'package:chatapp/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Utility {
  static final Utility _singleton = Utility._internal();

  factory Utility() {
    return _singleton;
  }

  Utility._internal();

  double getMainScreenWidth(BuildContext context) {
    return ScreenUtil().screenWidth;
  }

  double getViewMaxWidthForTablets(BuildContext context) {
    return 600.0;
  }

  double _getViewPaddingDifference(BuildContext context) {
    return (getMainScreenWidth(context) - getViewMaxWidthForTablets(context)) /
        2.0;
  }

  double getViewPaddingForTablets(BuildContext context) {
    return getMainScreenWidth(context) > getViewMaxWidthForTablets(context)
        ? _getViewPaddingDifference(context)
        : 30.0;
  }

  onBasicAlertPressed(
      {required context, String? title, required String message}) {
    // Alert(context: context, title: title ?? "", desc: message, buttons: [
    //   DialogButton(
    //     child: Text(
    //       "OK",
    //     ),
    //     onPressed: () => Navigator.pop(context),
    //     color: kPrimary500Color,
    //   ),
    // ]).show();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  _onAlertButtonsPressed(context) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "RFLUTTER ALERT",
      desc: "Flutter is more awesome with RFlutter Alert.",
      buttons: [
        DialogButton(
          child: Text(
            "FLAT",
            style: TextStyle(
              color: Colors.white,
              fontSize: !isMobile ? 18 : 18.sp * scaleFactor,
            ),
          ),
          onPressed: () => Navigator.pop(context),
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "GRADIENT",
            style: TextStyle(
              color: Colors.white,
              fontSize: !isMobile ? 18 : 18.sp * scaleFactor,
            ),
          ),
          onPressed: () => Navigator.pop(context),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0),
          ]),
        )
      ],
    ).show();
  }
}
