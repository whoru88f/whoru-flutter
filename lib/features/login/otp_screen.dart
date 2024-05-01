import 'package:chatapp/common/CountryNames/res/strings/tr.dart';
import 'package:chatapp/common/utility/shared_utility.dart';
import 'package:chatapp/common/utility/utility.dart';
import 'package:chatapp/features/login/auth_wrapper.dart';
import 'package:chatapp/features/common_widgets/app-loading-animation.dart';
import 'package:chatapp/features/login/login_services.dart';
import 'package:chatapp/features/user_role/pages/user_role_page.dart';
import 'package:device_info_plus/device_info_plus.dart';
// import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:chatapp/features/common_widgets/app-logo-widget.dart';
import 'package:chatapp/features/common_widgets/no-internet-widget.dart';
import '../../theme.dart';

class OTPScreen extends ConsumerStatefulWidget {
  final String phone;
  final String verificationCode;

  const OTPScreen({
    required this.phone,
    required this.verificationCode,
    super.key,
  });

  @override
  ConsumerState<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final TextEditingController _pinPutController = TextEditingController();
  String pinValue = "";
  bool _isloading = false;

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
      fontSize: !isMobile ? 20 : 20.sp * scaleFactor,
      color: kPrimary500Color,
      fontWeight: FontWeight.w600,
    ),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(20),
    ),
  );

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};
    try {
      if (!kIsWeb) {
        // print("defaultTargetPlatform $defaultTargetPlatform");
        if (defaultTargetPlatform == TargetPlatform.android) {
          deviceData =
              _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        } else if (defaultTargetPlatform == TargetPlatform.iOS) {
          deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
        }

        // print("deviceData $deviceData");
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.release': build.version.release,
      'version.baseOS': build.version.baseOS,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'serialNumber': build.serialNumber,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  @override
  Widget build(BuildContext context) {
    final sharedUtility = ref.read(sharedUtilityProvider);
    return Scaffold(
      backgroundColor:
          sharedUtility.isDarkModeEnabled() ? kBlackColor : kWhiteColor,
      key: _scaffoldkey,
      // appBar: AppBar(
      //   backgroundColor: Colors,
      //   elevation: 0,
      //   title: const Text(
      //     'Verification',
      //   ),
      // ),
      body: Stack(
        alignment: Alignment.topLeft,
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              // //  height: ScreenUtil().screenHeight,
              // padding: const EdgeInsets.all(
              //   30.0,
              // ),
              height: ScreenUtil().screenHeight,
              padding: EdgeInsets.symmetric(
                horizontal:
                    20.0.w, // Utility().getViewPaddingForTablets(context),
                vertical: 20.0.h,
              ).w,
              child: Stack(
                // alignment: Alignment.center,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 70.h,
                      ),
                      // Image.asset(
                      //   "assets/logo.gif",
                      //   height: 165,
                      // ),
                      AppLogoWidget(),
                      SizedBox(
                        height: 50.h,
                      ),
                      Text(
                        "Enter the verification code",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: !isMobile ? 22 : 22.sp * scaleFactor,
                          color: sharedUtility.isDarkModeEnabled()
                              ? kMediumTextColorDark
                              : kMediumTextColor,
                        ),
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      Text(
                        "Please input the codes we have sent",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: !isMobile ? 16 : 16.sp * scaleFactor,
                          color: sharedUtility.isDarkModeEnabled()
                              ? kMediumTextColorDark
                              : kMediumTextColor,
                        ),
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      // Padding(
                      //   // padding: const EdgeInsets.all(30.0),
                      //   child:

                      // ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _getPinPut(context),
                            SizedBox(
                              height: 20.h,
                            ),
                            TextButton(
                              onPressed: () {
                                // Add your on pressed event here
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: kPrimary500Color,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              child: Text(
                                'Resend Code',
                                style: TextStyle(fontSize: 18.h),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              "It may take few seconds for it to arrive",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: !isMobile ? 16 : 16.sp * scaleFactor,
                                color: sharedUtility.isDarkModeEnabled()
                                    ? kMediumTextColorDark
                                    : kMediumTextColor,
                              ),
                            ),
                            SizedBox(
                              height: 70.h,
                            ),
                          ],
                        ),
                      ),

                      // const SizedBox(
                      //   height: 50,
                      // ),
                      // Container(
                      //   margin: const EdgeInsets.only(top: 40),
                      //   child: Center(
                      //     child: Text(
                      //       'Verify +91-${widget.phone}',
                      //       style: const TextStyle(
                      //           fontWeight: FontWeight.bold,
                      //           color: Colors.white),
                      //     ),
                      //   ),
                      // ),
                      // Expanded(
                      //   child: Container(
                      //       // This container will take up all remaining vertical space
                      //       ),
                      // ),
                      InkWell(
                        onTap: () async {
                          print("pin value $pinValue");
                          if (pinValue.isEmpty) {
                            Utility().onBasicAlertPressed(
                              context: context,
                              message: "Please enter valid OTP value",
                            );
                          } else {
                            try {
                              await FirebaseAuth.instance
                                  .signInWithCredential(
                                      PhoneAuthProvider.credential(
                                          verificationId:
                                              widget.verificationCode,
                                          smsCode: pinValue))
                                  .then((value) async {
                                final user = value.user;
                                if (user != null) {
                                  print("user is not null");
                                  // Navigator.pushAndRemoveUntil(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => UserRolePage()),
                                  //     (route) => false);

                                  // Navigator.of(context)
                                  //     .popUntil(ModalRoute.withName('/'));
                                  Navigator.pushReplacementNamed(
                                      context, '/dashboard');
                                }
                              });
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())));
                            }
                          }

                          // Navigator.of(context).pushReplacement(
                          //   MaterialPageRoute(
                          //     builder: (context) {
                          //       return const UserRolePage();
                          //     },
                          //   ),
                          // );
                        },
                        child: Container(
                          height: 50.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(colors: [
                                kPrimary500Color,
                                kPrimary500Color,
                              ])),
                          child: Center(
                            child: Text(
                              "Submit",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      !isMobile ? 14 : 14.sp * scaleFactor,
                                  fontWeight: FontWeight.bold),
                            ),
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
          Positioned(
            top: 40,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: kPrimary500Color,
                size: 27.h,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Pinput _getPinPut(BuildContext context) {
    return Pinput(
      length: 6,
      defaultPinTheme: defaultPinTheme,
      controller: _pinPutController,
      pinAnimationType: PinAnimationType.fade,

      // onCompleted: (pin) {
      //   Navigator.pushAndRemoveUntil(
      //       context,
      //       MaterialPageRoute(
      //           builder: (context) => const UserRolePage()),
      //       (route) => false);
      // }
      onChanged: (value) async {
        //  print("value is $value");
        if (value.length == 6) {
          setState(() {
            _isloading = true;
          });
          Future.delayed(Duration(milliseconds: 500), () async {
            try {
              await FirebaseAuth.instance
                  .signInWithCredential(PhoneAuthProvider.credential(
                      verificationId: widget.verificationCode,
                      smsCode: pinValue))
                  .then((value) async {
                final user = value.user;
                if (user != null) {
                  // Save user deatils
                  _deviceData["mobileNumber"] = widget.phone;

                  LoginService()
                      .addOrUpdateUser(
                          mobileNumber: "${widget.phone}", userMap: _deviceData)
                      .then(
                    (value) {
                      setState(() {
                        _isloading = false;
                      });

                      print("user addOrUpdateUser is not null");
                      // Navigator.pushAndRemoveUntil(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => UserRolePage()),
                      //     (route) => false);

                      //Navigator.of(context).popUntil(ModalRoute.withName('/'));

                      Navigator.pushReplacementNamed(context, '/dashboard');
                    },
                  );
                }
              });
            } catch (e) {
              setState(() {
                _isloading = false;
              });
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(e.toString())));
            }
          });
        }
      },
      onCompleted: (pin) async {
        print("pin valie $pin");
        //   try {
        //     await FirebaseAuth.instance
        //         .signInWithCredential(PhoneAuthProvider.credential(
        //             verificationId: _verificationCode!, smsCode: pin))
        //         .then((value) async {
        //       final user = value.user;
        //       if (user != null) {
        //         Navigator.pushAndRemoveUntil(
        //             context,
        //             MaterialPageRoute(
        //                 builder: (context) => UserRolePage()),
        //             (route) => false);
        //       }
        //     });
        //   } catch (e) {
        //     ScaffoldMessenger.of(context)
        //         .showSnackBar(SnackBar(content: Text(e.toString())));
        //   }
        pinValue = pin;
      },
    );
  }
}
