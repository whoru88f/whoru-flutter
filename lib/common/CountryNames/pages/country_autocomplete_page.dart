// import 'package:chatapp/common/CountryNames/country.dart';
// import 'package:chatapp/database/openai_db.dart';
// import 'package:chatapp/database/recent_history/recent_country.dart';
// import 'package:chatapp/theme.dart';
// import 'package:flutter/material.dart';

// class SearchCountryAutocomplete extends SearchDelegate {
//   late Function(Country) onResultSelected;
//   late List<Country> listExample;
//   late List<Country> recentCountryList;
//   Country? _selectedResult;
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

//   SearchCountryAutocomplete({
//     required this.listExample,
//     required this.onResultSelected,
//     required this.recentCountryList,
//   });

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     List<Country> suggestionList = [];
//     query.isEmpty
//         ? suggestionList = recentCountryList //In the true case
//         : suggestionList.addAll(listExample.where(
//             // In the false case
//             (element) => (element.name ?? "")
//                 .toLowerCase()
//                 .contains(query.toLowerCase()),
//           ));

//     return Container(
//       padding: EdgeInsets.all(8.0),
//       child: ListView.builder(
//         itemCount: suggestionList.length,
//         itemBuilder: (context, index) {
//           return GestureDetector(
//             behavior: HitTestBehavior.opaque,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 10.0,
//                   ),
//                   child: Text(
//                     suggestionList[index].name ?? "",
//                     style: sharedUtility.isDarkModeEnabled()
//                         ? kRegularTextStyleDark
//                         : kRegularTextStyle,
//                   ),
//                 ),
//                 Divider(
//                   indent: 5,
//                 ),
//               ],
//             ),
//             onTap: () {
//               _selectedResult = suggestionList[index];
//               // showResults(context);
//               //  onResultSelected(selectedResult);
//               //  close(context, selectedResult);
//               _addOrUpdateNote(context);
//             },
//           );
//         },
//       ),
//     );
//   }

//   void _addOrUpdateNote(BuildContext context) async {
//     //  final isValid = _formKey.currentState!.validate();

//     // if (isValid) {

//     print("_addOrUpdateCountry ${_selectedResult?.countryCode}");

//     if (_selectedResult != null && _selectedResult?.countryCode != null) {
//       final isCountryExistsInDB = await HiveDB.instance
//           .containsCountry(_selectedResult!.countryCode!);

//       if (isCountryExistsInDB > 0) {
//         onResultSelected(_selectedResult!);
//         close(context, _selectedResult);
//       } else {
//         await addUserCountry();
//         onResultSelected(_selectedResult!);
//         close(context, _selectedResult);
//       }

//       //  }
//     }
//   }

//   // Future updateNote() async {
//   //   final note = widget.note!.copy(
//   //     isImportant: isImportant,
//   //     number: number,
//   //     title: title,
//   //     description: description,
//   //   );

//   //   await NotesDatabase.instance.update(note);
//   // }

//   Future addUserCountry() async {
//     final Country = RecentCountry(
//       createdTime: DateTime.now(),
//       phoneCode: _selectedResult?.phoneCode,
//       countryCode: _selectedResult?.countryCode,
//       e164Sc: _selectedResult?.e164Sc,
//       geographic: _selectedResult?.geographic,
//       level: _selectedResult?.level,
//       name: _selectedResult?.name,
//       example: _selectedResult?.example,
//       displayName: _selectedResult?.displayName,
//       displayNameNoCountryCode: _selectedResult?.displayNameNoCountryCode,
//       e164Key: _selectedResult?.e164Key,
//       fullExampleWithPlusSign: _selectedResult?.fullExampleWithPlusSign,
//     );

//     print("addUserCountry ${_selectedResult?.countryCode}");

//     await HiveDB.instance.createRecentCountry(Country);
//   }
// }

// // class SearchCountryAutocomplete extends SearchDelegate {
// //   late Function(Country) onResultSelected;
// //   late List<Country> listExample;
// //   @override
// //   List<Widget> buildActions(BuildContext context) {
// //     return <Widget>[
// //       IconButton(
// //         icon: const Icon(Icons.close),
// //         onPressed: () {
// //           query = "";
// //         },
// //       ),
// //     ];
// //   }

// //   @override
// //   Widget buildLeading(BuildContext context) {
// //     return IconButton(
// //       icon: const Icon(Icons.arrow_back_ios),
// //       onPressed: () {
// //         Navigator.pop(context);
// //       },
// //     );
// //   }

// //   // Country? selectedResult;

// //   @override
// //   Widget buildResults(BuildContext context) {
// //     // return Container(
// //     //   child: Center(
// //     //     child: Text(selectedResult?.displayName ?? ""),
// //     //   ),
// //     // );
// //     return Container();
// //   }

// //   SearchCountryAutocomplete({
// //     required this.listExample,
// //     required this.onResultSelected,
// //   });
// //   List<Country> recentList = [];

// //   @override
// //   Widget buildSuggestions(BuildContext context) {
// //     List<Country> suggestionList = [];
// //     query.isEmpty
// //         ? suggestionList = recentList //In the true case
// //         : suggestionList.addAll(listExample.where(
// //             // In the false case
// //             (element) =>
// //                 element.displayName.toLowerCase().contains(query.toLowerCase()),
// //           ));

// //     return ListView.builder(
// //       itemCount: suggestionList.length,
// //       itemBuilder: (context, index) {
// //         return ListTile(
// //           title: Text(
// //             suggestionList[index].displayName,
// //           ),
// //           //  leading: query.isEmpty ? Icon(Icons.access_time) : SizedBox(),
// //           onTap: () {
// //             var selectedResult = suggestionList[index];
// //             // showResults(context);
// //             onResultSelected(selectedResult);
// //             close(context, selectedResult);
// //           },
// //         );
// //       },
// //     );
// //   }
// // }
