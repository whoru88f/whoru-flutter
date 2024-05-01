import 'package:chatapp/common/utility/shared_utility.dart';
import 'package:chatapp/features/Privacy/Views/privacy_page.dart';
import 'package:chatapp/features/Privacy/Views/side_menu_privacy_page.dart';
import 'package:chatapp/features/common_widgets/app-loading-animation.dart';
import 'package:chatapp/features/favorites/favorite_page.dart';
import 'package:chatapp/features/favorites/favorites.dart';
import 'package:chatapp/features/login/dashboard_page.dart';
import 'package:chatapp/features/login/login_screen.dart';
import 'package:chatapp/features/sidemenu/side_menu_page_widget.dart';
import 'package:chatapp/features/sidemenu/side_menu_provider.dart';
import 'package:chatapp/features/settings/settings_page.dart';
import 'package:chatapp/features/user_role/pages/user_role_page.dart';
import 'package:chatapp/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class AuthenticationWrapper extends ConsumerStatefulWidget {
  const AuthenticationWrapper({super.key});

  @override
  ConsumerState<AuthenticationWrapper> createState() =>
      _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends ConsumerState<AuthenticationWrapper> {
  //Favorites? searchResultCountryFavorites;
  //late List<Favorites> _recentFavoriteList;
  // String swipeDirection = 'Swipe me!';

  // late Connectivity _connectivity;

  // bool showNoInternetBanner = false;

  @override
  void initState() {
    super.initState();
    // _connectivity = Connectivity();
    // _listenForConnection();
  }

  // void _listenForConnection() {
  //   _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
  //     print("result $result");
  //     if (result == ConnectivityResult.none) {
  //       // Show Snackbar when there is no internet connection
  //       // Fluttertoast.showToast(
  //       //   msg: "No Internet Connection",
  //       //   timeInSecForIosWeb: 4,
  //       //   toastLength: Toast.LENGTH_LONG,
  //       //   gravity: ToastGravity.BOTTOM,
  //       //   backgroundColor: Colors.red,
  //       //   textColor: Colors.white,
  //       // );

  //       // ScaffoldMessenger.of(context).showSnackBar(
  //       //   SnackBar(
  //       //     content: Text('No Internet Connection.'),
  //       //     behavior: SnackBarBehavior.fixed, // Make Snackbar persistent
  //       //     action: SnackBarAction(
  //       //       label: 'Close',
  //       //       onPressed: () {
  //       //         ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //       //       },
  //       //     ),
  //       //   ),
  //       // );

  //       if (showNoInternetBanner == false) {
  //         setState(() {
  //           showNoInternetBanner = true;
  //         });
  //       }
  //     } else {
  //       if (showNoInternetBanner == true) {
  //         setState(() {
  //           showNoInternetBanner = false;
  //         });
  //       }
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return _buildLayout(context);
  }

  Widget _buildLayout(BuildContext context) {
    final sharedUtility = ref.read(sharedUtilityProvider);
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {
        //  print("authStateChanges ${_auth.authStateChanges()}");
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          print("User uid ${user?.uid}");
          print("User phoneNumber ${user?.phoneNumber}");
          if (user == null) {
            // User is not logged in, show the login screen
            return Scaffold(
              backgroundColor:
                  sharedUtility.isDarkModeEnabled() ? kBlackColor : kWhiteColor,
              body: LoginScreen(),
              //  Stack(
              //   children: [
              //     LoginScreen(),
              //     // Align(
              //     //   alignment: Alignment.bottomCenter,
              //     //   child: Visibility(
              //     //     visible: showNoInternetBanner,
              //     //     child: Container(
              //     //       height: 60,
              //     //       color: Color.fromARGB(255, 211, 78, 68),
              //     //       child: Center(
              //     //         child: Text(
              //     //           "Please Check your Internet Connection",
              //     //           style: TextStyle(
              //     //             color: Colors.white,
              //     //           ),
              //     //         ),
              //     //       ),
              //     //     ),
              //     //   ),
              //     // ),
              //   ],
              // ),
            );
          } else {
            // User is logged in, show the main app content

            return DashboardPage();
            // return ProviderScope(
            //   //parent: ProviderScope.containerOf(context),
            //   child: DashboardPage(),
            // );
            //return getHomeWidget(context, ref);
          }
          //return getHomeWidget(context, ref);
        } else {
          // Loading state, show a loading indicator if needed
          return Scaffold(
            backgroundColor:
                sharedUtility.isDarkModeEnabled() ? kBlackColor : kWhiteColor,
            body: Center(
              child: AppLoadingAnimation(),
            ),
          );
        }
      },
    );
  }
}
/*
  void _showSideMenu({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    print("_showSideMenu called");
    setState(() {
      ref.read(toggleSideMenuVisibiltyStateProvider.notifier).state = true;
    });
  }

  void _hideSideMenu({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    setState(() {
      ref.read(toggleSideMenuVisibiltyStateProvider.notifier).state = false;
    });
  }

  Widget getHomeWidget(BuildContext context, WidgetRef ref) {
    // final _reachabilityManagerProvider = watch(reachabilityManagerProvider);
    // print('_reachabilityManagerProvider ${_reachabilityManagerProvider}');
    // final _isVisible =
    //     (context.read(reachabilityManagerProvider.notifier).state ==
    //             ReachabilityState.noInternet)
    //         ? true
    //         : false;
    final sharedUtility = ref.read(sharedUtilityProvider);
    final toggleSideMenuVisibiltyStatelisteber =
        ref.watch(toggleSideMenuVisibiltyStateProvider);
    return Scaffold(
      backgroundColor:
          sharedUtility.isDarkModeEnabled() ? kBlackColor : kWhiteColor,
      body: Container(
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                if (ref
                        .read(toggleSideMenuVisibiltyStateProvider.notifier)
                        .state ==
                    true) {
                  print('Tapped');
                  _hideSideMenu(context: context, ref: ref);
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                }
              },
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! > 0) {
                  // Swiped right
                  print('Swiped right!');
                  _showSideMenu(context: context, ref: ref);
                } else if (details.primaryVelocity! < 0) {
                  // Swiped left
                  print('Swiped left!');
                  _hideSideMenu(context: context, ref: ref);
                }
              },
              child: _getCurrenTopViewPageWidget(context, ref),
            ),
            // SideMenuWidget(ref: ref),

            SideMenuWidget(),
            // ProviderScope(
            //   parent: ProviderScope.containerOf(context),
            //   child: SideMenuWidget(),
            // ),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Visibility(
            //     visible: showNoInternetBanner,
            //     child: Container(
            //       height: 60,
            //       color: Color.fromARGB(255, 211, 78, 68),
            //       child: Center(
            //         child: Text(
            //           "Please Check your Internet Connection",
            //           style: TextStyle(
            //             color: Colors.white,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _getCurrenTopViewPageWidget(BuildContext contex, WidgetRef ref) {
    final _sideMenuProvider = ref.watch(sideMenuSelectionProvider);
    final _selectedItem = _sideMenuProvider.getSelectedMenuItem();
    switch (_selectedItem) {
      case SideMenuItem.home:
        // print('DashboardPageWidget called');
        return UserRolePage();
      case SideMenuItem.favourites:
        return FavoritesPage();
      case SideMenuItem.logout:
        return FavoritesPage();
      case SideMenuItem.feedback:
        return FavoritesPage();
      case SideMenuItem.share:
        return FavoritesPage();
      case SideMenuItem.settings:
        return SettingsPage();

      case SideMenuItem.privacy:
        return SideMenuPrivacyPage();

      // showSearch(
      //   context: context,
      //   delegate: FavoritesPageAutocomplete(
      //     listExample: _countryList,
      //     onResultSelected: (result) {
      //       // Handle the selected result here
      //       print("RESULT ${result.displayName}");
      //       setState(() {
      //         searchResultCountry = result;
      //       });
      //     },
      //   ),

      // case SideMenuItem.breeds:
      //   return BreedsPageWidget();
      // case SideMenuItem.favourites:
      //   context.refresh(favoritesFetchProvider);
      //   return FavoritesPageWidget();
      // case SideMenuItem.upload:
      //   return MyUploadsPageWidget();
      // case SideMenuItem.help:
      //   return HelpSupportPageWidget();
      // default:
      //   return BreedsPageWidget();
    }
  }
}
*/