import 'package:chatapp/common/utility/shared_utility.dart';
import 'package:chatapp/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* AppTheme */

// final appThemeProvider = Provider<AppTheme>((ref) {
//   return AppTheme();
// });

// class AppTheme {
//   //Modify to add more colors here

//   static ThemeData _lightThemeData = ThemeData(
//     fontFamily: "SplineSans",
//     appBarTheme: const AppBarTheme(
//       backgroundColor: kPrimary500Color,
//     ),
//     primaryColor: kPrimary500Color,
//     scaffoldBackgroundColor: kWhiteColor,
//   );

//   static ThemeData _darkThemeData = ThemeData(
//     fontFamily: "SplineSans",
//     appBarTheme: const AppBarTheme(
//       backgroundColor: kPrimary500Color,
//     ),
//     primaryColor: kPrimary500Color,
//     scaffoldBackgroundColor: Colors.black,
//   );

//   ThemeData getAppThemedata(BuildContext context, bool isDarkModeEnabled) {
//     return isDarkModeEnabled ? _darkThemeData : _lightThemeData;
//   }
// }

/* AppTheme Notifier */

// final appThemeStateProvider =
//     StateNotifierProvider<AppThemeNotifier, bool>((ref) {
//   final _isDarkModeEnabled =
//       ref.read(sharedUtilityProvider).isDarkModeEnabled();
//   return AppThemeNotifier(_isDarkModeEnabled);
// });

// class AppThemeNotifier extends StateNotifier<bool> {
//   AppThemeNotifier(this.defaultDarkModeValue) : super(defaultDarkModeValue);

//   final bool defaultDarkModeValue;

//   toggleAppTheme(BuildContext context, WidgetRef ref) {
//     final _isDarkModeEnabled =
//         ref.watch(sharedUtilityProvider).isDarkModeEnabled();
//     final _toggleValue = !_isDarkModeEnabled;

//     ref
//         .watch(
//           sharedUtilityProvider,
//         )
//         .setDarkModeEnabled(_toggleValue)
//         .whenComplete(
//           () => {
//             state = _toggleValue,
//           },
//         );
//   }
// }
