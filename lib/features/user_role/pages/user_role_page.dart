import 'package:chatapp/common/utility/shared_utility.dart';
import 'package:chatapp/database/hive/hive_db.dart';
import 'package:chatapp/database/openai_db.dart';
import 'package:chatapp/database/recent_history/recent_user_role.dart';
import 'package:chatapp/features/common_widgets/no-internet-banner-widget.dart';
import 'package:chatapp/features/common_widgets/no-internet-widget.dart';
import 'package:chatapp/features/login/login_screen.dart';
import 'package:chatapp/features/sidemenu/side_menu_provider.dart';
import 'package:chatapp/features/prompts/services/prompt_service.dart';
import 'package:chatapp/features/common_widgets/app-loading-animation.dart';
import 'package:chatapp/features/search_question/pages/search_question_page.dart';
import 'package:chatapp/features/sync_service.dart';
import 'package:chatapp/features/common_widgets/app-logo-widget.dart';
import 'package:chatapp/features/user_role/models/user_role.dart';
import 'package:chatapp/features/user_role/pages/user_role_autocomplete_page.dart';
import 'package:chatapp/features/user_role/services/user_role_service.dart';
import 'package:chatapp/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';

void showSideMenu({
  required BuildContext context,
  required WidgetRef ref,
}) {
  print(
      'before ${ref.read(toggleSideMenuVisibiltyStateProvider.notifier).state}');

  ref.read(toggleSideMenuVisibiltyStateProvider.notifier).state =
      !ref.read(toggleSideMenuVisibiltyStateProvider.notifier).state;

  print(
      'after ${ref.read(toggleSideMenuVisibiltyStateProvider.notifier).state}');
}

class UserRolePage extends ConsumerStatefulWidget {
  const UserRolePage({super.key});
  @override
  ConsumerState<UserRolePage> createState() => _UserRolePageState();
}

class _UserRolePageState extends ConsumerState<UserRolePage> {
  final UserRoleService _userRoleService = UserRoleService();
  UserRole? searchResultUserRole;
  List<UserRole> _userRoleList = [];
  List<UserRole> _userRoleExampleList = [];
  List<UserRole> _userRecentRoleList = [];

  @override
  void initState() {
    super.initState();
    fetchUserRoles();
  }

  Future<void> fetchUserRoles() async {
    var tmpUserRoleList = await _userRoleService.getAllRoles() ?? [];
    print("tmpUserRoleList ${tmpUserRoleList.length}");
    var tmpUserRoleExampleList = await _userRoleService.getExampleRoles() ?? [];
    print("tmpUserRoleExampleList ${tmpUserRoleExampleList.length}");
    var tmpUserRecentRoleList = await HiveDB.instance.readAllRecentUserRoles();

    setState(() {
      _userRoleList = tmpUserRoleList;
      _userRecentRoleList = tmpUserRecentRoleList;
      _userRoleExampleList = tmpUserRoleExampleList;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sharedUtility = ref.read(sharedUtilityProvider);
    return Scaffold(
      backgroundColor:
          sharedUtility.isDarkModeEnabled() ? kBlackColor : kWhiteColor,
//backgroundColor: Colors.orange,
      body: SafeArea(
        //top: false,

        child: Stack(
          alignment: Alignment.topLeft,
          children: <Widget>[
            // SingleChildScrollView(
            //   child:
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
              ),
              height: ScreenUtil().screenHeight,
              child: Column(
                children: [
                  SizedBox(
                    height: 45.h,
                  ),
                  AppLogoWidget(),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "Who would you like to be today?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: !isMobile ? 21 : 21.sp * scaleFactor,
                      color: sharedUtility.isDarkModeEnabled()
                          ? kWhiteColor
                          : kBlackColor,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "Search within almost 100 role types",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: !isMobile ? 16 : 16.sp * scaleFactor,
                      color: sharedUtility.isDarkModeEnabled()
                          ? kWhiteColor
                          : kMediumTextColor,
                    ),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _getSearchRoleContainer(sharedUtility, context),
                      ],
                    ),
                  ),
                  //    _getSearchRoleContainer(sharedUtility, context),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 30.h,
                      ),
                      Text(
                        "Examples",
                        textAlign: TextAlign.center,
                        style: sharedUtility.isDarkModeEnabled()
                            ? kRegularTextStyleDark
                            : kRegularTextStyle,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      _getExampleRolesList(sharedUtility),
                      SizedBox(
                          //height: 40.h,
                          ),
                    ],
                  ),
                ],
              ),
            ),
            //    ),
            _getSideMenu(context),
          ],
        ),
      ),
    );
  }

  Positioned _getSideMenu(BuildContext context) {
    return Positioned(
      top: 5,
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
    );
  }

  Future _addUserRole(UserRole? _selectedResult) async {
    final userRole = RecentUserRole(
      id: _selectedResult?.id,
      userRoleId: _selectedResult?.userRoleId ?? Uuid().v4(),
      roleName: _selectedResult?.roleName,
      isExample: _selectedResult?.isExample,
      createdTime: DateTime.now(),
    );

    print("addUserRole ${_selectedResult?.id}");

    await HiveDB.instance.createRecentUserRole(userRole);
  }

  ListView _getExampleRolesList(SharedUtility sharedUtility) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: 20.0.w,
      ),
      shrinkWrap: true,
      //  padding: EdgeInsets.zero,
      itemCount: _userRoleExampleList.length,
      itemBuilder: (context, index) {
        var userRole = _userRoleExampleList[index];
        return GestureDetector(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 0.w,
              vertical: 5.h,
            ),
            child: Text(
              userRole.roleName ?? "",
              style: sharedUtility.isDarkModeEnabled()
                  ? kRegularPrimaryColorTextStyleDark
                  : kRegularPrimaryColorTextStyle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
          onTap: () async {
            await _addUserRole(userRole);
            Navigator.of(context).push(
              MaterialPageRoute(
                // fullscreenDialog: true,
                builder: (context) => SearchQuestionPage(
                  selectedUserRole: userRole,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Container _getSearchRoleContainer(
      SharedUtility sharedUtility, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 20.0.w,
      ),
      // width: double.infinity,
      height: 54.h,
      padding: EdgeInsets.symmetric(
        horizontal: 1.0.w,
      ),
      decoration: BoxDecoration(
        color: sharedUtility.isDarkModeEnabled()
            ? kBlackColor
            : kWhiteColor, // Container background color
        borderRadius: BorderRadius.circular(15), // Adjust the radius as needed
        border: Border.all(
          color: sharedUtility.isDarkModeEnabled()
              ? kWhiteColor
              : klightGreyColor, // Border color
          width: 0.5, // Border width
        ),
        boxShadow: [
          BoxShadow(
            color: sharedUtility.isDarkModeEnabled()
                ? kBlackColor.withOpacity(0.5)
                : klightGreyColor.withOpacity(0.5), //
            spreadRadius: 0,
            blurRadius: 3,
            offset: Offset(1, 2), // changes the shadow position
          ),
        ],
      ),
      child: MaterialButton(
        onPressed: () async {
          // Add your button click logic here
          _userRecentRoleList = await HiveDB.instance.readAllRecentUserRoles();
          print("_userRecentRoleList ${_userRecentRoleList.length}");
          print("_userRoleList ${_userRoleList.length}");

          final selectedResult = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => UserRoleAutocompletePage(
                listExample: _userRoleList,
                recentRoleList: _userRecentRoleList,
                onResultSelected: (result) {},
              ),
            ),
          );
          if (selectedResult != null && selectedResult is UserRole) {
            searchResultUserRole = selectedResult as UserRole;
            Future.delayed(Duration(milliseconds: 200), () {
              setState(() {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SearchQuestionPage(
                      selectedUserRole: searchResultUserRole,
                    ),
                  ),
                );
              });
            });
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              "assets/search-icon.png",
              height: 19.h,
            ),
            Flexible(
              child: Text(
                searchResultUserRole?.roleName ?? "Search Role",
                //style: TextStyle(color: kPrimary500Color),
                style: sharedUtility.isDarkModeEnabled()
                    ? kMedium14TextStyleDark
                    : kMedium14TextStyle,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
              ),
            ),
            Image.asset(
              "assets/mic-icon.png",
              height: 27.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget _customPopupItemBuilderExample2(
      BuildContext context, UserRole item, bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item.roleName ?? ""),
        subtitle: Text(item.roleName ?? ""),
        // leading: CircleAvatar(
        //   backgroundImage: NetworkImage(item.avatar),
        // ),
      ),
    );
  }

  Widget _customDropDownSelection(
      BuildContext context, List<UserRole> selectedItems) {
    if (selectedItems.isEmpty) {
      return const ListTile(
        contentPadding: EdgeInsets.all(0),
        leading: CircleAvatar(),
        title: Text("No item selected"),
      );
    }

    return Wrap(
      children: selectedItems.map((e) {
        return Padding(
          padding: EdgeInsets.all(4.0.r),
          child: Container(
            child: ListTile(
              contentPadding: EdgeInsets.all(0.r),
              // leading: CircleAvatar(
              //   backgroundImage: NetworkImage(e.avatar),
              // ),
              title: Text(e.roleName ?? ""),
              // subtitle: Text(
              //   e.createdAt.toString(),
              // ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
