import 'package:chatapp/common/utility/shared_utility.dart';
import 'package:chatapp/features/login/curved_button_widget.dart';
import 'package:chatapp/features/login/login_screen.dart';
import 'package:chatapp/features/sidemenu/side_menu_provider.dart';
import 'package:chatapp/features/user_role/pages/user_role_page.dart';
import 'package:chatapp/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

// class SideMenuWidget extends ConsumerStatefulWidget {
//   const SideMenuWidget({super.key});

//   @override
//   ConsumerState<SideMenuWidget> createState() => _SideMenuWidgetState();
// }

// class _SideMenuWidgetState extends ConsumerState<SideMenuWidget> {
//   @override
//   void initState() {
//     super.initState();
//     print("SideMenuWidget initialized");
//   }
// late PackageInfo packageInfo;
// String version = "";
// String code = "";

// @override
// void initState() {
//   super.initState();
//   _inititializePackageInfo();
// }

// void _inititializePackageInfo() async {
//   packageInfo = await PackageInfo.fromPlatform();
//   version = packageInfo.version;
//   code = packageInfo.buildNumber;
// }

class SideMenuWidget extends ConsumerWidget {
  const SideMenuWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _totalScreenWidth = ScreenUtil().screenWidth;
    final _toggleSideMenuVisibiltyState =
        ref.watch(toggleSideMenuVisibiltyStateProvider.notifier).state;
    final sharedUtility = ref.read(sharedUtilityProvider);
    final _menuWidth = _totalScreenWidth * 0.40;
    print("_totalScreenWidth $_totalScreenWidth");
    //  print("_menuWidth $_menuWidth");

    print("MY scaleFactor $scaleFactor ");

    final _menuMaxWidth = _menuWidth < 320.0
        ? 320.0
        : (_menuWidth > 500.0)
            ? 490.0
            : _menuWidth;
    final _visibleXoffset = -0.0;

    print("_menuWidth $_menuWidth");

    // print(
    //     "_toggleSideMenuVisibiltyState ${_toggleSideMenuVisibiltyState.getShowSideMenuStatus()}");

    // final _xOffset =
    //     (_toggleSideMenuVisibiltyState.getShowSideMenuStatus() == true)
    //         ? _visibleXoffset
    //         : -(_menuWidth + 20);

    print("_toggleSideMenuVisibiltyState ${_toggleSideMenuVisibiltyState}");

    final _xOffset = (_toggleSideMenuVisibiltyState == true)
        ? _visibleXoffset
        : -(_menuMaxWidth + 90);

    print("_xOffset $_xOffset");

    final _sideMenuProvider = ref.watch(sideMenuSelectionProvider);
    final _selectedItem = _sideMenuProvider.getSelectedMenuItem();
    //final _utility = ref.read(utilityProvider);

    return GestureDetector(
      // Set up the swipe gesture
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          // Swiped right
          print('Swiped right side menu!');
          _showSideMenu(context: context, ref: ref);
        } else if (details.primaryVelocity! < 0) {
          // Swiped left
          print('Swiped left side menu!');
          _hideSideMenu(context: context, ref: ref);
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        transform: Matrix4.translationValues(_xOffset, 0, 3),
        child: Container(
          padding: EdgeInsets.only(
            top: 45.0.h,
            bottom: 25.0.h,
            left: 10.0.w,
          ),
          child: Container(
            width: _menuMaxWidth,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(15.0.r),
              ),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.bottomCenter,
                colors: [
                  kPrimary500Color,
                  kPrimary500Color,
                  kPrimary500Color,
                  kPrimary500Color,
                  kPrimary500Color,
                  kPrimary500Color,
                  kPrimary500Color,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: sharedUtility.isDarkModeEnabled()
                      ? kBlackColor
                      : Colors.grey.withOpacity(0.8),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(2, 4), // changes the shadow position
                ),
              ],
            ),
            child: Column(
              children: [
                Flexible(
                  flex: 2,
                  child: Container(
                    child: InkWell(
                      child: Column(
                        children: [
                          // Row(
                          //   children: [
                          //     Spacer(),
                          //     Container(
                          //       margin: const EdgeInsets.only(
                          //         top: 10.0,
                          //         right: 10.0,
                          //       ),
                          //       child: CurvedButtonWidget(
                          //         iconName: Icons.arrow_back_ios_ios,
                          //         onTap: () =>
                          //             _hideSideMenu(context: context, ref: ref),
                          //         size: 35.0,
                          //         iconSize: 23.0,
                          //         leadingOffset: 5.0,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          SizedBox(
                            height: 60.h,
                          ),
                          Expanded(
                              child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape
                                    .circle, // BoxShape.circle or BoxShape.retangle
                                //color: const Color(0xFF66BB6A),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.white,
                                      blurRadius: 70.0,
                                      spreadRadius: 20.0),
                                ]),
                            // child: Image.asset(
                            //   'assets/logo.gif',
                            //   fit: BoxFit.fill,
                            // ),
                            child: Image.asset(
                              'assets/icon-83.png',
                              fit: BoxFit.fill,
                            ),
                          )),
                        ],
                      ),
                      onTap: () {
                        _selectItemtap(
                            context: context,
                            sideMenuItem: SideMenuItem.home,
                            ref: ref);
                      },
                    ),
                  ),
                ),
                Flexible(
                  flex: 8,
                  child: Container(
                    child: buildMenuItemsListView(_selectedItem, context, ref),
                  ),
                ),
                FittedBox(
                  // flex: 1,
                  child: FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (BuildContext context,
                        AsyncSnapshot<PackageInfo> snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          height: 40.h,
                          child: Column(
                            children: [
                              Spacer(),
                              kIsWeb
                                  ? Text(
                                      '© 88F, Inc 2024',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color: kWhiteColor,
                                      ),
                                    )
                                  : Text(
                                      'App Version: ${snapshot.data!.version}(${snapshot.data!.buildNumber})',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color: kWhiteColor,
                                      ),
                                    ),
                              SizedBox(
                                height: 10.0.h,
                              ),
                            ],
                          ),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  ListView buildMenuItemsListView(
      SideMenuItem _selectedItem, BuildContext context, WidgetRef ref) {
    return ListView(
      children: [
        _RowTileWidget(
          isSelected: _selectedItem == SideMenuItem.home,
          tileIcon: Icons.people,
          title: 'User Roles',
          sideMenuItemTap: () => _selectItemtap(
              context: context, sideMenuItem: SideMenuItem.home, ref: ref),
        ),
        SizedBox(
          height: 15.0.h,
        ),
        _RowTileWidget(
          isSelected: _selectedItem == SideMenuItem.favourites,
          tileIcon: Icons.favorite,
          title: 'Favorites',
          sideMenuItemTap: () => _selectItemtap(
            context: context,
            ref: ref,
            sideMenuItem: SideMenuItem.favourites,
          ),
        ),
        SizedBox(
          height: 15.0.h,
        ),
        _RowTileWidget(
          isSelected: _selectedItem == SideMenuItem.settings,
          tileIcon: Icons.settings,
          title: 'Settings',
          sideMenuItemTap: () => _selectItemtap(
            context: context,
            ref: ref,
            sideMenuItem: SideMenuItem.settings,
          ),
        ),
        SizedBox(
          height: 15.0.h,
        ),
        _RowTileWidget(
            isSelected: _selectedItem == SideMenuItem.privacy,
            tileIcon: Icons.privacy_tip,
            title: 'Privacy Policy',
            sideMenuItemTap: () {
              _launchPrivacyUrl();
              _hideSideMenu(
                context: context,
                ref: ref,
              );
            }),
        SizedBox(
          height: 15.0.h,
        ),
        _RowTileWidget(
            isSelected: _selectedItem == SideMenuItem.privacy,
            tileIcon: Icons.email,
            title: 'Feedback & Support',
            sideMenuItemTap: () {
              _launchMail();
              _hideSideMenu(
                context: context,
                ref: ref,
              );
            }),
        SizedBox(
          height: 15.0.h,
        ),
        _RowTileWidget(
            isSelected: _selectedItem == SideMenuItem.share,
            tileIcon: Icons.share,
            title: 'Share',
            sideMenuItemTap: () {
              _shareApp();
              // _hideSideMenu(
              //   context: context,
              //   ref: ref,
              // );
            }),
        SizedBox(
          height: 15.0.h,
        ),
        _RowTileWidget(
            isSelected: _selectedItem == SideMenuItem.logout,
            tileIcon: Icons.logout,
            title: 'Logout',
            sideMenuItemTap: () {
              _signOut().whenComplete(() => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false));
            }),
      ],
    );
  }

  Future<void> _launchPrivacyUrl() async {
    final Uri _url = Uri.parse('https://88f.io/privacy-policy');
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  Future<void> _launchMail() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'support@88f.io',
    );
    // String url = params.toString();
    if (await canLaunchUrl(params)) {
      await launchUrl(params);
    } else {
      print('Could not launch ${params.path}');
    }
  }

  void _shareApp() {
    Share.share('Check out our awesome app: https://yourappstorelink.com');
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }
  //Private Functions

  void _showSideMenu({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    // print('show');
    ref.read(toggleSideMenuVisibiltyStateProvider.notifier).state = true;
  }

  void _hideSideMenu({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    // print('show');
    ref.read(toggleSideMenuVisibiltyStateProvider.notifier).state = false;
  }

  void _selectItemtap({
    required BuildContext context,
    required WidgetRef ref,
    required SideMenuItem sideMenuItem,
  }) {
    ref.read(sideMenuSelectionProvider).setSelectedMenuItem(item: sideMenuItem);
    _hideSideMenu(
      context: context,
      ref: ref,
    );
  }
}

//Private Widgets
class _RowTileWidget extends ConsumerWidget {
  final IconData tileIcon;
  final String title;
  final bool isSelected;
  final Function sideMenuItemTap;

  const _RowTileWidget({
    required this.tileIcon,
    required this.title,
    required this.sideMenuItemTap,
    required this.isSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef watch) {
    return InkWell(
      onTap: () => sideMenuItemTap(),
      child: Container(
        padding: EdgeInsets.only(
          left: 20.0.w,
          right: 20.0.w,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  tileIcon,
                  color: isSelected ? Colors.white : Colors.white54,
                  size: 25.0.h,
                ),
                SizedBox(
                  width: 15.0,
                ),
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white54,
                    fontWeight: FontWeight.normal,
                    fontSize: !isMobile ? 16 : 16.sp * scaleFactor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            SizedBox(
              height: 10.0.h,
            ),
            Divider(
              indent: 32.0,
              color: isSelected ? Colors.white : Colors.white54,
            ),
          ],
        ),
      ),
    );
  }
}
