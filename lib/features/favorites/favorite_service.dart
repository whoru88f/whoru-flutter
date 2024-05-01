import 'package:chatapp/database/hive/hive_db.dart';
import 'package:chatapp/database/openai_db.dart';
import 'package:chatapp/features/favorites/favorites.dart';
import 'package:chatapp/features/search_question/model/question.dart';
import 'package:collection/collection.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class FavoriteService {
  Future<int> _isFavoriteSelected(String id) async {
    var selectedFavorite = await HiveDB.instance.readFavorites(id);
    return selectedFavorite?.isSelected ?? 0;
  }

  // Future<bool> isFavorited({String? question, String? role}) async {
  //   if (question == null || role == null) {
  //     return false;
  //   }
  //   var selectedFavorite = await HiveDB.instance.readFavoriteForStrings(
  //     question: question,
  //     role: role,
  //   );
  //   // print("selectedFavorite $selectedFavorite");
  //   return selectedFavorite == null ? false : true;
  // }

  Future<bool> isFavorited({String? question, String? role}) async {
    if (question == null || role == null) {
      return false;
    }
    var selectedFavorite = await HiveDB.instance.readFavoriteForStrings(
      question: question,
      role: role,
    );
    print("selectedFavorite $selectedFavorite");
    return selectedFavorite == null ? false : true;
  }

  void updateFavoriteStatus(Favorites favorite) async {
    if (favorite.id != null) {
      var isSselected = await _isFavoriteSelected(favorite.id!);
      if (isSselected == 1) {
        print("isSselected");
        var updatedFav = Favorites(
          questionName: favorite.questionName,
          roleName: favorite.roleName,
          answer: favorite.answer,
          isSelected: 0,
          createdTime: DateTime.now(),
        );
        HiveDB.instance.updateFavorites(
          updatedFav,
        );
      } else {
        print("isSselected not");
        var updatedFav = Favorites(
          questionName: favorite.questionName,
          roleName: favorite.roleName,
          answer: favorite.answer,
          isSelected: 1,
          createdTime: DateTime.now(),
        );
        HiveDB.instance.updateFavorites(
          updatedFav,
        );
      }
    }
  }

  //  void _addOrUpdateFavorite(int id) async {
  //   //  final isValid = _formKey.currentState!.validate();

  //   // if (isValid) {

  //   print("_addOrUpdateFav ${id}");

  //     final isCountryExistsInDB =
  //         await HiveDB.instance.containsFavorite(id);

  //     if (isCountryExistsInDB > 0) {
  //      // onResultSelected(_selectedResult!);
  //       // close(context, _selectedResult);
  //     } else {
  //       await addFavorites();
  //     //  onResultSelected(_selectedResult!);
  //       // close(context, _selectedResult);
  //     }

  //     //  }

  // }

  Future addUserFavorite({
    required String question,
    required String answer,
    required String roleName,
  }) async {
    if (!await FavoriteService()
        .isFavorited(question: question, role: roleName)) {
      final favorites = Favorites(
        id: Uuid().v1(),
        questionName: question,
        answer: answer,
        roleName: roleName,
        createdTime: DateTime.now(),
        isSelected: 1,
      );

      print("addUser fav ${question}");
      await HiveDB.instance.createFavorites(favorites);
    }
  }

  Future deleteFavorite({
    required String question,
    required String roleName,
  }) async {
    await HiveDB.instance.deleteFavoritesForStrings(
      question: question,
      role: roleName,
    );
  }
}

// class FavoriteService {
//   final List<Favorites> _countries;

//   FavoriteService()
//       : _countries =
//             favoritesCodes.map((Favorites) => Favorites.from(json: Favorites)).toList();

//   ///Return list with all countries
//   List<Favorites> getAll() {
//     return _countries;
//   }

//   ///Returns the first Favorites that mach the given code.
//   Favorites? findByCode(String? code) {
//     final uppercaseCode = code?.toUpperCase();
//     return _countries
//         .firstWhereOrNull((Favorites) => Favorites.favoritesCode == uppercaseCode);
//   }

//   ///Returns the first Favorites that mach the given name.
//   Favorites? findByName(String? name) {
//     return _countries.firstWhereOrNull((Favorites) => Favorites.name == name);
//   }

//   ///Returns a list with all the countries that mach the given codes list.
//   List<Favorites> findCountriesByCode(List<String> codes) {
//     final List<String> codes0 =
//         codes.map((code) => code.toUpperCase()).toList();
//     final List<Favorites> countries = [];
//     for (final code in codes0) {
//       final Favorites? favorites = findByCode(code);
//       if (Favorites != null) {
//         countries.add(favorites);
//       }
//     }
//     return countries;
//   }
// }
