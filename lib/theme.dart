import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';

// final kWhiteText = GoogleFonts.nunito(
//   color: kWhiteColor,
// );

// Global variable to store the scale factor
double scaleFactor = 1.0;

bool get isMobile =>
    (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) &&
    kIsWeb == false;

const kWhiteColor = Color(0xFFffffff);
const kBlackColor = Color.fromARGB(255, 0, 0, 0);
const klightGreyColor = Color.fromARGB(253, 112, 112, 112);
const klightGreyBGColor = Color.fromARGB(255, 244, 248, 247);
const kNoInternetBGColor = Color.fromARGB(255, 220, 86, 76);

const kPrimary500Color = Color(0xFF21B689);
const kMediumTextColor = Color.fromARGB(255, 27, 27, 27);

const kBg100Color = Color.fromARGB(255, 239, 235, 236);

const klightGreyColorDark = Color.fromARGB(255, 255, 255, 255);
const klightGreyBGColorDark = Color.fromARGB(255, 244, 248, 247);

const kMediumTextColorDark = Color.fromARGB(255, 255, 255, 255);

const kBg100ColorDark = Color.fromARGB(0, 239, 235, 236);

const kMedium = FontWeight.w500;
const kRegular = FontWeight.w300;
const kSemiBold = FontWeight.w700;
const kBold = FontWeight.w900;

// Light mode
var kMediumTextStyle = TextStyle(
    fontSize: !isMobile ? 18 : 18.sp * scaleFactor,
    fontWeight: kMedium,
    color: kMediumTextColor);
var kMediumItlaicTextStyle = TextStyle(
    fontSize: !isMobile ? 14 : 14.sp * scaleFactor,
    fontWeight: kMedium,
    color: kPrimary500Color,
    fontStyle: FontStyle.italic);
var kMedium14TextStyle = TextStyle(
  fontSize: !isMobile ? 14 : 14.sp * scaleFactor,
  fontWeight: kMedium,
  color: kPrimary500Color,
  fontStyle: FontStyle.normal,
);

var kSemiBold21BlacTextStyle = TextStyle(
    fontSize: !isMobile ? 21 : 21.sp * scaleFactor,
    fontWeight: kSemiBold,
    color: kBlackColor,
    fontStyle: FontStyle.normal);
var kSemiBold18TextStyle = TextStyle(
    fontSize: !isMobile ? 18 : 18.sp * scaleFactor,
    fontWeight: kSemiBold,
    color: kMediumTextColor,
    fontStyle: FontStyle.normal);
var kBold15TextStyle = TextStyle(
    fontSize: !isMobile ? 14 : 14.sp * scaleFactor,
    fontWeight: kBold,
    color: kMediumTextColor,
    fontStyle: FontStyle.normal);

var kSemiBoldTextStyle = TextStyle(
    fontSize: !isMobile ? 18 : 18.sp * scaleFactor,
    fontWeight: kSemiBold,
    color: kMediumTextColor);

var kSemiBoldprimaryColorTextStyle = TextStyle(
    fontSize: !isMobile ? 15 : 15.sp * scaleFactor,
    fontWeight: kSemiBold,
    color: kPrimary500Color);

var kSemiBoldWhiteolorTextStyle = TextStyle(
    fontSize: !isMobile ? 15 : 15.sp * scaleFactor,
    fontWeight: kSemiBold,
    color: kWhiteColor);

var kSemiBoldBlackColorTextStyle = TextStyle(
    fontSize: !isMobile ? 15 : 15.sp * scaleFactor,
    fontWeight: kSemiBold,
    color: kBlackColor);

var kRegularTextStyle = TextStyle(
    fontSize: !isMobile ? 15 : 15.sp * scaleFactor,
    fontWeight: kRegular,
    color: kMediumTextColor);
var kRegular15TextStyle = TextStyle(
    fontSize: !isMobile ? 14 : 14.sp * scaleFactor,
    fontWeight: kRegular,
    color: kMediumTextColor);

var kRegular15WhiteTextStyle = TextStyle(
  fontSize: !isMobile ? 14 : 14.sp * scaleFactor,
  fontWeight: kRegular,
  color: kWhiteColor,
);
var kRegular15BlackTextStyle = TextStyle(
  fontSize: !isMobile ? 14 : 14.sp * scaleFactor,
  fontWeight: kRegular,
  color: kBlackColor,
);
var kRegularPrimaryColorTextStyle = TextStyle(
    fontSize: !isMobile ? 16 : 16.sp * scaleFactor,
    fontWeight: kRegular,
    color: kPrimary500Color);
var kRegularPrimaryColorTextStyle2 = TextStyle(
    fontSize: !isMobile ? 12 : 12.sp * scaleFactor,
    fontWeight: kRegular,
    color: kPrimary500Color);

// Dark mode
var kMediumTextStyleDark = TextStyle(
    fontSize: !isMobile ? 18 : 18.sp * scaleFactor,
    fontWeight: kMedium,
    color: kMediumTextColorDark);
var kMediumItlaicTextStyleDark = TextStyle(
    fontSize: !isMobile ? 14 : 14.sp * scaleFactor,
    fontWeight: kMedium,
    color: kPrimary500Color,
    fontStyle: FontStyle.italic);
var kMedium14TextStyleDark = TextStyle(
    fontSize: !isMobile ? 14 : 14.sp * scaleFactor,
    fontWeight: kMedium,
    color: kPrimary500Color,
    fontStyle: FontStyle.normal);

var kSemiBold21BlacTextStyleDark = TextStyle(
    fontSize: !isMobile ? 21 : 21.sp * scaleFactor,
    fontWeight: kSemiBold,
    color: kWhiteColor,
    fontStyle: FontStyle.normal);
var kSemiBold18TextStyleDark = TextStyle(
    fontSize: !isMobile ? 18 : 18.sp * scaleFactor,
    fontWeight: kSemiBold,
    color: kMediumTextColorDark,
    fontStyle: FontStyle.normal);
var kBold15TextStyleDark = TextStyle(
    fontSize: !isMobile ? 14 : 14.sp * scaleFactor,
    fontWeight: kBold,
    color: kMediumTextColorDark,
    fontStyle: FontStyle.normal);

var kSemiBoldTextStyleDark = TextStyle(
    fontSize: !isMobile ? 18 : 18.sp * scaleFactor,
    fontWeight: kSemiBold,
    color: kMediumTextColorDark);

var kSemiBoldprimaryColorTextStyleDark = TextStyle(
    fontSize: !isMobile ? 15 : 15.sp * scaleFactor,
    fontWeight: kSemiBold,
    color: kPrimary500Color);

var kRegularTextStyleDark = TextStyle(
    fontSize: !isMobile ? 14 : 14.sp * scaleFactor,
    fontWeight: kRegular,
    color: kMediumTextColorDark);
var kRegular15TextStyleDark = TextStyle(
    fontSize: !isMobile ? 14 : 14.sp * scaleFactor,
    fontWeight: kRegular,
    color: kMediumTextColorDark);

var kRegular15WhiteTextStyleDark = TextStyle(
  fontSize: !isMobile ? 14 : 14.sp * scaleFactor,
  fontWeight: kRegular,
  color: kBlackColor,
);
var kRegular15BlackTextStyleDark = TextStyle(
  fontSize: !isMobile ? 14 : 14.sp * scaleFactor,
  fontWeight: kRegular,
  color: kWhiteColor,
);
var kRegularPrimaryColorTextStyleDark2 = TextStyle(
    fontSize: !isMobile ? 12 : 12.sp * scaleFactor,
    fontWeight: kRegular,
    color: kPrimary500Color);

var kRegularPrimaryColorTextStyleDark = TextStyle(
    fontSize: !isMobile ? 16 : 16.sp * scaleFactor,
    fontWeight: kRegular,
    color: kPrimary500Color);
