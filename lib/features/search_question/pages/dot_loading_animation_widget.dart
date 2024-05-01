import 'package:chatapp/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DotLoadingAnimationWidget extends ConsumerStatefulWidget {
  const DotLoadingAnimationWidget({super.key});

  @override
  ConsumerState<DotLoadingAnimationWidget> createState() =>
      _DotLoadingAnimationWidgetState();
}

class _DotLoadingAnimationWidgetState
    extends ConsumerState<DotLoadingAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0.5, end: 1.5).animate(_controller);

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return Text(
    //   "Loading...",
    //   style: TextStyle(
    //     fontStyle: FontStyle.italic,
    //   ),
    // );
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: Container(
            margin: EdgeInsets.only(
              top: 10,
              bottom: 5,
              left: 10,
            ),
            width: 15.0.w,
            height: 15.0.h,
            decoration: BoxDecoration(
              color: kPrimary500Color,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}
