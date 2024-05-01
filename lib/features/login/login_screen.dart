import 'package:chatapp/common/CountryNames/country.dart';
import 'package:chatapp/common/CountryNames/country_service.dart';
import 'package:chatapp/common/CountryNames/pages/country_autocomplete_page.dart';
import 'package:chatapp/common/utility/shared_utility.dart';
import 'package:chatapp/common/utility/utility.dart';
import 'package:chatapp/database/openai_db.dart';
import 'package:chatapp/features/Privacy/Views/privacy_page.dart';
import 'package:chatapp/features/common_widgets/app-loading-animation.dart';
import 'package:chatapp/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:chatapp/features/common_widgets/app-logo-widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:chatapp/features/common_widgets/no-internet-widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'otp_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final CountryService _countryService = CountryService();
  Country? searchResultCountry;
  late List<Country> _countryList;
  String _errorMessage = "";
  TextEditingController controller = TextEditingController();
  String? _verificationCode;
  PhoneNumber enteredNumber = PhoneNumber(isoCode: 'US');

  bool _isOperationInProgress = false;

  final FocusNode _focusNode = FocusNode();

  bool _isloading = false;

  @override
  void initState() {
    super.initState();
    fetchCountrys();
  }

  void fetchCountrys() async {
    _countryList = _countryService.getAll();
  }

  bool _validateLoginDetails(PhoneNumber? phonenumber) {
    // print("dialCode ${phonenumber?.dialCode}");
    // print("isoCode ${phonenumber?.isoCode}");

    setState(() {
      _isloading = true;
    });

    print("phonenumber ${phonenumber}");

    if (phonenumber?.phoneNumber == null) {
      print(" phonenumber isoCode ${phonenumber}");

      _errorMessage = "Phone number should be 10 digits.";
      setState(() {
        _isloading = false;
      });
      return false;
    }

    print("isoCode ${phonenumber!.parseNumber().length}");
    _isOperationInProgress = false;
    if (phonenumber.parseNumber().length < 10 ||
        phonenumber.parseNumber().length > 10) {
      _errorMessage = "Phone number should be 10 digits.";
      setState(() {
        _isloading = false;
      });
      return false;
    } else if (phonenumber == null ||
        phonenumber.isoCode == null ||
        phonenumber.isoCode?.isEmpty == true) {
      _errorMessage = "Please enter valid country code";
      setState(() {
        _isloading = false;
      });
      return false;
    } else if (phonenumber.parseNumber() == null ||
        phonenumber.parseNumber().isEmpty == true) {
      _errorMessage = "Please enter valid phone number";
      setState(() {
        _isloading = false;
      });
      return false;
    }
    return true;
  }

  Future<void> _verifyPhone({required String phoneString}) async {
    print("_verifyPhone $phoneString");
    return await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '${phoneString}',
        verificationCompleted: (PhoneAuthCredential credential) {
          // await FirebaseAuth.instance
          //     .signInWithCredential(credential)
          //     .then((value) async {
          //   if (value.user != null) {
          //     print("user ${value.user}");
          //     // Navigator.pushAndRemoveUntil(
          //     //     context,
          //     //     MaterialPageRoute(
          //     //       builder: (context) => OTPScreen(
          //     //         phone: phoneString,
          //     //       ),
          //     //     ),
          //     //     (route) => false);
          //   }
          // });
          //  _isOperationInProgress = false;
          setState(() {
            _isloading = false;
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print("ERR is: ${e.message}");
          //  _isOperationInProgress = false;
          setState(() {
            _isloading = false;
          });
          Utility().onBasicAlertPressed(
              context: context,
              message: e.message ?? "Phone verification failed");
        },
        codeSent: (String? verficationID, int? resendToken) {
          print("codeSent is: ${verficationID}");
          // setState(() {
          //   _verificationCode = verficationID;
          // });
          if (verficationID != null) {
            setState(() {
              _isloading = false;
              _isOperationInProgress = false;
            });

            Navigator.of(context).pushNamed(
              '/otp',
              arguments: {
                "phone": phoneString,
                "verificationCode": verficationID,
              },
            );

            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => OTPScreen(
            //       phone: phoneString,
            //       verificationCode: verficationID,
            //     ),
            //   ),
            // );
          }
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          print("codeAutoRetrievalTimeout is: ${verificationID}");
          // setState(() {
          //   _verificationCode = verificationID;
          // });
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => OTPScreen(
          //       phone: phoneString,
          //       verificationCode: verificationID,
          //     ),
          //   ),
          // );
          setState(() {
            _isloading = false;
          });
        },
        timeout: const Duration(seconds: 120));
  }

  @override
  Widget build(BuildContext context) {
    //
    final sharedUtility = ref.read(sharedUtilityProvider);
    final width = ScreenUtil().screenWidth;

    // ScreenUtil.init(context, designSize: const Size(393, 852));

    return Scaffold(
      backgroundColor:
          sharedUtility.isDarkModeEnabled() ? kBlackColor : kWhiteColor,
      body: SingleChildScrollView(
        child: Container(
          height: ScreenUtil().screenHeight,
          padding: EdgeInsets.symmetric(
            horizontal: 20.0.w, // Utility().getViewPaddingForTablets(context),
            vertical: 20.0.h,
          ).w,
          child: Stack(
            children: [
              Column(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    height: 40.h,
                  ),
                  AppLogoWidget(),
                  SizedBox(
                    height: 40.h,
                  ),
                  SizedBox(
                    width: (width * 0.7).w,
                    child: Text(
                      "Please provide your phone number",
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: sharedUtility.isDarkModeEnabled()
                          ? kSemiBoldTextStyleDark
                          : kSemiBoldTextStyle,
                    ),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  Text(
                    "We will need to verify your account",
                    style: sharedUtility.isDarkModeEnabled()
                        ? kRegularTextStyleDark
                        : kRegularTextStyle,
                  ),
                  SizedBox(
                    height: 40.0.h,
                  ),
                  _getPhonenumberWidget(sharedUtility),
                  Expanded(
                    child: Container(
                        // This container will take up all remaining vertical space
                        ),
                  ),
                  SizedBox(
                    height: 70.h,
                  ),
                  Text(
                    "By sigining up, you agree to our",
                    style: sharedUtility.isDarkModeEnabled()
                        ? kRegularTextStyleDark
                        : kRegularTextStyle,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  InkWell(
                      child: Text(
                        "Privacy Policy",
                        style: kSemiBoldprimaryColorTextStyleDark,
                      ),
                      onTap: () async {
                        _launchPrivacyUrl();
                      }),
                  SizedBox(
                    height: 70.h,
                  ),
                  InkWell(
                    onTap: () async {
                      if (_validateLoginDetails(enteredNumber)) {
                        await _verifyPhone(
                            phoneString: enteredNumber!.phoneNumber!);
                      } else {
                        Utility().onBasicAlertPressed(
                          context: context,
                          title: "",
                          message: _errorMessage,
                        );
                      }
                    },
                    child: Container(
                      height: 55.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(colors: [
                            kPrimary500Color,
                            kPrimary500Color,
                          ])),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          Text(
                            "Send Verification Code",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: !isMobile ? 14 : 14.sp * scaleFactor,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 30.0.w),
                            child: Image.asset(
                              "assets/up-arrow.png",
                              width: 23.w,
                              height: 27.h,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
              Visibility(
                visible: _isloading,
                child: Align(
                  alignment: Alignment.center,
                  child: AppLoadingAnimation(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _getPhonenumberWidget(SharedUtility sharedUtility) {
    return Container(
      // height: 64.0.h,
      padding: EdgeInsets.symmetric(horizontal: 8).w,
      child: InternationalPhoneNumberInput(
        focusNode: _focusNode,
        inputDecoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: sharedUtility.isDarkModeEnabled()
                    ? kWhiteColor
                    : kMediumTextColor),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: sharedUtility.isDarkModeEnabled()
                    ? kWhiteColor
                    : kMediumTextColor),
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        onInputChanged: (PhoneNumber number) async {
          print("Length ${number.parseNumber().length}");
          print("value ${number.parseNumber()}");
          enteredNumber = number;
          if (number.parseNumber().length == 10 && !_isOperationInProgress) {
            _isOperationInProgress = true;
            // _focusNode.unfocus();
            // Future.delayed(Duration(milliseconds: 500), () async {
            //   if (_validateLoginDetails(enteredNumber)) {
            //     print("verify phije");
            //     // await _verifyPhone(
            //     //   phoneString: enteredNumber!.phoneNumber!);
            //     //_isOperationInProgress = false;
            //   } else {
            //     Utility().onBasicAlertPressed(
            //       context: context,
            //       title: "",
            //       message: _errorMessage,
            //     );
            //   }
            // });
          }
        },
        onInputValidated: (bool value) {
          print("value ${value}");
        },
        selectorConfig: const SelectorConfig(
          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
          //useBottomSheetSafeArea: true,
        ),
        ignoreBlank: false,
        hintText: "Enter Phone number",
        textStyle: sharedUtility.isDarkModeEnabled()
            ? kMediumItlaicTextStyleDark
            : kMediumItlaicTextStyle,
        autoValidateMode: AutovalidateMode.disabled,
        selectorTextStyle: sharedUtility.isDarkModeEnabled()
            ? kMediumItlaicTextStyleDark
            : kMediumItlaicTextStyle,
        initialValue: enteredNumber,
        textFieldController: controller,
        formatInput: true,
        keyboardType: const TextInputType.numberWithOptions(
          signed: true,
          decimal: true,
        ),
        // inputBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(10),
        //   // borderSide: BorderSide(
        //   //     color: sharedUtility.isDarkModeEnabled()
        //   //         ? kWhiteColor
        //   //         : klightGreyColor,
        //   //     width: 0.9),
        // ),
        onSaved: (PhoneNumber number) {
          print('On Saved: $number');
        },
      ),
    );
  }

  Future<void> _launchPrivacyUrl() async {
    final Uri _url = Uri.parse('https://88f.io/privacy-policy');
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}
