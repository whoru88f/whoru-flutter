import 'package:chatapp/common/utility/shared_utility.dart';
import 'package:chatapp/features/favorites/favorite_service.dart';
import 'package:chatapp/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatapp/features/common_widgets/no-internet-widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavoriteDetailsPage extends ConsumerStatefulWidget {
  final String question;
  final String answer;
  final String role;

  const FavoriteDetailsPage({
    required this.question,
    required this.answer,
    required this.role,
    super.key,
  });

  @override
  ConsumerState<FavoriteDetailsPage> createState() =>
      _FavoriteDetailsPageState();
}

class _FavoriteDetailsPageState extends ConsumerState<FavoriteDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final sharedUtility = ref.read(sharedUtilityProvider);
    return Scaffold(
      backgroundColor:
          sharedUtility.isDarkModeEnabled() ? kBlackColor : kWhiteColor,
      body: SafeArea(
        child: Stack(children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 60.0.h,
                  ),
                  GestureDetector(
                    onLongPress: () {
                      Clipboard.setData(ClipboardData(text: widget.answer));

                      // Optionally, provide user feedback
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Question copied to clipboard'),
                        ),
                      );
                    },
                    child: Text(
                      widget.question,
                      style: sharedUtility.isDarkModeEnabled()
                          ? kSemiBold21BlacTextStyleDark
                          : kSemiBold21BlacTextStyle,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  GestureDetector(
                    onLongPress: () {
                      Clipboard.setData(ClipboardData(text: widget.answer));

                      // Optionally, provide user feedback
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Answer copied to clipboard'),
                        ),
                      );
                    },
                    child: Text(
                      widget.answer,
                      style: sharedUtility.isDarkModeEnabled()
                          ? kRegular15BlackTextStyleDark
                          : kRegular15BlackTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              height: 49.0.h,
              width: ScreenUtil().screenWidth,
              child: Column(
                children: [
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          size: 27.h,
                          color: kPrimary500Color,
                        ),
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                      ),

                      // IconButton(
                      //   onPressed: () {},
                      //   icon: Icon(Icons.favorite),
                      // ),
                      // Spacer(),
                      // Text("data"),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            widget.role ?? "",
                            style: sharedUtility.isDarkModeEnabled()
                                ? kSemiBold18TextStyleDark
                                : kSemiBold18TextStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          // Navigator.of(context)
                          //   .popUntil((route) => route.isFirst);
                          FavoriteService().deleteFavorite(
                            question: widget.question,
                            roleName: widget.role,
                          );
                          Future.delayed(Duration(milliseconds: 500), () {
                            Navigator.of(context).pop(true);
                          });
                        },
                        icon: Icon(
                          Icons.favorite,
                          size: 27.h,
                          color: kPrimary500Color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
