import 'package:chatapp/common/utility/shared_utility.dart';
import 'package:chatapp/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class AppLoadingAnimation extends ConsumerWidget {
  final double size;
  const AppLoadingAnimation({
    super.key,
    this.size = 110,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sharedUtility = ref.read(sharedUtilityProvider);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: sharedUtility.isDarkModeEnabled()
            ? kBlackColor.withOpacity(0.5)
            : kBlackColor.withOpacity(0.5), // Adjust opacity as needed
        borderRadius:
            BorderRadius.circular(15), // Adjust border radius as needed
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 85,
            height: 85,
            decoration: BoxDecoration(
              shape: BoxShape.circle, // BoxShape.circle or BoxShape.retangle
              //color: const Color(0xFF66BB6A),
              boxShadow: [
                BoxShadow(
                    color: Color.fromARGB(255, 39, 38, 38),
                    blurRadius: 12,
                    spreadRadius: 8),
              ],
            ),
            // child: Image.asset(
            //   'assets/logo.gif',
            //   fit: BoxFit.fill,
            // ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
            ),
            child: Lottie.asset('assets/loader-green.json', height: 85),
          ),
        ],
      ),
      // child: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   children: [
      //     Padding(
      //       padding: const EdgeInsets.only(
      //         left: 10.0,
      //       ),
      //       child: Lottie.asset('assets/loader-green.json', height: 85),
      //     ),
      //     // SizedBox(
      //     //   height: 5.0,
      //     // ),
      //     // Text(
      //     //   "Loading...",
      //     //   style: sharedUtility.isDarkModeEnabled()
      //     //       ? kMedium14TextStyleDark
      //     //       : kMedium14TextStyle,
      //     // )
      //   ],
      // ),
    );
  }
}
