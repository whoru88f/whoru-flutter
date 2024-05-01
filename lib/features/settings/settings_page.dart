import 'package:chatapp/common/utility/shared_utility.dart';
import 'package:chatapp/features/sidemenu/side_menu_provider.dart';
import 'package:chatapp/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatapp/features/common_widgets/no-internet-widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
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
    // print('show');
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
                  EdgeInsets.symmetric(horizontal: 0.0.w, vertical: 15.0.h),
              child: Column(
                children: [
                  SizedBox(
                    height: 45,
                  ),
                  Text(
                    "Settings",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: !isMobile ? 22 : 22.sp * scaleFactor,
                      color: sharedUtility.isDarkModeEnabled()
                          ? kWhiteColor
                          : kBlackColor,
                    ),
                  ),
                  SizedBox(
                    height: 20.0.h,
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      itemBuilder: (BuildContext listContext, int index) {
                        return Column(
                          children: [
                            SwitchListTileWidget(
                                toggleValue: darkModeToggleValue,
                                title: 'Dark Mode',
                                iconData: Icons.dark_mode,
                                toggleMethod: _darkModeToggled),
                            Divider(
                              indent: 20,
                              height: 0.2.h,
                              color: sharedUtility.isDarkModeEnabled()
                                  ? klightGreyColor
                                  : klightGreyColor,
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (BuildContext listContext, int index) {
                        return Divider(
                          indent: 60,
                          height: 0.2,
                          color: Colors.grey,
                        );
                      },
                      itemCount: 1,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 50,
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
      minVerticalPadding: 25.h,
      leading: ClipOval(
        child: Container(
          color: sharedUtility.isDarkModeEnabled()
              ? klightGreyBGColorDark.withOpacity(0.2)
              : klightGreyBGColor.withOpacity(0.2),
          padding: EdgeInsets.all(5.r),
          child: Icon(
            iconData,
            color: kPrimary500Color,
            size: 20.h,
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
