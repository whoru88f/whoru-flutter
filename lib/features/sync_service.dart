import 'package:chatapp/database/hive/hive_db.dart';
import 'package:chatapp/database/openai_db.dart';
import 'package:chatapp/features/prompts/model/prompt.dart';
import 'package:chatapp/features/search_question/model/question.dart';
import 'package:chatapp/features/user_role/models/user_role.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class SyncService {
  static final SyncService instance = SyncService._init();
  SyncService._init();

  List<UserRole> _allUserRoles = [];
  List<Prompt> _allPrompts = [];
  List<Question> _allQuestions = [];

  Future<void> syncAllQuestionFromFirestore() async {
    print("syncAllQuestionFromFirestore");
    await fetchDataFromFirestore();
    await HiveDB.instance.clearAllSyncData();
    // Add all user roles to data base
    print("_allUserRoles ${_allUserRoles.length}");
    // _allUserRoles.forEach((role) async {
    //   await HiveDB.instance.createUserRole(role);
    // });

    await HiveDB.instance.addAllRoles(_allUserRoles);

    var allROlestrmo = await HiveDB.instance.readAllUserRoles() ?? [];
    print("allROlestrmo ${allROlestrmo.length}");

    print("_allPrompts ${_allPrompts.length}");

    _allPrompts.forEach((prompt) async {
      await HiveDB.instance.createPrompt(prompt);
    });

    _allQuestions.forEach((question) async {
      await HiveDB.instance.createQuestion(question);
    });
  }

  Future<void> fetchDataFromFirestore() async {
    _allUserRoles = [];
    _allQuestions = [];
    _allPrompts = [];
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference collection = firestore.collection('question_base');

//       QuerySnapshot querySnapshot =
//           await FirebaseFirestore.instance.collection('question_base').get();

// // Accessing documents
//       querySnapshot.docs.forEach((DocumentSnapshot document) {
//         print(document.data());
//       });

      //  print("question_base");
      // Fetch documents from the collection
      QuerySnapshot querySnapshot = await collection.get();
      //  print("querySnapshot ${querySnapshot.docs.length}");
      // Process each document
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        // Access data using documentSnapshot.data()
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        // print('Document ID: ${documentSnapshot.id}');
        // print('Data: ${data["id"]}');
        final userRoleId = data["id"] ?? "";
        final userRoleName = data["role"] ?? "";
        final promptValue = data["prompt"] ?? "";
        final questionValue = data["question"] ?? "";
        final isExample = data["isExample"] == true ? 1 : 0;
        // print("userRoleName $userRoleName : userRoleId $userRoleId");
        //promptValue : $promptValue questionValue $questionValue");
        final userRole = UserRole(
          id: Uuid().v4(),
          userRoleId: userRoleId,
          roleName: userRoleName,
          isExample: isExample,
          createdTime: DateTime.now(),
        );

        final prompt = Prompt(
          id: Uuid().v4(),
          userRoleIds: userRoleId,
          promptName: promptValue,
          createdTime: DateTime.now(),
        );

        final question = Question(
          id: Uuid().v4(),
          userRoleIds: userRoleId,
          questionName: questionValue,
          createdTime: DateTime.now(),
        );
        _allPrompts.add(prompt);
        _allUserRoles.add(userRole);
        _allQuestions.add(question);
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
}
