import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:saatmenumobileapp/helper/utils/colors.dart';

class LoadingWidget extends StatelessWidget {
  final Color? overlayColor;
  final double blurIntensity;
  
  const LoadingWidget({
    super.key,
    this.overlayColor,
    this.blurIntensity = 5.0,
  });

  @override
  Widget build(BuildContext context) {
    Widget loadingContent = Center(
      child: CircularProgressIndicator(
        color: primaryColor,
      ),
    );

    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: blurIntensity,
        sigmaY: blurIntensity,
      ),
      child: Container(
        color: overlayColor ?? Colors.black.withOpacity(0.2),
        child: loadingContent,
      ),
    );
  }
}

// Alternative version with more customization options
class CustomLoadingWidget extends StatelessWidget {
  final String? message;
  final Widget? customLoader;
  final double blurIntensity;
  final Color? overlayColor;
  final Color? textColor;
  final double? textSize;
  final EdgeInsets padding;
  
  const CustomLoadingWidget({
    Key? key,
    this.message,
    this.customLoader,
    this.blurIntensity = 5.0,
    this.overlayColor,
    this.textColor,
    this.textSize,
    this.padding = const EdgeInsets.all(20.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blurIntensity,
          sigmaY: blurIntensity,
        ),
        child: Container(
          color: overlayColor ?? Colors.black.withOpacity(0.2),
          child: Center(
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  customLoader ?? CircularProgressIndicator(
                    color: primaryColor,
                    strokeWidth: 3,
                  ),
                  if (message != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        message!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: textSize ?? 16,
                          color: textColor ?? Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}