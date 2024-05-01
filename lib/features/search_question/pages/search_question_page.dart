import 'package:chatapp/common/utility/shared_utility.dart';
import 'package:chatapp/database/hive/hive_db.dart';
import 'package:chatapp/database/openai_db.dart';
import 'package:chatapp/database/recent_history/recent_user_role.dart';
import 'package:chatapp/features/common_widgets/app-logo-widget.dart';

import 'package:chatapp/features/search_question/model/question.dart';

import 'package:chatapp/features/search_question/pages/serach_results_page.dart';
import 'package:chatapp/features/search_question/services/question_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/features/user_role/models/user_role.dart';
import 'package:chatapp/theme.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatapp/features/common_widgets/no-internet-widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchQuestionPage extends ConsumerStatefulWidget {
  final UserRole? selectedUserRole;
  const SearchQuestionPage({this.selectedUserRole, super.key});

  @override
  ConsumerState<SearchQuestionPage> createState() => _SearchQuestionPageState();
}

class _SearchQuestionPageState extends ConsumerState<SearchQuestionPage> {
  final _userEditTextController = TextEditingController(text: '');
  final QuestionService _QuestionService = QuestionService();
  Question? selectedQuestion;
  List<UserRole> _recentUserRoles = [];
  List<Question> _exampleQuestionList = [];

  String selectedPrompt = "";
  UserRole? _selectedRoleLocal;

  @override
  void initState() {
    super.initState();
    _selectedRoleLocal = widget.selectedUserRole;
    fetchQuestions();
    fetchPrompt();
  }

  void fetchPrompt() async {
// Fetch promopt for userIDRole
    if (_selectedRoleLocal?.userRoleId != null) {
      final fetchedPrompt = await HiveDB.instance
          .readPromptForUserRole(_selectedRoleLocal?.userRoleId ?? "");
      print("fetchedPrompt ${fetchedPrompt?.promptName}");
      selectedPrompt = fetchedPrompt?.promptName ?? "";
    }
  }

  void fetchQuestions() async {
    final tmpQuestionList = await _QuestionService.getAllQuestions();
    final tmpExampleQuestionList = await _QuestionService.getExampleQuestions();

    final tmpRecentUsersList =
        await HiveDB.instance.readLastFiveRecentUserRoles();

    setState(() {
      _exampleQuestionList = tmpExampleQuestionList;
      _recentUserRoles = tmpRecentUsersList;
    });

    print("_exampleQuestionList ${_exampleQuestionList.length}");

    _exampleQuestionList.forEach((element) {
      print("QUES--))))${element.questionName}---");
    });
  }

  @override
  Widget build(BuildContext context) {
    final sharedUtility = ref.read(sharedUtilityProvider);

    return Scaffold(
      backgroundColor:
          sharedUtility.isDarkModeEnabled() ? kBlackColor : kWhiteColor,
      // appBar: AppBar(
      //   backgroundColor: Colors,
      //   elevation: 0,
      //   title: const Text(
      //     'Verification',
      //   ),
      // ),
      body: SafeArea(
        //top: false,
        child: Stack(
          alignment: Alignment.topLeft,
          children: <Widget>[
            // SingleChildScrollView(
            //   child:
            Container(
              height: ScreenUtil().screenHeight,
              padding: EdgeInsets.symmetric(
                horizontal: 25.w,
                vertical: 10.h,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    // _selectedRoleLocal?.roleName ?? "--",
                    "Welcome!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: !isMobile ? 26 : 26.sp * scaleFactor,
                        color: sharedUtility.isDarkModeEnabled()
                            ? kWhiteColor
                            : kBlackColor),
                  ),
                  SizedBox(
                    height: 10.0.h,
                  ),
                  Text(
                    _selectedRoleLocal?.roleName ?? "--",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16.sp,
                        color: kPrimary500Color),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  TextButton(
                    onPressed: () {
                      // Add your on pressed event here
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: kPrimary500Color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Text(
                      'Change Role ?',
                      style: sharedUtility.isDarkModeEnabled()
                          ? kSemiBoldWhiteolorTextStyle
                          : kSemiBoldBlackColorTextStyle,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  // Image.asset(
                  //   "assets/logo.gif",
                  //   height: 165,
                  // ),
                  // AppLogoWidget(),
                  //  AppLogoWidget(),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: (_recentUserRoles.length > 0),
                          child: Text(
                            "Recent Roles",
                            textAlign: TextAlign.center,
                            style: sharedUtility.isDarkModeEnabled()
                                ? TextStyle(
                                    fontSize:
                                        !isMobile ? 14 : 14.sp * scaleFactor,
                                    fontWeight: kRegular,
                                    color: kMediumTextColorDark,
                                  )
                                : TextStyle(
                                    fontSize:
                                        !isMobile ? 15 : 15.sp * scaleFactor,
                                    fontWeight: kRegular,
                                    color: kMediumTextColor,
                                  ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: _recentUserRoles.length,
                          itemBuilder: (context, i) {
                            var currQuestion = _recentUserRoles[i];
                            return GestureDetector(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5.0.w,
                                  vertical: 3.0.h,
                                ),
                                child: Text(
                                  currQuestion.roleName ?? "",
                                  style: sharedUtility.isDarkModeEnabled()
                                      ? kRegularPrimaryColorTextStyleDark
                                      : kRegularPrimaryColorTextStyle,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  _selectedRoleLocal = currQuestion;
                                });

                                // selectedQuestion = currQuestion;
                                // Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //     builder: (context) {
                                //       return SearchResultsPage(
                                //         selectedUserRole:
                                //             _selectedRoleLocal?.roleName ?? "",
                                //         selectedQuestion:
                                //             selectedQuestion?.questionName ?? "",
                                //       );
                                //     },
                                //   ),
                                // );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "Examples",
                    textAlign: TextAlign.center,
                    style: sharedUtility.isDarkModeEnabled()
                        ? kRegularTextStyleDark
                        : kRegularTextStyle,
                  ),

                  ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: _exampleQuestionList.length,
                    itemBuilder: (context, i) {
                      var currQuestion = _exampleQuestionList[i];
                      return GestureDetector(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 3.h,
                          ),
                          child: Text(
                            currQuestion.questionName ?? "",
                            style: sharedUtility.isDarkModeEnabled()
                                ? kRegularPrimaryColorTextStyleDark
                                : kRegularPrimaryColorTextStyle,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),
                        ),
                        onTap: () {
                          // selectedQuestion = currQuestion;
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) {
                          //       return SearchResultsPage(
                          //         selectedUserRole:
                          //             _selectedRoleLocal?.roleName ?? "",
                          //         selectedQuestion:
                          //             selectedQuestion?.questionName ?? "",
                          //       );
                          //     },
                          //   ),
                          // );
                        },
                      );
                    },
                  ),
                  SizedBox(
                    height: 20.0.h,
                  ),
                  Container(
                    width: double.infinity,
                    height: 54.h,
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.0.w,
                    ),
                    decoration: BoxDecoration(
                      color: sharedUtility.isDarkModeEnabled()
                          ? kBlackColor
                          : kWhiteColor, // Container background color
                      borderRadius: BorderRadius.circular(
                          15), // Adjust the radius as needed
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
                        print("selectedPrompt ${selectedPrompt}");

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return SearchResultsPage(
                                selectedUserRole:
                                    _selectedRoleLocal?.roleName ?? "",
                                suppliedPrompt: selectedPrompt,
                                selectedQuestion: "",
                              );
                            },
                          ),
                        );
                      },
                      // style: OutlinedButton.styleFrom(
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(
                      //         15.0), // Adjust the border radius as needed
                      //   ),
                      //   side: const BorderSide(
                      //     color: Colors.grey,
                      //     width: 1,
                      //   ), // Border color and width
                      // ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 5.0.w),
                            child: Image.asset(
                              "assets/search-icon.png",
                              height: 19.h,
                            ),
                          ),
                          //Spacer(),
                          Flexible(
                            child: Container(
                              child: Text(
                                selectedQuestion?.questionName ??
                                    "Ask Anything",
                                style: sharedUtility.isDarkModeEnabled()
                                    ? kMedium14TextStyleDark
                                    : kMedium14TextStyle,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                softWrap: false,
                              ),
                            ),
                          ),
                          //  Spacer(),
                          Padding(
                            padding: EdgeInsets.only(left: 5.0.w),
                            child: Image.asset(
                              "assets/mic-icon.png",
                              height: 27.h,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                      // height: 25.h,
                      ),
                ],
              ),
            ),
            //  ),
            Positioned(
              top: 5.h,
              left: 5.w,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios,
                    size: 22.h,
                    color: sharedUtility.isDarkModeEnabled()
                        ? kWhiteColor
                        : kBlackColor),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _customPopupItemBuilderExample2(
  //     BuildContext context, UserRole item, bool isSelected) {
  //   return Container(
  //     margin: EdgeInsets.symmetric(horizontal: 8),
  //     decoration: !isSelected
  //         ? null
  //         : BoxDecoration(
  //             border: Border.all(color: Theme.of(context).primaryColor),
  //             borderRadius: BorderRadius.circular(5),
  //             color: Colors.white,
  //           ),
  //     child: ListTile(
  //       selected: isSelected,
  //       title: Text(item.roleName ?? ""),
  //       subtitle: Text(item.roleName ?? ""),
  //       // leading: CircleAvatar(
  //       //   backgroundImage: NetworkImage(item.avatar),
  //       // ),
  //     ),
  //   );
  // }

  // Widget _customDropDownSelection(
  //     BuildContext context, List<UserRole> selectedItems) {
  //   if (selectedItems.isEmpty) {
  //     return ListTile(
  //       contentPadding: EdgeInsets.all(0),
  //       leading: CircleAvatar(),
  //       title: Text("No item selected"),
  //     );
  //   }

  //   return Wrap(
  //     children: selectedItems.map((e) {
  //       return Padding(
  //         padding: const EdgeInsets.all(4.0),
  //         child: Container(
  //           child: ListTile(
  //             contentPadding: EdgeInsets.all(0),
  //             // leading: CircleAvatar(
  //             //   backgroundImage: NetworkImage(e.avatar),
  //             // ),
  //             title: Text(e.roleName ?? ""),
  //             // subtitle: Text(
  //             //   e.createdAt.toString(),
  //             // ),
  //           ),
  //         ),
  //       );
  //     }).toList(),
  //   );
  // }
}
