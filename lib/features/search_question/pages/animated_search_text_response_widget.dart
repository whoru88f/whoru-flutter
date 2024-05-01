import 'dart:async';
import 'package:chatapp/common/utility/shared_utility.dart';
import 'package:chatapp/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class AnimatedSearchTextResponseWidget extends ConsumerStatefulWidget {
  final String displayText;
  final bool shouldAnimated;
  final double maxWidth;
  final Function onCompletedAnimation;
  AnimatedSearchTextResponseWidget({
    required this.displayText,
    required this.shouldAnimated,
    required this.maxWidth,
    required this.onCompletedAnimation,
    super.key,
  });

  @override
  ConsumerState<AnimatedSearchTextResponseWidget> createState() =>
      _AnimatedSearchTextResponseWidgetState();
}

class _AnimatedSearchTextResponseWidgetState
    extends ConsumerState<AnimatedSearchTextResponseWidget> {
  //Rect? _textRect;

  String textToDisplay = "";
  bool _canVibrate = true;
  late double maxWidthForText;

  // final String sampleText =
  //     displ

  int maxCharactersPerLine = 0;

  @override
  void initState() {
    super.initState();
    maxWidthForText = widget.maxWidth - 45.0;
    _vibrateInit();
    if (widget.shouldAnimated) {
      _startTypingAnimation(widget.displayText);
    } else {
      textToDisplay = widget.displayText;
    }

    calculateMaxCharactersPerLine(widget.displayText);
  }

  void calculateMaxCharactersPerLine(String displayText) {
    final double availableWidth = maxWidthForText;
    final int textLength = displayText.length;

    for (int i = textLength; i >= 0; i--) {
      final String substring = displayText.substring(0, i);

      final TextPainter textPainter = TextPainter(
        text: TextSpan(text: substring, style: kRegular15TextStyle),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      if (textPainter.width <= availableWidth) {
        setState(() {
          maxCharactersPerLine = i;
        });
        break;
      }
    }
    print("maxCharactersPerLine $maxCharactersPerLine");
  }
  // @override
  // void initState() {
  //   super.initState();
  //   //  WidgetsBinding.instance?.addObserver(this);
  //   // Check for height changes every 500 milliseconds
  //   // Timer.periodic(Duration(milliseconds: 500), (timer) {
  //   //   observeHeightChanges();
  //   // });
  //   _vibrateInit();
  //   _startTypingAnimation(widget.displayText);
  // }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance?.removeObserver(this);
  //   super.dispose();
  // }

  // @override
  // void didChangeMetrics() {
  //   observeHeightChanges();
  // }

  // void observeHeightChanges() {
  //   final RenderBox renderBox =
  //       _textKey.currentContext?.findRenderObject() as RenderBox;
  //   final double currentHeight = renderBox.size.height;

  //   if (_previousHeight != null && currentHeight != _previousHeight) {
  //     // Height has changed, perform actions here
  //     print('Text height changed: $_previousHeight -> $currentHeight');
  //   }

  //   setState(() {
  //     _previousHeight = currentHeight;
  //   });
  // }
  // void updateTextRect() {
  //   final RenderBox renderBox =
  //       _textKey.currentContext?.findRenderObject() as RenderBox;
  //   // setState(() {
  //   final textRect = renderBox.localToGlobal(Offset.zero) & renderBox.size;
  //   print("textRect ${textRect.size.height}");
  //   // });
  // }

  Future<void> _vibrateInit() async {
    bool canVibrate = await Vibrate.canVibrate;
    setState(() {
      _canVibrate = canVibrate;
      _canVibrate
          ? debugPrint('This device can vibrate')
          : debugPrint('This device cannot vibrate');
    });
  }

  void _startTypingAnimation(String displayText) {
    String textToType = displayText;

    print('textToType! ${textToType.length}');

    for (int i = 0; i < textToType.length; i++) {
      Future.delayed(Duration(milliseconds: 10 * i), () {
        setState(() {
          textToDisplay = textToType.substring(0, i + 1);

          // print('*** $textToDisplay ***');
          // Check if a new line is entered
          //  print('${textToDisplay.length % maxWidthForText < 5}');
          if (textToDisplay.length % maxCharactersPerLine == 0) {
            // print(
            //   'New line entered! ${textToDisplay.length} -- $maxWidthForText');
            widget.onCompletedAnimation();
          }
        });
        // Trigger vibration on each character typed
        if (_canVibrate) Vibrate.feedback(FeedbackType.light);
        // if (i == textToType.length - 1) {
        //   print("i excedded limit ");
        //   // widget.onCompletedAnimation();
        // }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sharedUtility = ref.read(sharedUtilityProvider);
    return Text(
      textToDisplay,
      style: sharedUtility.isDarkModeEnabled()
          ? kRegular15BlackTextStyleDark
          : kRegular15BlackTextStyle,
    );
  }
}
