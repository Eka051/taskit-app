import 'package:flutter/material.dart';

class NavigationHelper {
  void safeNavigate(BuildContext context, String routeName) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, routeName);
    });
  }

  void safeNavigateWithArguments(
    BuildContext context,
    String routeName,
    Object arguments,
  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
    });
  }
}
