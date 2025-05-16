import 'package:flutter/material.dart';
import 'package:taskit_app/utils/theme.dart';

class PrimaryButton extends StatelessWidget {
  final bool isLoading;
  final int height;
  final int width;
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final VoidCallback? onPressed;
  final Color? progressIndicatorColor;
  final double? progressIndicatorSize;
  final double progressIndicatorStrokeWidth;
  final Widget? progressIndicatorWidget;

  const PrimaryButton({
    super.key,
    this.isLoading = false,
    required this.onPressed,
    this.height = 56,
    this.width = 0,
    this.text = '',
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.fontSize,
    this.fontWeight,

    this.progressIndicatorColor,
    this.progressIndicatorSize = 24,
    this.progressIndicatorStrokeWidth = 2,
    this.progressIndicatorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height.toDouble(),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              backgroundColor ?? AppTheme.of(context).colors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppTheme.of(context).radius.allMd,
          ),
          side: BorderSide(
            color: borderColor ?? AppTheme.of(context).colors.primary,
            width: 1,
          ),
        ),
        child:
            isLoading
                ? progressIndicatorWidget ??
                    SizedBox(
                      width: progressIndicatorSize,
                      height: progressIndicatorSize,
                      child: CircularProgressIndicator(
                        color: progressIndicatorColor ?? Colors.white,
                        strokeWidth: progressIndicatorStrokeWidth,
                      ),
                    )
                : Text(
                  text,
                  style: AppTheme.of(context).textStyle.titleLarge.copyWith(
                    color: textColor ?? Colors.white,
                    fontWeight: fontWeight ?? FontWeight.w600,
                    fontSize: fontSize ?? 16,
                  ),
                ),
      ),
    );
  }
}
