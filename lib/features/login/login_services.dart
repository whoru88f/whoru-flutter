import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class LoginService {
  // Future<void> saveOrUpdateUserDetails(Map<String, dynamic> userMap) async {
  //   final FirebaseFirestore firestore = FirebaseFirestore.instance;
  //   try {
  //     DocumentReference docRef = firestore.collection('users').doc('user_id');
  //     DocumentSnapshot docSnapshot = await docRef.get();

  //     if (docSnapshot.exists) {
  //       // Document exists, so update it
  //       print('Data updated successfully!');
  //       return await docRef.update(userMap);
  //     } else {
  //       // Document doesn't exist, so save it
  //       print('Data saved successfully!');
  //       return await docRef.set(userMap);
  //     }
  //   } catch (error) {
  //     print('Error saving or updating data: $error');
  //     return;
  //   }
  // }

  Future<void> addOrUpdateUser(
      {required String mobileNumber,
      required Map<String, dynamic> userMap}) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    CollectionReference collection = _firestore.collection('users');

    try {
      // Check if the user already exists
      String? docId = await checkUserExists(mobileNumber);

      if (docId != null) {
        // If the user exists, update the document
        print('User data updated successfully!');
        return await collection.doc(docId).update(userMap);
      } else {
        // If the user doesn't exist, add a new document
        print('User data added successfully!');
        return await collection.doc(Uuid().v4()).set(userMap);
      }
    } catch (error) {
      print('Error adding or updating user data: $error');
      return;
    }
  }

  Future<String?> checkUserExists(String mobileNumber) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('mobileNumber', isEqualTo: mobileNumber)
          .limit(1)
          .get();

      return querySnapshot.docs.first.id;
    } catch (error) {
      print('Error checking user existence: $error');
      return null;
    }
  }
}
