
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SideMenuItem { home, favourites, settings, privacy, feedback, share, logout }

final sideMenuSelectionProvider =
    ChangeNotifierProvider<SideMenuSelectionNotifier>(
        (ref) => SideMenuSelectionNotifier());

class SideMenuSelectionNotifier extends ChangeNotifier {
  SideMenuItem _sideMenuItem = SideMenuItem.home;

  void setSelectedMenuItem({required SideMenuItem item}) {
    _sideMenuItem = item;
    notifyListeners();
  }

  SideMenuItem getSelectedMenuItem() {
    return _sideMenuItem;
  }
}

final toggleSideMenuVisibiltyStateProvider =
    StateProvider<bool>((ref) => false);

// final toggleSideMenuVisibiltyStateProvider =
//     ChangeNotifierProvider<ShowSideMenuNotifier>(
//         (ref) => ShowSideMenuNotifier());

// class ShowSideMenuNotifier extends ChangeNotifier {
//   bool _sideMenuShowStatus = true;

//   void setShowSideMenuStatus({required bool item}) {
//     _sideMenuShowStatus = item;
//     notifyListeners();
//   }

//   bool getShowSideMenuStatus() {
//     return _sideMenuShowStatus;
//   }
// }


// final sideMenuVisibiltyProvider = Provider<Bool>((ref) {
//   final _sideMenuVisibilty =
//       ref.watch(toggleSideMenuVisibiltyStateProvider.notifier);
//   print("_sideMenuVisibilty ${_sideMenuVisibilty.state}");
//   return _sideMenuVisibilty.state;
// });
