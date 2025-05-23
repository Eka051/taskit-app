import 'package:flutter/material.dart';
import 'package:taskit_app/helper/navigation_helper.dart';
import 'package:taskit_app/providers/auth_provider.dart';
import 'package:taskit_app/widgets/dialog_app.dart';

class LoginProvider with ChangeNotifier {
  bool isLoggedIn = false;
  bool isLoading = false;
  bool isEmailValid = false;
  bool isPasswordValid = false;
  bool isError = false;
  bool obscurePassword = true;
  String? errorMessage;

  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>(
    debugLabel: 'loginFormKey',
  );
  final AppAuthProvider appAuthProvider = AppAuthProvider();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final navigationHelper = NavigationHelper();

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  String? validateEmail(String email) {
    if (email.isEmpty) {
      errorMessage = 'Email tidak boleh kosong';
      isEmailValid = false;
      return errorMessage;
    } else if (!RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email)) {
      errorMessage = 'Format email tidak valid';
      isEmailValid = false;
      return errorMessage;
    } else {
      errorMessage = null;
      isEmailValid = true;
      return null;
    }
  }

  String? validatePassword(String password) {
    if (password.isEmpty) {
      errorMessage = 'Password tidak boleh kosong';
      isPasswordValid = false;
      return errorMessage;
    } else {
      errorMessage = null;
      isPasswordValid = true;
      return null;
    }
  }

  Future<void> login(BuildContext context) async {
    if (loginFormKey.currentState?.validate() ?? false) {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      isLoading = true;
      notifyListeners();
      try {
        final loginSuccess = await appAuthProvider.login(
          email: email,
          password: password,
        );

        if (loginSuccess) {
          isLoggedIn = true;
          isLoading = false;
          notifyListeners();

          AppDialog.showSuccessDialog(
            context: context,
            title: 'Login Berhasil',
            message:
                'Selamat datang ${appAuthProvider.user?.displayName ?? "kembali"}!',
          );
          Future.delayed(Duration(milliseconds: 1500), () {
            if (context.mounted) {
              Navigator.pushReplacementNamed(context, '/home');
            }
          });
        } else {
          isLoading = false;
          isLoggedIn = false;
          isError = true;
          errorMessage = appAuthProvider.errorMessage;
          notifyListeners();
          AppDialog.showErrorDialogSafely(
            context: context,
            title: 'Login Gagal',
            message: "$errorMessage",
          );
        }
      } catch (e) {
        isLoading = false;
        isError = true;
        errorMessage = e.toString();
        notifyListeners();
        AppDialog.showErrorDialogSafely(
          context: context,
          message: errorMessage!,
          title: 'Login Gagal',
          onConfirm: () {
            Navigator.of(context).pop();
          },
        );
      }
    } else {
      isError = true;
      notifyListeners();
    }
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      final success = await appAuthProvider.loginWithGoogle();

      if (success) {
        isLoggedIn = true;
        isLoading = false;
        notifyListeners();
        Navigator.pushReplacementNamed(context, '/home');
        AppDialog.showSuccessDialog(
          context: context,
          title: 'Login Berhasil',
          message:
              'Selamat datang ${appAuthProvider.user?.displayName ?? "kembali"}!',
        );
      } else {
        isLoading = false;
        isError = true;
        errorMessage = appAuthProvider.errorMessage;
        notifyListeners();

        AppDialog.showErrorDialogSafely(
          context: context,
          message: errorMessage ?? 'Login dengan Google gagal',
          title: 'Login Gagal',
        );
      }
    } catch (e) {
      isLoading = false;
      isError = true;
      errorMessage = e.toString();
      notifyListeners();
      AppDialog.showErrorDialogSafely(
        context: context,
        message: errorMessage!,
        title: 'Login Gagal',
        onConfirm: () {
          Navigator.of(context).pop();
        },
      );
    }
  }

  Future<void> logout(BuildContext context) async {
    await AppDialog.showConfirmationDialog(
      context: context,
      title: 'Keluar Dari Aplikasi?',
      message: 'Apakah Anda yakin ingin keluar dari aplikasi?',
      onConfirm: () {
        resetForm();
        appAuthProvider.logout();
        isLoggedIn = false;
        isLoading = false;
        notifyListeners();
        navigationHelper.safeNavigate(context, '/login');
      },
      onCancel: () {},
    );
  }

  void resetForm() {
    loginFormKey = GlobalKey<FormState>(
      debugLabel: 'loginFormKey',
    );
    emailController.clear();
    passwordController.clear();
    isEmailValid = false;
    isPasswordValid = false;
    errorMessage = null;
    isError = false;
    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    resetForm();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
