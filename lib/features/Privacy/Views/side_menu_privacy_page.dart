import 'package:chatapp/common/utility/shared_utility.dart';
import 'package:chatapp/features/sidemenu/side_menu_provider.dart';
import 'package:chatapp/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SideMenuPrivacyPage extends ConsumerStatefulWidget {
  const SideMenuPrivacyPage({Key? key}) : super(key: key);

  @override
  _SideMenuPrivacyPageState createState() => _SideMenuPrivacyPageState();
}

class _SideMenuPrivacyPageState extends ConsumerState<SideMenuPrivacyPage> {
  bool darkModeToggleValue = false;

  @override
  void initState() {
    super.initState();
    final sharedUtility = ref.read(sharedUtilityProvider);
    // setState(() {
    darkModeToggleValue = sharedUtility.isDarkModeEnabled();
    //});
  }

  void showSideMenu({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    ref.read(toggleSideMenuVisibiltyStateProvider.notifier).state = true;
  }

  @override
  Widget build(BuildContext context) {
    final sharedUtility = ref.read(sharedUtilityProvider);
    return Scaffold(
      backgroundColor:
          sharedUtility.isDarkModeEnabled() ? kBlackColor : kWhiteColor,
      // appBar: AppBar(
      //   title: Text("Settings"),
      //   leading: IconButton(
      //           icon: const Icon(Icons.menu),
      //           color: kPrimary500Color,
      //           onPressed: () {
      //             showSideMenu(context: context, ref: ref);
      //           },
      //         ),
      // ),

      body: SafeArea(
        top: false,
        child: Stack(
          alignment: Alignment.topLeft,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 12,
                  right: 12,
                  top: 10,
                  bottom: 20,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 45.0,
                    ),
                    Text(
                      "Privacy Policy",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: !isMobile ? 20 : 20.sp * scaleFactor,
                        color: sharedUtility.isDarkModeEnabled()
                            ? kWhiteColor
                            : kBlackColor,
                      ),
                    ),
                    SizedBox(
                      height: 20.0.h,
                    ),
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
            ),
            Positioned(
              top: 45,
              left: 5,
              child: IconButton(
                icon: Icon(
                  Icons.menu,
                  size: 27.h,
                ),
                color: kPrimary500Color,
                onPressed: () {
                  showSideMenu(context: context, ref: ref);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _darkModeToggled(bool value) {
    final sharedUtility = ref.read(sharedUtilityProvider);
    setState(() {
      darkModeToggleValue = value;
      sharedUtility.setDarkModeEnabled(value);
    });
  }
}

class SwitchListTileWidget extends ConsumerWidget {
  const SwitchListTileWidget(
      {Key? key,
      required this.toggleValue,
      required this.title,
      required this.iconData,
      required this.toggleMethod})
      : super(key: key);

  final bool toggleValue;
  final String title;
  final IconData iconData;
  final void Function(bool) toggleMethod;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sharedUtility = ref.read(sharedUtilityProvider);
    return ListTile(
      minVerticalPadding: 25,
      leading: ClipOval(
        child: Container(
          color: sharedUtility.isDarkModeEnabled()
              ? klightGreyBGColorDark.withOpacity(0.2)
              : klightGreyBGColor.withOpacity(0.2),
          padding: const EdgeInsets.all(8),
          child: Icon(
            iconData,
            color: kPrimary500Color,
          ),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: !isMobile ? 17 : 17.sp * scaleFactor,
          fontWeight: FontWeight.w400,
          color: sharedUtility.isDarkModeEnabled()
              ? kWhiteColor
              : kMediumTextColor,
        ),
      ),
      trailing: Switch(
        value: toggleValue,
        onChanged: toggleMethod,
        activeColor: kPrimary500Color,
      ),
    );
  }
}
