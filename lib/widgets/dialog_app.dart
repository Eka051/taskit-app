import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:taskit_app/utils/theme.dart';

abstract class AppDialog {
  static void showErrorDialogSafely({
    required BuildContext context,
    required String message,
    String? title,
    VoidCallback? onConfirm,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showErrorDialog(
        context: context,
        message: message,
        title: title,
        onConfirm: onConfirm,
      );
    });
  }

  static Future<void> showErrorDialog({
    required BuildContext context,
    required String message,
    String? title,
    VoidCallback? onConfirm,
  }) async {
    Timer? autoCloseTimer;
    autoCloseTimer = Timer(const Duration(seconds: 10), () {
      Navigator.of(context, rootNavigator: true).maybePop();
    });

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (ctx) => Dialog(
            backgroundColor: Theme.of(ctx).scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            child: SizedBox(
              width: 320,
              height: 360,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      'assets/animations/error.json',
                      width: 100,
                      height: 100,
                    ),
                    Spacer(),
                    Text(
                      title ?? 'Error',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 250),
                      child: Text(
                        message,
                        style: const TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Spacer(),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          onConfirm?.call();
                          Navigator.of(ctx, rootNavigator: true).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('OK'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    ).then((_) => autoCloseTimer?.cancel());
  }

  static Future<void> showSuccessDialog({
    required BuildContext context,
    required String message,
    String? title,
    VoidCallback? onConfirm,
  }) async {
    return showDialog(
      context: context,
      builder:
          (ctx) => Dialog(
            backgroundColor: Theme.of(ctx).scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            child: SizedBox(
              width: 320,
              height: 340,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      'assets/animations/success.json',
                      width: 100,
                      height: 100,
                    ),
                    Spacer(),
                    Text(
                      title ?? 'Success',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      message,
                      style: const TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    Spacer(),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          onConfirm?.call();
                          Navigator.of(ctx, rootNavigator: true).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('OK'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  static Future<void> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
    String confirmText = 'OK',
    String cancelText = 'Cancel',
    int autoCloseTime = 10,
  }) async {
    Timer? autoCloseTimer;
    autoCloseTimer = Timer(Duration(seconds: autoCloseTime), () {
      Navigator.of(context, rootNavigator: true).maybePop();
    });

    return showDialog(
      context: context,
      builder:
          (ctx) => Dialog(
            backgroundColor: AppTheme.of(ctx).colors.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            child: SizedBox(
              width: 320,
              height: 340,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      'assets/animations/warning.json',
                      width: 100,
                      height: 100,
                      repeat: false,
                    ),
                    Spacer(),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      message,
                      style: const TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            autoCloseTimer?.cancel();
                            Navigator.of(ctx, rootNavigator: true).pop();
                            onCancel();
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: AppTheme.of(context).colors.danger,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: const Size(120, 50),
                          ),
                          child: Text(
                            cancelText,
                            style: AppTheme.of(
                              context,
                            ).textStyle.titleMedium.copyWith(
                              color: AppTheme.of(context).colors.danger,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            autoCloseTimer?.cancel();
                            Navigator.of(ctx, rootNavigator: true).pop();
                            onConfirm();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.of(context).colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: const Size(120, 50),
                          ),
                          child: Text(
                            confirmText,
                            style: AppTheme.of(
                              context,
                            ).textStyle.titleMedium.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
    ).then((_) => autoCloseTimer?.cancel());
  }

  static void closeDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).maybePop();
  }
}
