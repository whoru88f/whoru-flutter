import 'package:chatapp/common/utility/shared_utility.dart';
import 'package:chatapp/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivacyPage extends ConsumerWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sharedUtility = ref.read(sharedUtilityProvider);
    return Scaffold(
        backgroundColor:
            sharedUtility.isDarkModeEnabled() ? kBlackColor : kWhiteColor,
        // appBar: AppBar(
        //   title: const Text(
        //     "Privacy policy",
        //   ),
        // ),
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 12,
                  right: 12,
                  top: 70,
                  bottom: 20,
                ),
                child: Column(
                  children: [
                    Text(
                      """Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut felis justo, scelerisque in justo vel, finibus dictum lorem. Quisque convallis, velit eleifend lobortis molestie, quam lorem pulvinar neque, non rhoncus velit nisl id diam. Praesent vitae neque eleifend, mollis massa vel, consectetur velit. Phasellus pulvinar, elit vitae sagittis convallis, ex nibh egestas metus, et mollis dolor metus id enim. Duis quis pharetra nisl. Suspendisse in malesuada nisi. In ultricies accumsan ligula tempor ultricies. Nullam ut tortor mollis tortor egestas facilisis a nec justo. Cras imperdiet mauris ut dolor euismod consequat. Quisque diam tortor, tempor hendrerit finibus eget, aliquam pharetra nisi. Maecenas a tortor semper, varius nibh sed, ullamcorper libero. Nullam arcu lectus, viverra vitae sagittis eget, mollis vitae ex. Curabitur hendrerit elit sed enim imperdiet, sed pulvinar libero porta. Fusce mattis leo arcu, in porttitor nisi congue quis. Nulla facilisi. Nam placerat ullamcorper augue non rutrum.
          
          Phasellus eu pretium augue, eget euismod nisi. Nunc porttitor, nunc et commodo fermentum, est elit pulvinar turpis, mollis dictum nisi est id neque. Aenean elementum ante eget erat commodo commodo. Ut porttitor eget augue et sagittis. Donec turpis eros, feugiat quis orci ut, maximus tristique orci. Nulla facilisi. Duis blandit elementum mollis. Sed pharetra nunc lacus, id molestie nulla euismod non. In fermentum augue ut nunc laoreet rhoncus. Integer ullamcorper purus mi, nec pellentesque erat hendrerit nec. Integer ultrices purus in accumsan porttitor. Nam feugiat aliquam ipsum, et placerat elit ultricies accumsan. Suspendisse rhoncus suscipit sem, eget vestibulum velit commodo at. Proin volutpat scelerisque elementum. Duis accumsan tristique nisl ut mattis.
          
          Mauris aliquet neque a vestibulum facilisis. Fusce id nibh dignissim, fermentum felis non, viverra eros. Nullam sed justo gravida, interdum est dapibus, convallis neque. Donec quis bibendum augue. In hac habitasse platea dictumst. Nulla ut magna in purus ultrices venenatis vel quis elit. Maecenas quis enim massa. In rhoncus lacus vitae ligula convallis placerat. Proin elementum eros id cursus porta. Aenean id tellus ut ante condimentum bibendum ac ac risus.
          
          Vestibulum vel odio vitae orci aliquam cursus tempus id velit. Fusce mollis sapien eu lorem dictum, eget rhoncus magna sagittis. Sed nec porta nisi, eu tincidunt orci. Nunc ipsum augue, porttitor eget iaculis mattis, pharetra eu diam. Nam ut enim sit amet ligula imperdiet facilisis. Quisque vel egestas neque, rutrum dapibus erat. Etiam viverra tincidunt ex tempor fermentum. Sed ac aliquam nulla. Curabitur nisi metus, euismod ut erat non, semper facilisis nisi. Morbi ornare leo sit amet velit laoreet, sed rhoncus urna blandit.
          
          Proin ut leo aliquet, consequat turpis quis, aliquet tortor. Nulla scelerisque, nisi sit amet pharetra pellentesque, ex mauris sollicitudin dolor, eu feugiat mi diam sed nulla. Praesent condimentum, lacus sed aliquam commodo, sapien erat placerat nulla, id vestibulum justo nibh ut est. Morbi sodales ante sit amet neque maximus, condimentum gravida sapien tempus. Cras pulvinar lorem id elit semper egestas. Duis aliquam nunc tellus, ut convallis diam pulvinar non. Donec ac suscipit felis, non dignissim justo. Curabitur porttitor finibus porttitor. Sed ut dolor orci.""",
                      style: sharedUtility.isDarkModeEnabled()
                          ? kRegularTextStyleDark
                          : kRegularTextStyle,
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  height: 49.0.h,
                  width: ScreenUtil().screenWidth,
                  child: Column(
                    children: [
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: kPrimary500Color,
                            ),
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                          ),

                          // IconButton(
                          //   onPressed: () {},
                          //   icon: Icon(Icons.favorite),
                          // ),
                          // Spacer(),
                          // Text("data"),
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Privacy policy",
                                style: sharedUtility.isDarkModeEnabled()
                                    ? kSemiBold18TextStyleDark
                                    : kSemiBold18TextStyle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
