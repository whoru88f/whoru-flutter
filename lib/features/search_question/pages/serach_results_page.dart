import 'dart:async';

import 'package:chatapp/common/openai/chat_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/common/openai/chat_service.dart';
import 'package:chatapp/common/openai/dalle_image_service.dart';
import 'package:chatapp/common/openai/open_ai_azure_service.dart';
import 'package:chatapp/common/utility/shared_utility.dart';
import 'package:chatapp/database/openai_db.dart';
import 'package:chatapp/features/common_widgets/app-loading-animation.dart';
import 'package:chatapp/features/favorites/favorite_service.dart';
import 'package:chatapp/features/search_question/model/question.dart';
import 'package:chatapp/features/search_question/pages/animated_search_text_response_widget.dart';
import 'package:chatapp/features/search_question/pages/dot_loading_animation_widget.dart';
import 'package:chatapp/features/search_question/pages/full_screen_chat_image.dart';
import 'package:chatapp/features/user_role/models/user_role.dart';
import 'package:chatapp/features/user_role/pages/user_role_page.dart';
import 'package:chatapp/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'package:chatapp/features/common_widgets/no-internet-widget.dart';

enum ChatResponseType { user, chatgpt, loading, gen_image }

class ChatResponseModel {
  final ChatResponseType chatResponseType;
  final String id = Uuid().v4();
  final String message;
  final String question;
  late bool isAnimationCompleted;
  late bool isDalleImageGenerated;

  ChatResponseModel({
    required this.chatResponseType,
    required this.message,
    required this.question,
    required this.isAnimationCompleted,
    this.isDalleImageGenerated = false,
  });
}

class SearchResultsPage extends ConsumerStatefulWidget {
  final String? selectedUserRole;
  final String? selectedQuestion;
  final String? suppliedPrompt;
  const SearchResultsPage({
    this.selectedUserRole,
    this.selectedQuestion,
    this.suppliedPrompt,
    super.key,
  });

  @override
  ConsumerState<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends ConsumerState<SearchResultsPage> {
  String? response;
  // bool isFavorited = false;
  bool showScrollToBottomButton = false;
  // TextEditingController _responseTextController = TextEditingController();
  TextEditingController _searchCtrl = TextEditingController();

  List<ChatResponseModel> chatResponseList = [];

  ScrollController listScrollController = ScrollController();

  bool isAskQuestionButtonDisabled = false;

  final SpeechToText _speech = SpeechToText();

  bool _speechEnabled = false;
  String _wordsSpoken = "";
  double _confidenceLevel = 0;

  Timer? _timer;

  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    initSpeech();
    //fetchOpenAiAnswers();
    //print("Promopt ${widget.selectedQuestion}");
    //print("selectedUserRole ${widget.selectedUserRole}");
    // fetchAnswer(widget.selectedQuestion ?? "");
    listScrollController.addListener(_scrollListener);
    setState(() {
      _isListening = false;
      isAskQuestionButtonDisabled = _searchCtrl.text.isEmpty;
    });
  }

  void initSpeech() async {
    await _speech.initialize(onError: (error) {
      print('Error: $error');
    });
    setState(() {});
  }

  void _startListening() {
    _speech.listen(
      onResult: (result) {
        setState(() {
          _wordsSpoken = "${result.recognizedWords}";
          _confidenceLevel = result.confidence;
          print("Searxh");
          _searchCtrl.text = _wordsSpoken;
        });
        // Reset the timer only if there's no speech for 1 second
        if (_timer != null) _timer?.cancel();
        _timer = Timer(Duration(seconds: 1), _resetTimer);
      },
    );
    setState(() {
      _isListening = true;
    });

    // Start a timer to stop listening after 10 seconds of inactivity
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer(Duration(seconds: 4), _stopListening);
  }

  void _resetTimer() {
    _timer?.cancel();
    _startTimer();
  }

  void _stopListening() {
    _speech.stop();
    print("Searxh stop");
    setState(() {
      _searchCtrl.clear();
      _isListening = false;
    });
  }

  // void _startListening() {
  //   _speech.listen(
  //       onResult: _onSpeechResult,
  //       listenFor: Duration(
  //         seconds: 3,
  //       ));
  //   setState(() {
  //     _confidenceLevel = 0;
  //     _isListening = true;
  //   });

  //   // Start a timer to stop listening after 10 seconds of inactivity
  //   _startTimer();
  // }

  // void _onSpeechResult(result) {
  //   setState(() {
  //     _wordsSpoken = "${result.recognizedWords}";
  //     _confidenceLevel = result.confidence;
  //     //print("Searxh");
  //     _searchCtrl.text = _wordsSpoken;
  //     // Reset the timer whenever a new result is received
  //     _resetTimer();
  //   });
  // }

  // void _startTimer() {
  //   _timer = Timer(Duration(seconds: 3), _stopListening);
  // }

  // void _resetTimer() {
  //   _timer?.cancel();
  //   print("IS ACTIVE ${_timer?.isActive}");
  //   _startTimer();
  // }

  // void _stopListening() {
  //   if (_speech.isNotListening) {
  //     _speech.stop();
  //     setState(() {
  //       _isListening = false;
  //     });
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   initSpeech();
  //   //fetchOpenAiAnswers();
  //   //print("Promopt ${widget.selectedQuestion}");
  //   //print("selectedUserRole ${widget.selectedUserRole}");
  //   // fetchAnswer(widget.selectedQuestion ?? "");
  //   listScrollController.addListener(_scrollListener);
  //   setState(() {
  //     isAskQuestionButtonDisabled = _searchCtrl.text.isEmpty;
  //   });
  // }

  // void _startListening() async {
  //   await _speechToText.listen(
  //       onResult: _onSpeechResult,
  //       // localeId: " en-US",
  //       //listenFor: Duration(seconds: 2)
  //       );
  //   setState(() {
  //     _confidenceLevel = 0;
  //   });
  // ///  Automatically stop listening after 10 seconds
  //   Timer(Duration(seconds: 5), () {
  //     _stopListening();
  //   });
  // }

  // void _stopListening() async {
  //   await _speechToText.stop();
  //   setState(() {
  //   });
  // }

  // void _onSpeechResult(result) {
  //   setState(() {
  //     _wordsSpoken = "${result.recognizedWords}";
  //     _confidenceLevel = result.confidence;
  //     print("Searxh");
  //     _searchCtrl.text = _wordsSpoken;
  //      // Reset the timer whenever a new result is received
  //     _resetTimer();
  //   });
  // }

  @override
  void dispose() {
    super.dispose();
  }

  void _scrollListener() {
    // Handle scroll events here
    // print('Scrolled ofset: ${listScrollController.offset}');
    // print('Scrolled extent: ${listScrollController.position.maxScrollExtent}');

    final lastButtonVisibiltyState = showScrollToBottomButton;
    var updatedState = false;
    if (listScrollController.offset <
        (listScrollController.position.maxScrollExtent - 50)) {
      updatedState = true;
      if (updatedState != lastButtonVisibiltyState) {
        setState(() {
          print("updated state ${updatedState}");
          showScrollToBottomButton = updatedState;
        });
      }
    } else {
      setState(() {
        showScrollToBottomButton = false;
      });
    }
  }

  // void updateFavoriteState() async {
  //   var _isFavorited = await FavoriteService().isFavorited(
  //       question: widget.selectedQuestion, role: widget.selectedUserRole);
  //   print("_isFavorited $_isFavorited");
  //   setState(() {
  //     isFavorited = _isFavorited;
  //   });
  // }

  void showLoading() {
    // print("Searxh showLoading");
    setState(() {
      // _responseTextController.text = response ?? "--";
      _searchCtrl.text = "";
      final answerModel = ChatResponseModel(
        chatResponseType: ChatResponseType.loading,
        message: "",
        question: "",
        isAnimationCompleted: true,
      );
      chatResponseList.add(answerModel);
      // print("Searxh cleared");
    });

    Future.delayed(Duration(milliseconds: 900)).then(
      (value) {
        _scrollToBottom();
      },
    );
  }

// // Idea is to send promt only once
//   int promptApiCallCounter = 0;

// This is to send to Chatgpt
  List<String> getAllAnswersHistory() {
    List<String> answers = [];
    chatResponseList.forEach((chatResponse) {
      if (chatResponse.chatResponseType == ChatResponseType.user) {
        answers.add(chatResponse.message);
      }
    });
    return answers;
  }

  void fetchOpenAiAnswers(String questionString) async {
    showLoading();

    /*** FOR OPEN AI *****/
    /*  response = await ChatService().request(
    // response = await ChatService().request(
    //   widget.selectedUserRole,
    //   widget.selectedQuestion,
    //   questionString,
    // );
    */

/*** FOR AZURE OPEN AI *****/
    response = await OpenAIAzureService().request(
      //prompt: promptApiCallCounter >= 1 ? "" : widget.suppliedPrompt,
      prompt: widget.suppliedPrompt,
      userRole: widget.selectedUserRole,
      question: questionString,
      allAnswers: getAllAnswersHistory(),
    );

    //promptApiCallCounter += 1;

    setState(() {
      // _responseTextController.text = response ?? "--";
      final answerModel = ChatResponseModel(
        chatResponseType: ChatResponseType.chatgpt,
        message: response ?? "",
        question: questionString,
        isAnimationCompleted: false,
      );
      chatResponseList.removeLast();
      chatResponseList.add(answerModel);
      //   _searchCtrl.text = "";

      // Future.delayed(Duration(seconds: 1)).then(
      //   (value) {
      //     _scrollToBottom();
      //   },
      // );
    });
  }

  void fetchDalleImage(String questionString) async {
    showLoading();

// the resons eis image url
    response = await DalleImageService().request(
      prompt: questionString,
    );

    setState(() {
      // _responseTextController.text = response ?? "--";
      final answerModel = ChatResponseModel(
        chatResponseType: ChatResponseType.gen_image,
        message: response ?? "",
        question: questionString,
        isAnimationCompleted: false,
      );
      chatResponseList.removeLast();
      chatResponseList.add(answerModel);
    });
  }

  void fetchOpenAiAnswersDummy(String questionString) {
    showLoading();
    final chatResponse =
        """1. Set up a Mac: iOS developme developme developme developme development requires a Mac cpment requires a Mac cpment requires a Mac cpment requires a Mac cpment requires a Mac cpment requires a Mac cpment requires a Mac cpment requires a Mac cpment requires a Mac c pment requires a Mac cpment requires a Mac cpment requires a Mac computer. Make sure you have a Mac, or consider getting one if you don't have one already.
""";

    // _responseTextController.text = response ?? "--";
    final answerModel = ChatResponseModel(
      chatResponseType: ChatResponseType.chatgpt,
      message: chatResponse,
      question: questionString,
      isAnimationCompleted: false,
    );
    setState(() {
      _searchCtrl.text = "";
    });
    Future.delayed(Duration(seconds: 2)).then(
      (value) {
        setState(() {
          chatResponseList.removeLast();
          chatResponseList.add(answerModel);
          // _searchCtrl.text = "";
        });
      },
    );

    // Future.delayed(Duration(seconds: 3)).then((value) {
    //   setState(
    //     () {
    //       _scrollToBottom();
    //     },
    //   );
    // });
  }

  // Widget getResponseWidget({String? chatResponse}) {
  //   if (chatResponse == null) {
  //     return Center(
  //       child: Image.asset(
  //         "assets/logo.gif",
  //         height: 80.0,
  //       ),
  //     );
  //   } else {
  //     return SingleChildScrollView(
  //       child: TextField(
  //         controller: _responseTextController,
  //         readOnly: true,
  //         showCursor: false,
  //         maxLines: null,
  //         autofocus: true,
  //         decoration: InputDecoration(border: InputBorder.none
  //             //labelText: 'Enter Text',
  //             // You can customize other styles as needed
  //             // border: OutlineInputBorder(),
  //             ),
  //       ),
  //     );
  //   }
  // }

  void selectAllAndCopy(String textToCopy) {
    final text = textToCopy;

    // Select all text in the TextField
    // _responseTextController.selection = TextSelection(
    //   baseOffset: 0,
    //   extentOffset: text.length,
    // );

    // Copy the selected text to the clipboard
    Clipboard.setData(ClipboardData(text: text));

    // Optionally, provide user feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Text copied to clipboard'),
      ),
    );
  }

  void addQuestionToView(String questionString) {
    final chatQuestion = questionString;
    // Future.delayed(Duration(seconds: 1)).then(
    //   (value) {
    setState(() {
      final chatResponseModel = ChatResponseModel(
        chatResponseType: ChatResponseType.user,
        message: chatQuestion,
        question: questionString,
        isAnimationCompleted: true,
      );

      // _responseTextController.text = response ?? "--";
      chatResponseList.add(chatResponseModel);
    });
    // _scrollToBottom();
    //   },
    // );
    Future.delayed(Duration(milliseconds: 200)).then(
      (value) {
        _scrollToBottom();
      },
    );
  }

  void addQuestionToViewDummy(String questionString) {
    final chatQuestion = questionString;

    // Future.delayed(Duration(seconds: 1)).then(
    //  (value) {
    setState(() {
      final chatResponseModel = ChatResponseModel(
        chatResponseType: ChatResponseType.user,
        message: chatQuestion,
        question: questionString,
        isAnimationCompleted: true,
      );

      // _responseTextController.text = response ?? "--";
      chatResponseList.add(chatResponseModel);
    });
    Future.delayed(Duration(milliseconds: 900)).then(
      (value) {
        _scrollToBottom();
      },
    );
  }

  void fetchAnswer(String questionString) {
    //_searchCtrl.clear;
    addQuestionToView(questionString);

    fetchOpenAiAnswers(questionString);
    _stopListening();
    // addQuestionToViewDummy(questionString);
    // fetchOpenAiAnswersDummy(questionString);
    // updateFavoriteState();
  }

  void deleteRestFromBelowAndFetchAnswer(ChatResponseModel responseModel) {
    final questionIndex = chatResponseList.indexWhere(
      (element) {
        return responseModel.id == element.id;
      },
    );

    final tmpChatResponseList = chatResponseList;

    tmpChatResponseList.removeRange(questionIndex, tmpChatResponseList.length);

    chatResponseList = tmpChatResponseList;

    // addQuestionToView(questionString);
    fetchOpenAiAnswers(responseModel.question);
    // addQuestionToViewDummy(questionString);
    // fetchOpenAiAnswersDummy(questionString);
    // updateFavoriteState();
  }

  void fetchGeneratedImage(ChatResponseModel responseModel) {
    // final questionIndex = chatResponseList.indexWhere(
    //   (element) {
    //     return responseModel.id == element.id;
    //   },
    // );

    // final tmpChatResponseList = chatResponseList;

    // tmpChatResponseList.removeRange(questionIndex, tmpChatResponseList.length);

    // chatResponseList = tmpChatResponseList;
    // addQuestionToView(questionString);
    fetchDalleImage(responseModel.question);
  }

  void _scrollToBottom() {
    if (listScrollController.hasClients) {
      listScrollController.animateTo(
        listScrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 700),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sharedUtility = ref.read(sharedUtilityProvider);
    return Scaffold(
      backgroundColor:
          sharedUtility.isDarkModeEnabled() ? kBlackColor : kWhiteColor,
      // appBar: AppBar(
      //   backgroundColor: Colors,
      //   elevation: 0,
      //   title: const Text(
      //     'Verification',
      //   ),
      // ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50.h,
                ),

                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 12.0,
                      right: 12.0,
                      // bottom: 20.0,
                    ),
                    child: ListView.builder(
                      controller: listScrollController,
                      padding: EdgeInsets.only(
                        // left: 12.0,
                        // right: 12.0,
                        bottom: 20.0,
                      ),
                      itemCount: chatResponseList.length,
                      itemBuilder: (context, index) {
                        final chatResponseModel = chatResponseList[index];

                        if (chatResponseModel.chatResponseType ==
                            ChatResponseType.user) {
                          return Container(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20.h,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 70.0.w,
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 5.0),
                                        decoration: BoxDecoration(
                                          color:
                                              kPrimary500Color, // Container background color
                                          borderRadius: BorderRadius.circular(
                                              15), // Adjust the radius as needed
                                          border: Border.all(
                                            color:
                                                kPrimary500Color, // Border color
                                            width: 0.5, // Border width
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: sharedUtility
                                                      .isDarkModeEnabled()
                                                  ? Colors.black
                                                      .withOpacity(0.5)
                                                  : Colors.grey
                                                      .withOpacity(0.5),
                                              spreadRadius: 0,
                                              blurRadius: 3,
                                              offset: Offset(1,
                                                  2), // changes the shadow position
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 7.h,
                                            ),
                                            Text(
                                              chatResponseModel.message,
                                              style: kRegular15WhiteTextStyle,
                                            ),
                                            SizedBox(
                                              height: 7.h,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                              ],
                            ),
                          );
                        } else if (chatResponseModel.chatResponseType ==
                            ChatResponseType.chatgpt) {
                          return Container(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 5.0),
                                    decoration: BoxDecoration(
                                      color: sharedUtility.isDarkModeEnabled()
                                          ? kBlackColor
                                          : kWhiteColor, // Container background color
                                      borderRadius: BorderRadius.circular(
                                          15), // Adjust the radius as needed
                                      border: Border.all(
                                        color: sharedUtility.isDarkModeEnabled()
                                            ? kWhiteColor
                                            : klightGreyColor, // Border color
                                        width: 0.5, // Border width
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              sharedUtility.isDarkModeEnabled()
                                                  ? kBlackColor.withOpacity(0.5)
                                                  : klightGreyColor
                                                      .withOpacity(0.5), //
                                          spreadRadius: 0,
                                          blurRadius: 3,
                                          offset: Offset(1,
                                              2), // changes the shadow position
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        AnimatedSearchTextResponseWidget(
                                          displayText:
                                              chatResponseModel.message,
                                          shouldAnimated: !chatResponseModel
                                              .isAnimationCompleted,
                                          maxWidth: ScreenUtil().screenWidth,
                                          onCompletedAnimation: () {
                                            print("Scrolll to bottom");
                                            setState(() {
                                              chatResponseList[index]
                                                  .isAnimationCompleted = true;
                                            });

                                            // chatResponseModel.isAnimationCompleted = true;
                                            _scrollToBottom();
                                          },
                                        ),
                                        Divider(
                                          color:
                                              sharedUtility.isDarkModeEnabled()
                                                  ? klightGreyColor
                                                  : klightGreyColor,
                                        ),
                                        FutureBuilder(
                                            future: FavoriteService()
                                                .isFavorited(
                                                    question: chatResponseModel
                                                        .question,
                                                    role: widget
                                                        .selectedUserRole),
                                            builder: (context, dataSnapshot) {
                                              return Container(
                                                padding: EdgeInsets.zero,
                                                child: Row(children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      if (dataSnapshot
                                                              .hasData &&
                                                          dataSnapshot.data ==
                                                              true) {
                                                        if (widget.selectedQuestion !=
                                                                null &&
                                                            widget.selectedUserRole !=
                                                                null) {
                                                          FavoriteService()
                                                              .deleteFavorite(
                                                            question:
                                                                chatResponseModel
                                                                    .question,
                                                            roleName: widget
                                                                .selectedUserRole!,
                                                          );
                                                          setState(() {});
                                                        }
                                                      } else {
                                                        if (widget.selectedQuestion !=
                                                                null &&
                                                            widget.selectedUserRole !=
                                                                null) {
                                                          FavoriteService()
                                                              .addUserFavorite(
                                                            question:
                                                                chatResponseModel
                                                                    .question,
                                                            answer:
                                                                chatResponseModel
                                                                    .message,
                                                            roleName: widget
                                                                .selectedUserRole!,
                                                          );
                                                          setState(() {});
                                                        }
                                                      }
                                                      // Future.delayed(
                                                      //     Duration(milliseconds: 500),
                                                      //     () {
                                                      //   updateFavoriteState();
                                                      // });
                                                    },
                                                    icon: (dataSnapshot
                                                                .hasData &&
                                                            dataSnapshot.data ==
                                                                true)
                                                        ? Icon(
                                                            Icons.favorite,
                                                            size: 27.h,
                                                            color: sharedUtility
                                                                    .isDarkModeEnabled()
                                                                ? kWhiteColor
                                                                : kBlackColor,
                                                          )
                                                        : Icon(
                                                            Icons
                                                                .favorite_outline,
                                                            size: 27.h,
                                                            color: sharedUtility
                                                                    .isDarkModeEnabled()
                                                                ? klightGreyColor
                                                                : kBlackColor,
                                                          ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      selectAllAndCopy(
                                                          chatResponseModel
                                                              .message);
                                                    },
                                                    icon: Icon(
                                                      Icons.copy,
                                                      size: 27.h,
                                                      color: sharedUtility
                                                              .isDarkModeEnabled()
                                                          ? klightGreyColor
                                                          : kBlackColor,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      // Regenerate response
                                                      /// delete all questions below it an regenrate

                                                      print(
                                                          "ID ${chatResponseModel.id}");

                                                      deleteRestFromBelowAndFetchAnswer(
                                                          chatResponseModel);
                                                    },
                                                    icon: Icon(
                                                      size: 27.h,
                                                      Icons.sync,
                                                      color: sharedUtility
                                                              .isDarkModeEnabled()
                                                          ? klightGreyColor
                                                          : kBlackColor,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    iconSize: 25.h,
                                                    onPressed: () {
                                                      setState(() {
                                                        chatResponseList[index]
                                                                .isDalleImageGenerated =
                                                            true;
                                                      });
                                                      fetchGeneratedImage(
                                                          chatResponseModel);
                                                    },
                                                    icon: Icon(
                                                      Icons.image_rounded,
                                                      color: chatResponseList[
                                                                  index]
                                                              .isDalleImageGenerated
                                                          ? kPrimary500Color
                                                          : sharedUtility
                                                                  .isDarkModeEnabled()
                                                              ? klightGreyColor
                                                              : kBlackColor,
                                                    ),
                                                  ),
                                                ]),
                                              );
                                            }),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 70.0.h,
                                ),
                              ],
                            ),
                          );
                        } else if (chatResponseModel.chatResponseType ==
                            ChatResponseType.gen_image) {
                          return Column(
                            children: [
                              SizedBox(
                                height: 20.h,
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 5.0),
                                        decoration: BoxDecoration(
                                          color: sharedUtility
                                                  .isDarkModeEnabled()
                                              ? kBlackColor
                                              : kWhiteColor, // Container background color
                                          borderRadius: BorderRadius.circular(
                                              15), // Adjust the radius as needed
                                          border: Border.all(
                                            color: sharedUtility
                                                    .isDarkModeEnabled()
                                                ? kWhiteColor
                                                : klightGreyColor, // Border color
                                            width: 0.5, // Border width
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: sharedUtility
                                                      .isDarkModeEnabled()
                                                  ? kWhiteColor.withOpacity(0.5)
                                                  : klightGreyColor
                                                      .withOpacity(0.5), //
                                              spreadRadius: 0,
                                              blurRadius: 3,
                                              offset: Offset(1,
                                                  2), // changes the shadow position
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 5,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        FullScreenChatImage(
                                                      imageUrl:
                                                          chatResponseModel
                                                              .message,
                                                    ), // Replace with your image URL
                                                  ),
                                                );
                                              },
                                              child: Hero(
                                                tag:
                                                    'chatImageTag', // Unique tag for the hero animation
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      chatResponseModel.message,
                                                  placeholder: (context, url) =>
                                                      Center(
                                                    child: AppLoadingAnimation(
                                                      size: 75.h,
                                                    ),
                                                  ), // Placeholder widget while loading
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Row(
                                                    children: [
                                                      Icon(
                                                        Icons.error,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 248, 111, 101),
                                                      ),
                                                      Text(
                                                        "  Unable to generate an image.",
                                                        style: TextStyle(
                                                            color: const Color
                                                                .fromARGB(255,
                                                                248, 111, 101),
                                                            fontSize: 14.sp),
                                                      )
                                                    ],
                                                  ),
                                                ), // Replace with your image URL
                                              ),
                                            ),
                                            Visibility(
                                              visible: chatResponseModel
                                                  .message.isNotEmpty,
                                              child: Column(
                                                children: [
                                                  Divider(
                                                    color: sharedUtility
                                                            .isDarkModeEnabled()
                                                        ? kWhiteColor
                                                        : klightGreyColor,
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.zero,
                                                    child: Row(children: [
                                                      IconButton(
                                                        onPressed: () {
                                                          _shareImage(
                                                            chatResponseModel
                                                                .message,
                                                          );
                                                        },
                                                        icon: Icon(
                                                          Icons.share,
                                                          color: sharedUtility
                                                                  .isDarkModeEnabled()
                                                              ? kWhiteColor
                                                              : kBlackColor,
                                                        ),
                                                      ),
                                                    ]),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 70.0,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        } else if (chatResponseModel.chatResponseType ==
                            ChatResponseType.loading) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 20.h,
                              ),
                              Row(
                                children: [
                                  DotLoadingAnimationWidget(),
                                  Spacer()
                                ],
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                ),
                // SizedBox(
                //   height: 30,
                // ),

                Container(
                  color: sharedUtility.isDarkModeEnabled()
                      ? kBlackColor
                      : klightGreyBGColor,
                  height: 92,
                  child: Column(
                    children: [
                      Divider(
                        color: sharedUtility.isDarkModeEnabled()
                            ? klightGreyColor
                            : klightGreyColor,
                        height: 0.2,
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 10.0,
                          left: 10.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                child: TextField(
                                  minLines: 1,
                                  maxLines: 3,
                                  autofocus: true,
                                  textAlign: TextAlign.left,
                                  controller: _searchCtrl,
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) {
                                    setState(() {
                                      isAskQuestionButtonDisabled =
                                          _searchCtrl.text.isEmpty;
                                    });
                                  },
                                  style: sharedUtility.isDarkModeEnabled()
                                      ? kMedium14TextStyleDark
                                      : kMedium14TextStyle,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: sharedUtility.isDarkModeEnabled()
                                            ? kWhiteColor
                                            : klightGreyColor,
                                        width: 1,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color:
                                              sharedUtility.isDarkModeEnabled()
                                                  ? klightGreyColorDark
                                                  : klightGreyColor),
                                    ),
                                    hintText: 'Ask Anything',
                                    hintStyle: sharedUtility.isDarkModeEnabled()
                                        ? kRegularPrimaryColorTextStyleDark
                                        : kRegularPrimaryColorTextStyle,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: sharedUtility.isDarkModeEnabled()
                                            ? kBlackColor
                                            : klightGreyColor,
                                        width: 1,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    filled: true,
                                    contentPadding: EdgeInsets.all(10),
                                    fillColor: sharedUtility.isDarkModeEnabled()
                                        ? kBlackColor
                                        : kWhiteColor,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                !_isListening ? Icons.mic_off : Icons.mic,
                                color: kPrimary500Color,
                                size: 22.h,
                              ),
                              onPressed: _speech.isListening
                                  ? _stopListening
                                  : _startListening,
                            ),

                            IconButton(
                              onPressed: () {
                                if (_searchCtrl.text.isNotEmpty) {
                                  fetchAnswer(_searchCtrl.text);
                                }
                              },
                              icon: _searchCtrl.text.isNotEmpty
                                  ? Image.asset(
                                      "assets/send-message-icon.png",
                                      height: 25.h,
                                      width: 27.w,
                                    )
                                  : Image.asset(
                                      "assets/send-message-icon-disabled.png",
                                      width: 27.w,
                                      height: 25.h,
                                    ),
                            ),

                            // IconButton(
                            //   onPressed: () {
                            //     if (_searchCtrl.text.isNotEmpty) {
                            //       fetchAnswer(_searchCtrl.text);
                            //     }
                            //   },
                            //   iconSize: 10.0,
                            //   icon: _searchCtrl.text.isNotEmpty
                            //       ? Image.asset("assets/send-message-icon.png")
                            //       : Image.asset(
                            //           "assets/send-message-icon-disabled.png"),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                /*
              Container(
                color: sharedUtility.isDarkModeEnabled()
                    ? kBlackColor
                    : klightGreyBGColor,
                height: 92,
                child: Column(
                  children: [
                    Divider(
                      color: sharedUtility.isDarkModeEnabled()
                          ? kWhiteColor
                          : klightGreyColor,
                      height: 0.2,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 10.0,
                        left: 10.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextField(
                              minLines: 1,
                              maxLines: 3,
                              autofocus: true,
                              textAlign: TextAlign.left,
                              controller: _searchCtrl,
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                setState(() {
                                  isAskQuestionButtonDisabled =
                                      _searchCtrl.text.isEmpty;
                                });
                              },
                              style: sharedUtility.isDarkModeEnabled()
                                  ? kMedium14TextStyleDark
                                  : kMedium14TextStyle,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: sharedUtility.isDarkModeEnabled()
                                        ? kWhiteColor
                                        : klightGreyColor,
                                    width: 1,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: sharedUtility.isDarkModeEnabled()
                                          ? klightGreyColorDark
                                          : klightGreyColor),
                                ),
                                hintText: 'Ask Anything',
                                hintStyle: sharedUtility.isDarkModeEnabled()
                                    ? kRegularPrimaryColorTextStyleDark
                                    : kRegularPrimaryColorTextStyle,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: sharedUtility.isDarkModeEnabled()
                                        ? kBlackColor
                                        : klightGreyColor,
                                    width: 1,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                filled: true,
                                fillColor: sharedUtility.isDarkModeEnabled()
                                    ? kBlackColor
                                    : kWhiteColor,
                              ),
                            ),
                            
                          ),
                          IconButton(
                            onPressed: () {
                              if (_searchCtrl.text.isNotEmpty) {
                                fetchAnswer(_searchCtrl.text);
                              }
                            },
                            icon: _searchCtrl.text.isNotEmpty
                                ? Image.asset("assets/send-message-icon.png")
                                : Image.asset(
                                    "assets/send-message-icon-disabled.png"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              */
              ],
            ),
            Visibility(
              visible: showScrollToBottomButton,
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: 75.0.h,
                    ),
                    child: IconButton(
                      iconSize: 40,
                      onPressed: () {
                        _scrollToBottom();
                      },
                      icon: Icon(
                        Icons.arrow_circle_down,
                        color: sharedUtility.isDarkModeEnabled()
                            ? kWhiteColor
                            : kBlackColor,
                      ),
                    ),
                  )),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                //color: Colors.amber,
                color: sharedUtility.isDarkModeEnabled()
                    ? kBlackColor
                    : kWhiteColor,
                height: 62.0.h,
                width: ScreenUtil().screenWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios,
                              color: sharedUtility.isDarkModeEnabled()
                                  ? kWhiteColor
                                  : kBlackColor),
                          iconSize: 27.h,
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                        ),
                        Expanded(
                          //  flex: 4,
                          child: Text(
                            widget.selectedUserRole ?? "",
                            textAlign: TextAlign.center,
                            style: sharedUtility.isDarkModeEnabled()
                                ? kSemiBold18TextStyleDark
                                : kSemiBold18TextStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width: 30.w,
                        ),
                      ],
                    ),
                    //Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Icon _getDalleImageIcon(SharedUtility sharedUtility) {
    return Icon(
      Icons.image_rounded,
      color: sharedUtility.isDarkModeEnabled() ? klightGreyColor : kBlackColor,
    );
  }

  void _shareImage(String imageUrl) async {
    //String imagePath = await _saveImageToTempDirectory(imageUrl);
    print(imageUrl);
    Share.shareUri(Uri.parse(imageUrl));
  }

  // Future<String> _saveImageToTempDirectory(String imageUrl) async {
  //   final response = await http.get(Uri.parse(
  //     imageUrl,
  //   )); // Use your method to fetch image
  //   final Directory tempDir = await getTemporaryDirectory();
  //   final File imageFile = File('${tempDir.path}/image.jpg');
  //   await imageFile.writeAsBytes(response.bodyBytes);
  //   return imageFile.path;
  // }
}
