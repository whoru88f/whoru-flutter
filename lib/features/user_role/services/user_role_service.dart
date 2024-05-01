import 'package:chatapp/database/hive/hive_db.dart';
import 'package:chatapp/database/openai_db.dart';
import 'package:chatapp/features/user_role/models/user_role.dart';
import 'package:uuid/uuid.dart';

class UserRoleService {
  List<UserRole> _allRoles = [];

  UserRoleService() {
    initialise();
  }

  void initialise() async {
    print("User roles initialise called");

    _allRoles = await getAllRoles() ?? [];
  }

/*
List<UserRole> _sampleRoles = [
    UserRole(
      id: Uuid().v1(),
      userRoleId: "9b12e9fe-2755-4a2d-9c2b-a99d3581f41d",
      roleName: "Writing Style Analysis",
      createdTime: DateTime.now(),
    ),
    UserRole(
      id: Uuid().v1(),
      userRoleId: "9b12ea4b-53df-484a-814e-87b157f4539e",
      roleName: "Cancer Doctor",
      createdTime: DateTime.now(),
    ),
    UserRole(
      id: Uuid().v1(),
      userRoleId: "9b12ea61-06df-4faf-a528-09f72c6adfdc",
      roleName: "Heart Surgeon",
      createdTime: DateTime.now(),
    ),
    UserRole(
      id: Uuid().v1(),
      userRoleId: "9b12ea6f-71a2-4072-9bb0-664beafb65e4",
      roleName: "English Translator",
      createdTime: DateTime.now(),
    ),
    UserRole(
      id: Uuid().v1(),
      userRoleId: "9b12ea81-a7cc-4aaf-b108-554f6107be88",
      roleName: "Act as position Interviewer",
      createdTime: DateTime.now(),
    ),
    UserRole(
      id: Uuid().v1(),
      userRoleId: "9b12eaa2-ece9-4b53-b18c-ed2ba11203ae",
      roleName: "Excel expert",
      createdTime: DateTime.now(),
    ),
    UserRole(
      id: Uuid().v1(),
      userRoleId: "9b12eab4-a930-4e0e-b9a9-cce91858ee40",
      roleName: "Lesson Planner",
      createdTime: DateTime.now(),
    ),
    UserRole(
      id: Uuid().v1(),
      userRoleId: "9b12eac5-b416-44ea-8a55-7f61c6747e5e",
      roleName: "Interactive Lecture",
      createdTime: DateTime.now(),
    ),
    UserRole(
      id: Uuid().v1(),
      userRoleId: "9b12ead6-7cb1-486a-916e-c5261d0a0932",
      roleName: "Writing Mentor",
      createdTime: DateTime.now(),
    ),
    UserRole(
      id: Uuid().v1(),
      userRoleId: "9b12eae4-fb5a-4561-9ed6-b2dd966a5b9c",
      roleName: "Tutor",
      createdTime: DateTime.now(),
    ),
    UserRole(
      id: Uuid().v1(),
      userRoleId: "9b12eaf1-c98c-49ed-8112-7adad36e0d27",
      roleName: "School Admin",
      createdTime: DateTime.now(),
    ),
  ];
*/

/* USe for filling firestroe ***/
/*
  List<UserRole> _sampleRoles = [
    UserRole(
      id: Uuid().v1(),
      userRoleId: "9b12e9fe-2755-4a2d-9c2b-a99d3581f41d",
      roleName: "Customer Support Representative",
      isExample: true,
      createdTime: DateTime.now(),
    ),
    UserRole(
      id: Uuid().v1(),
      userRoleId: "9b12ea4b-53df-484a-814e-87b157f4539e",
      roleName: "Software Developer",
      isExample: true,
      createdTime: DateTime.now(),
    ),
    UserRole(
      id: Uuid().v1(),
      userRoleId: "9b12ea61-06df-4faf-a528-09f72c6adfdc",
      roleName: "Content Creator/Writer",
      isExample: true,
      createdTime: DateTime.now(),
    ),
    UserRole(
      id: Uuid().v1(),
      userRoleId: "9b12ea6f-71a2-4072-9bb0-664beafb65e4",
      roleName: "Digital Marketer",
      isExample: true,
      createdTime: DateTime.now(),
    ),
    UserRole(
      id: Uuid().v1(),
      userRoleId: "9b12ea81-a7cc-4aaf-b108-554f6107be88",
      roleName: "Data Scientist",
      isExample: true,
      createdTime: DateTime.now(),
    ),
    UserRole(
      id: Uuid().v1(),
      userRoleId: "9b12eaa2-ece9-4b53-b18c-ed2ba11203ae",
      roleName: "Legal Researcher",
      isExample: true,
      createdTime: DateTime.now(),
    ),
    UserRole(
      id: Uuid().v1(),
      userRoleId: "9b12eab4-a930-4e0e-b9a9-cce91858ee40",
      roleName: "Human Resource Manager",
      isExample: true,
      createdTime: DateTime.now(),
    ),
    UserRole(
      id: Uuid().v1(),
      userRoleId: "9b12eac5-b416-44ea-8a55-7f61c6747e5e",
      roleName: "Teacher/Educator",
      isExample: true,
      createdTime: DateTime.now(),
    ),
    UserRole(
      id: Uuid().v1(),
      userRoleId: "9b12ead6-7cb1-486a-916e-c5261d0a0932",
      roleName: "Financial Analyst",
      isExample: true,
      createdTime: DateTime.now(),
    ),
  ];

  */
//   List<UserRole> _allRoles = [
// //Writing Style Analysis
// // Cancer Doctor
// // Heart Surgeon
// // English Translator
// // Act as position Interviewer
// // Excel expert
// // Lesson Planner
// // Interactive Lecture
// // Writing Mentor
// // Tutor
// // School Admin
//     UserRole(
//       id: Uuid().v1(),
//       userRoleId: "9b12e9fe-2755-4a2d-9c2b-a99d3581f41d",
//       roleName: "Writing Style Analysis",
//       createdTime: DateTime.now(),
//     ),
//     UserRole(
//       id: Uuid().v1(),
//       userRoleId: "9b12ea4b-53df-484a-814e-87b157f4539e",
//       roleName: "Cancer Doctor",
//       createdTime: DateTime.now(),
//     ),
//     UserRole(
//       id: Uuid().v1(),
//       userRoleId: "9b12ea61-06df-4faf-a528-09f72c6adfdc",
//       roleName: "Heart Surgeon",
//       createdTime: DateTime.now(),
//     ),
//     UserRole(
//       id: Uuid().v1(),
//       userRoleId: "9b12ea6f-71a2-4072-9bb0-664beafb65e4",
//       roleName: "English Translator",
//       createdTime: DateTime.now(),
//     ),
//     UserRole(
//       id: Uuid().v1(),
//       userRoleId: "9b12ea81-a7cc-4aaf-b108-554f6107be88",
//       roleName: "Act as position Interviewer",
//       createdTime: DateTime.now(),
//     ),
//     UserRole(
//       id: Uuid().v1(),
//       userRoleId: "9b12eaa2-ece9-4b53-b18c-ed2ba11203ae",
//       roleName: "Excel expert",
//       createdTime: DateTime.now(),
//     ),
//     UserRole(
//       id: Uuid().v1(),
//       userRoleId: "9b12eab4-a930-4e0e-b9a9-cce91858ee40",
//       roleName: "Lesson Planner",
//       createdTime: DateTime.now(),
//     ),
//     UserRole(
//       id: Uuid().v1(),
//       userRoleId: "9b12eac5-b416-44ea-8a55-7f61c6747e5e",
//       roleName: "Interactive Lecture",
//       createdTime: DateTime.now(),
//     ),
//     UserRole(
//       id: Uuid().v1(),
//       userRoleId: "9b12ead6-7cb1-486a-916e-c5261d0a0932",
//       roleName: "Writing Mentor",
//       createdTime: DateTime.now(),
//     ),
//     UserRole(
//       id: Uuid().v1(),
//       userRoleId: "9b12eae4-fb5a-4561-9ed6-b2dd966a5b9c",
//       roleName: "Tutor",
//       createdTime: DateTime.now(),
//     ),
//     UserRole(
//       id: Uuid().v1(),
//       userRoleId: "9b12eaf1-c98c-49ed-8112-7adad36e0d27",
//       roleName: "School Admin",
//       createdTime: DateTime.now(),
//     ),
//   ];

  Future<List<UserRole>?> getAllRoles() {
    // return Future.delayed(const Duration(seconds: 0), () {
    //   return _allRoles;
    // });

    return HiveDB.instance.readAllUserRoles();
  }

  // Future<List<UserRole>> getRecentRoles() {
  //   return Future.delayed(const Duration(seconds: 0), () {
  //     return [
  //       UserRole(
  //         id: 1,
  //         roleName: "Software Developer",
  //       ),
  //       UserRole(
  //         id: 2,
  //         roleName: "Leagal Researcher",
  //       ),
  //       UserRole(
  //         id: 3,
  //         roleName: "Digital Marketer",
  //       ),
  //       UserRole(
  //         id: 4,
  //         roleName: "Data Scientist",
  //       ),
  //     ];
  //   });
  // }

  Future<List<UserRole>?> getExampleRoles() async {
    //final roles = HiveDB.instance.readAllExamplesUserRoles();

    // if (roles.length >= 4) {
    //   return roles.sublist(0, 3);
    // }
    return HiveDB.instance.readAllExamplesUserRoles();
  }
}
