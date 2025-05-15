import 'package:flutter/material.dart';
import 'package:taskit_app/utils/theme.dart';

class AppLabelText extends StatelessWidget {
  const AppLabelText({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 4, bottom: 8),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppTheme.of(context).colors.primaryTextColor,
          ),
        ),
      ),
    );
  }
}