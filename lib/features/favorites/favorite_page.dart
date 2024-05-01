import 'package:chatapp/common/CountryNames/country.dart';
import 'package:chatapp/common/utility/shared_utility.dart';
import 'package:chatapp/database/hive/hive_db.dart';
import 'package:chatapp/database/openai_db.dart';
import 'package:chatapp/features/favorites/favorite_details_page.dart';
import 'package:chatapp/features/favorites/favorites.dart';
import 'package:chatapp/features/search_question/pages/serach_results_page.dart';
import 'package:chatapp/features/sidemenu/side_menu_provider.dart';
import 'package:chatapp/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatapp/features/common_widgets/no-internet-widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavoritesPage extends ConsumerStatefulWidget {
  const FavoritesPage({super.key});

  @override
  ConsumerState<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends ConsumerState<FavoritesPage> {
  late Function(Favorites) onResultSelected;
  late List<Favorites> favoritesList;
  Favorites? _selectedResult;

  //  List<String> data = [
  //   'Apple',
  //   'Banana',
  //   'Cherry',
  //   'Date',
  //   'Elderberry',
  //   'Fig',
  //   'Grapes',
  //   'Honeydew',
  //   'Kiwi',
  //   'Lemon',
  // ];

  @override
  void initState() {
    super.initState();
    // fetchFavorites();
    Future.delayed(Duration(milliseconds: 2)).then((value) {
      fetchFavorites();
    });
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // This method will be called when the widget is inserted into the widget tree
  //   print('Second page appeared');
  //   Future.delayed(Duration(milliseconds: 2)).then((value) {
  //     fetchFavorites();
  //   });
  // }

  void fetchFavorites() async {
    var tmpFav = await HiveDB.instance.readAllFavorites();
    setState(() {
      favoritesList = tmpFav;
      print("favoritesList ${favoritesList.length}");
      onQueryChanged("");
    });
  }

  List<Favorites> searchResults = [];

  void onQueryChanged(String query) {
    setState(() {
      searchResults = favoritesList
          .where(
            (element) => ((element.questionName ?? "")
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                (element.roleName ?? "")
                    .toLowerCase()
                    .contains(query.toLowerCase())),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final sharedUtility = ref.read(sharedUtilityProvider);
    return Scaffold(
      backgroundColor:
          sharedUtility.isDarkModeEnabled() ? kBlackColor : kWhiteColor,
      body: SafeArea(
        top: false,
        child: Stack(
          alignment: Alignment.topLeft,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0).w,
              child: Column(
                children: [
                  SizedBox(
                    height: 45,
                  ),
                  Text(
                    "Favorites",
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
                  SearchBar(
                    backgroundColor: sharedUtility.isDarkModeEnabled()
                        ? MaterialStateProperty.all<Color>(kBlackColor)
                        : MaterialStateProperty.all<Color>(kWhiteColor),
                    onChanged: onQueryChanged,
                    hintText: "Search favorites",
                    textStyle: MaterialStateTextStyle.resolveWith(
                      (Set<MaterialState> states) {
                        return TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: !isMobile ? 15 : 15.sp * scaleFactor,
                          color: sharedUtility.isDarkModeEnabled()
                              ? kWhiteColor
                              : kBlackColor,
                        );
                      },
                    ),
                    hintStyle: MaterialStateTextStyle.resolveWith(
                      (Set<MaterialState> states) {
                        return TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: !isMobile ? 15 : 15.sp * scaleFactor,
                          color: sharedUtility.isDarkModeEnabled()
                              ? kWhiteColor
                              : kBlackColor,
                        );
                      },
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(
                          color: sharedUtility.isDarkModeEnabled()
                              ? kWhiteColor
                              : kBg100Color,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0.h,
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 5.0,
                                  top: 5.0,
                                ),
                                child: Text(
                                  searchResults[index].roleName ?? "",
                                  style: sharedUtility.isDarkModeEnabled()
                                      ? kBold15TextStyleDark
                                      : kBold15TextStyle,
                                  maxLines: 1,
                                ),
                              ),
                              SizedBox(
                                height: 8.0.h,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 5.0,
                                  bottom: 5.0,
                                ),
                                child: Text(
                                  searchResults[index].questionName ?? "",
                                  style: sharedUtility.isDarkModeEnabled()
                                      ? kRegular15TextStyleDark
                                      : kRegular15TextStyle,
                                  maxLines: 3,
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
                          onTap: () async {
                            _selectedResult = searchResults[index];
                            // showResults(context);
                            //  onResultSelected(selectedResult);
                            //  close(context, selectedResult);
                            //   _addOrUpdateNote(context);
                            final shouldRefreshPage =
                                await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return FavoriteDetailsPage(
                                    question:
                                        _selectedResult?.questionName ?? "",
                                    answer: _selectedResult?.answer ?? "",
                                    role: _selectedResult?.roleName ?? "",
                                  );
                                },
                              ),
                            );
                            if (shouldRefreshPage) {
                              Future.delayed(Duration(milliseconds: 2))
                                  .then((value) {
                                fetchFavorites();
                              });
                            }
                          },
                        );
                      },
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
                  color: kPrimary500Color,
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

  void showSideMenu({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    // print('show');
    ref.read(toggleSideMenuVisibiltyStateProvider.notifier).state = true;
  }

  // @override
  // Widget buildLeading(BuildContext context) {
  //   return IconButton(
  //     icon: const Icon(Icons.menu),
  //     color: kPrimary500Color,
  //     onPressed: () {
  //       showSideMenu(context: context, ref: ref);
  //     },
  //   );
  // }

  // Country? selectedResult;

  // void _addOrUpdateNote(BuildContext context) async {
  //   //  final isValid = _formKey.currentState!.validate();

  //   // if (isValid) {

  //   print("_addOrUpdateCountry ${_selectedResult?.id}");

  //   if (_selectedResult != null && _selectedResult?.id != null) {
  //     final isCountryExistsInDB =
  //         await HiveDB.instance.containsFavorite(_selectedResult!.id!);

  //     if (isCountryExistsInDB > 0) {
  //       onResultSelected(_selectedResult!);
  //       // close(context, _selectedResult);
  //     } else {
  //       await addFavorites();
  //       onResultSelected(_selectedResult!);
  //       // close(context, _selectedResult);
  //     }

  //     //  }
  //   }
  // }

  // Future updateNote() async {
  //   final note = widget.note!.copy(
  //     isImportant: isImportant,
  //     number: number,
  //     title: title,
  //     description: description,
  //   );

  //   await NotesDatabase.instance.update(note);
  // }

  Future addFavorites() async {
    final favorites = Favorites(
        id: _selectedResult?.id,
        questionName: _selectedResult?.questionName,
        answer: _selectedResult?.answer,
        createdTime: DateTime.now(),
        roleName: _selectedResult?.roleName,
        isSelected: 1);

    print("addUserPrompt ${_selectedResult?.id}");

    await HiveDB.instance.createFavorites(favorites);
  }
}

// class FavoritesPageAutocomplete extends SearchDelegate {
//   late Function(Country) onResultSelected;
//   late List<Country> listExample;
//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return <Widget>[
//       IconButton(
//         icon: const Icon(Icons.close),
//         onPressed: () {
//           query = "";
//         },
//       ),
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: const Icon(Icons.arrow_back_ios),
//       onPressed: () {
//         Navigator.pop(context);
//       },
//     );
//   }

//   // Country? selectedResult;

//   @override
//   Widget buildResults(BuildContext context) {
//     // return Container(
//     //   child: Center(
//     //     child: Text(selectedResult?.displayName ?? ""),
//     //   ),
//     // );
//     return Container();
//   }

//   FavoritesPageAutocomplete({
//     required this.listExample,
//     required this.onResultSelected,
//   });
//   List<Country> recentList = [];

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     List<Country> suggestionList = [];
//     query.isEmpty
//         ? suggestionList = recentList //In the true case
//         : suggestionList.addAll(listExample.where(
//             // In the false case
//             (element) =>
//                 element.displayName.toLowerCase().contains(query.toLowerCase()),
//           ));

//     return ListView.builder(
//       itemCount: suggestionList.length,
//       itemBuilder: (context, index) {
//         return ListTile(
//           title: Text(
//             suggestionList[index].displayName,
//           ),
//           onTap: () {
//             var selectedResult = suggestionList[index];
//             // showResults(context);
//             onResultSelected(selectedResult);
//             close(context, selectedResult);
//           },
//         );
//       },
//     );
//   }
// }
