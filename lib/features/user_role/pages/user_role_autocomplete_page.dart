import 'package:chatapp/common/utility/shared_utility.dart';
import 'package:chatapp/database/hive/hive_db.dart';
import 'package:chatapp/database/openai_db.dart';
import 'package:chatapp/database/recent_history/recent_user_role.dart';
import 'package:chatapp/features/common_widgets/no-internet-banner-widget.dart';
import 'package:chatapp/features/user_role/models/user_role.dart';
import 'package:chatapp/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:uuid/uuid.dart';
import 'package:chatapp/features/common_widgets/no-internet-widget.dart';

class UserRoleAutocompletePage extends ConsumerStatefulWidget {
  final Function(UserRole) onResultSelected;
  final List<UserRole> listExample;
  final List<UserRole> recentRoleList;

  UserRoleAutocompletePage(
      {required this.listExample,
      required this.recentRoleList,
      required this.onResultSelected,
      super.key});

  @override
  ConsumerState<UserRoleAutocompletePage> createState() =>
      _UserRoleAutocompletePageState();
}

class _UserRoleAutocompletePageState
    extends ConsumerState<UserRoleAutocompletePage> {
  TextEditingController _searchController = TextEditingController();
  bool _showClearButton = false;

  UserRole? _selectedResult;

  List<UserRole> suggestions = [];

  final SpeechToText _speechToText = SpeechToText();

  bool _speechEnabled = false;
  String _wordsSpoken = "";
  double _confidenceLevel = 0;

  @override
  void initState() {
    super.initState();
    initSpeech();
    loadSuggestions();
  }

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
    _stopListening();
  }

  void _startListening() async {
    await _speechToText.listen(
      onResult: _onSpeechResult,
      // localeId: " en-US",
    );
    setState(() {
      _confidenceLevel = 0;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(result) {
    setState(() {
      _wordsSpoken = "${result.recognizedWords}";
      _confidenceLevel = result.confidence;
      print(_wordsSpoken);
      _searchController.text = _wordsSpoken;
    });
  }

  void loadSuggestions() {
    suggestions = widget.recentRoleList;
    //print("INitial sugg ${suggestions.length}"); //In the true case
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sharedUtility = ref.read(sharedUtilityProvider);
    return Scaffold(
      backgroundColor:
          sharedUtility.isDarkModeEnabled() ? kBlackColor : kWhiteColor,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              // SizedBox(
              //   height: 55,
              // ),
              //  NoInternetBannerWidget(),
              SizedBox(
                height: 10.0.h,
              ),
              Container(
                height: 54.0.h,
                margin: EdgeInsets.symmetric(
                  horizontal: 15.0,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 1.0,
                ),
                decoration: BoxDecoration(
                  color: sharedUtility.isDarkModeEnabled()
                      ? kBlackColor
                      : kWhiteColor, // Container background color
                  borderRadius:
                      BorderRadius.circular(15), // Adjust the radius as needed
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      iconSize: 22.h,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: kPrimary500Color,
                      ),
                    ),
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: TextField(
                          controller: _searchController,
                          autofocus: true,
                          textInputAction: TextInputAction.search,
                          onChanged: (query) {
                            // Update the suggestions based on the query.

                            setState(() {
                              _showClearButton = query.isNotEmpty;
                              suggestions = getSuggestions(query);
                            });
                          },
                          onSubmitted: (query) {
                            // Handle the submission (search button press).
                            _stopListening();
                            handleSearchButtonPress(query);
                          },
                          style: TextStyle(
                              color: kPrimary500Color,
                              fontSize: !isMobile ? 14 : 14.sp * scaleFactor),
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: !isMobile ? 14 : 14.sp * scaleFactor),
                            labelStyle: TextStyle(
                                color: Colors.white,
                                fontSize: !isMobile ? 14 : 14.sp * scaleFactor),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    _showClearButton
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _showClearButton = false;
                              });
                            },
                          )
                        : SizedBox(),
                    IconButton(
                      icon: Icon(
                        _speechToText.isNotListening
                            ? Icons.mic_off
                            : Icons.mic,
                        color: kPrimary500Color,
                        size: 22.h,
                      ),
                      onPressed: _speechToText.isListening
                          ? _stopListening
                          : _startListening,
                    ),
                  ],
                ),
              ),
              Visibility(
                visible:
                    suggestions.isEmpty && _searchController.text.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    "Please click on search to continue",
                    style: sharedUtility.isDarkModeEnabled()
                        ? kRegularTextStyleDark
                        : kRegularTextStyle,
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 15.0,
                ),
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ListView.builder(
                  itemCount: suggestions.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 5.0,
                            ),
                            child: Text(
                              suggestions[index].roleName ?? "",
                              style: sharedUtility.isDarkModeEnabled()
                                  ? kRegularTextStyleDark
                                  : kRegularTextStyle,
                            ),
                          ),
                          Divider(
                            indent: 5,
                            color: sharedUtility.isDarkModeEnabled()
                                ? klightGreyColor
                                : klightGreyColor,
                          ),
                        ],
                      ),
                      onTap: () {
                        _selectedResult = suggestions[index];
                        // showResults(context);
                        //  onResultSelected(selectedResult);
                        //  close(context, selectedResult);
                        _addOrUpdateNote(context);
                      },
                    );
                  },
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  List<UserRole> getSuggestions(String query) {
    // Filter the suggestions based on the query.
    List<UserRole> tmpSuggestions = [];
    print("query $query");
    print("suggestions ${suggestions.length}");
    // return suggestions
    //     .where((suggestion) =>
    //         suggestion.toLowerCase().contains(query.toLowerCase()))
    //     .toList();

    query.isEmpty
        ? tmpSuggestions = widget.recentRoleList //In the true case
        : tmpSuggestions.addAll(widget.listExample.where(
            // In the false case
            (element) => (element.roleName ?? "")
                .toLowerCase()
                .contains(query.toLowerCase()),
          ));
    return tmpSuggestions;
  }

  void handleSearchButtonPress(String query) {
    // Perform an action when the search button is pressed on the keyboard.
    print('Search button pressed with query: $query');

    if (query.isNotEmpty) {
// add a new recent
      var userRole = UserRole(
          id: Uuid().v1(),
          userRoleId: "",
          roleName: query,
          isExample: 0,
          createdTime: DateTime.now());
      _selectedResult = userRole;

      _addOrUpdateNote(context);
    }
  }

  void _addOrUpdateNote(BuildContext context) async {
    //  final isValid = _formKey.currentState!.validate();

    // if (isValid) {

    print("_addOrUpdateNote ${_selectedResult?.id}");

    if (_selectedResult != null && _selectedResult?.id != null) {
      final isRoleExistsInDB =
          await HiveDB.instance.containsRecentUserRole(_selectedResult!.id!);

      if (isRoleExistsInDB > 0) {
        // await updateRecentRole();
        // widget.onResultSelected(_selectedResult!);

        Navigator.pop(context, _selectedResult);
      } else {
        await addUserRole();
        //widget.onResultSelected(_selectedResult!);
        Navigator.pop(context, _selectedResult);
      }

      //  }
    }
  }

  // Future updateNote() async {
  //   final note = widget.note!.copy(
  //     isImportant: isImportant,
  //     number: number,
  //     title: title,
  //     description: description,
  //   );

  //   await NotesDatabase.instance.update(note);
  // }

  Future addUserRole() async {
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
}
