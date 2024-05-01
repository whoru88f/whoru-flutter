import 'package:chatapp/database/hive/hive_db.dart';
import 'package:chatapp/database/openai_db.dart';
import 'package:chatapp/features/search_question/model/question.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'api_key.dart';
import 'question_request.dart';
import 'question_response.dart';

class QuestionService {
  List<Question> _allQuestions = [];

  QuestionService() {
    initialise();
  }

  void initialise() async {
    print("Questions initialise called");
    _allQuestions = await getAllQuestions();
  }

  static final Uri chatUri =
      Uri.parse('https://api.openai.com/v1/chat/completions');

  static final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${ApiKey.openAIApiKey}',
  };

  Future<List<Choice>> request(String question) async {
    print("prop $question");
    try {
      QuestionRequest request = QuestionRequest(
          model: "gpt-3.5-turbo",
          maxTokens: 150,
          messages: [Message(role: "assistant", content: question)]);
      if (question.isEmpty) {
        return [];
      }
      http.Response response = await http.post(
        chatUri,
        headers: headers,
        body: request.toJson(),
      );
      QuestionResponse chatResponse = QuestionResponse.fromResponse(response);
      return chatResponse.choices ?? [];
    } catch (e) {
      print("error $e");
    }
    return [];
  }

  List<Question> _sampleQuestions = [
    Question(
      id: Uuid().v1(),
      questionName:
          "Travel Planner:- Create a 5 day itinerary from San Francisco to London",
      userRoleIds: "9b12e9fe-2755-4a2d-9c2b-a99d3581f41d",
      createdTime: DateTime.now(),
    ),
    Question(
      id: Uuid().v1(),
      userRoleIds: "9b12ea61-06df-4faf-a528-09f72c6adfdc",
      questionName:
          "Divorce Lawyer:- Can I sell my house before my divorce is finalized in CA?",
      createdTime: DateTime.now(),
    ),
    Question(
      id: Uuid().v1(),
      userRoleIds: "9b12eaa2-ece9-4b53-b18c-ed2ba11203ae",
      questionName: "Plumbing expert:- How can I unclog a stubborn drain?",
      createdTime: DateTime.now(),
    ),
    Question(
      id: Uuid().v1(),
      userRoleIds: "9b12ea81-a7cc-4aaf-b108-554f6107be88",
      questionName:
          "Dating expert:- What are some red flags to watch out for in dating?​",
      createdTime: DateTime.now(),
    ),
  ];

  Future<List<Question>> getExampleQuestions() async {
    // final questions = await getAllQuestions();

    // if (questions.length >= 4) {
    //   return questions.sublist(0, 3);
    // }
    // return questions;
    return _sampleQuestions;
  }

  Future<List<Question>> getAllQuestions() async {
    return await HiveDB.instance.readAllQuestion();
  }
}
