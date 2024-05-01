import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/features/common_widgets/app-loading-animation.dart';
import 'package:chatapp/features/user_role/pages/user_role_page.dart';
import 'package:chatapp/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:photo_view/photo_view.dart';

class FullScreenChatImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenChatImage({required this.imageUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              // Navigator.pop(context); // Pop the route to go back
            },
            child: Center(
              child: Hero(
                tag: 'chatImageTag', // Use the same tag as in the chat screen
                child: PhotoView(
                  loadingBuilder: (context, event) {
                    return AppLoadingAnimation(
                      size: 65.h,
                    );
                  },
                  imageProvider: NetworkImage(imageUrl), // Load image from URL
                  backgroundDecoration: BoxDecoration(
                    color: Colors.black, // Set background color
                  ),
                  minScale: PhotoViewComputedScale.contained *
                      0.8, // Set minimum scale
                  maxScale:
                      PhotoViewComputedScale.covered * 2.0, // Set maximum scale
                  enableRotation: true, // Enable rotation
                  initialScale:
                      PhotoViewComputedScale.contained, // Set initial scale
                ), // Display the full-screen image
              ),
            ),
          ),
          Positioned(
            top: 45,
            left: 5,
            child: RoundedIconButton(
              icon: Icons.arrow_back_ios,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class RoundedIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const RoundedIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.black.withOpacity(0.6), // Black background with opacity
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25.0),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              icon,
              color: Colors.white, // Icon color
              size: 24.0, // Icon size
            ),
          ),
        ),
      ),
    );
  }
}
