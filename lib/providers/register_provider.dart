import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:taskit_app/helper/navigation_helper.dart';
import 'package:taskit_app/providers/auth_provider.dart';
import 'package:taskit_app/widgets/dialog_app.dart';

class RegisterProvider with ChangeNotifier {
  bool isRegister = false;
  bool isLoading = false;
  bool isEmailValid = false;
  bool isPasswordValid = false;
  bool isConfirmPasswordValid = false;
  bool isError = false;
  bool obscurePassword = true;
  bool obsecureConfirmPassword = true;
  String? errorMessage;
  User? user;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>(
    debugLabel: 'registerFormKey',
  );
  final AppAuthProvider authProvider = AppAuthProvider();
  final NavigationHelper navigationHelper = NavigationHelper();

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    obsecureConfirmPassword = !obsecureConfirmPassword;
    notifyListeners();
  }

  String? validateName(String name) {
    if (name.isEmpty) {
      errorMessage = 'Nama tidak boleh kosong';
      isError = true;
      notifyListeners();
      return errorMessage;
    } else if (name.length < 3) {
      errorMessage = 'Nama minimal 3 karakter';
      isError = true;
      notifyListeners();
      return errorMessage;
    } else {
      errorMessage = null;
      isError = false;
      notifyListeners();
      return null;
    }
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
    } else if (password.length < 6) {
      errorMessage = 'Password minimal 6 karakter';
      isPasswordValid = false;
      return errorMessage;
    } else {
      errorMessage = null;
      isPasswordValid = true;
      return null;
    }
  }

  String? validateConfirmPassword(String password, String confirmPassword) {
    if (password != confirmPassword) {
      errorMessage = 'Konfirmasi password tidak sama';
      isConfirmPasswordValid = false;
      notifyListeners();
      return errorMessage;
    } else {
      errorMessage = null;
      isConfirmPasswordValid = true;
      notifyListeners();
      return null;
    }
  }

  Future<void> register(BuildContext? context) async {
    if (registerFormKey.currentState?.validate() ?? false) {
      final currentContext = context;
      final name = nameController.text.trim();
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      isLoading = true;
      notifyListeners();
      try {
        final isSignUpSuccessful = await authProvider.signUpWithEmail(
          email: email,
          password: password,
        );

        if (isSignUpSuccessful) {
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            await user.updateDisplayName(name);

            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .set({
                  'name': name,
                  'email': email,
                  'createdAt': FieldValue.serverTimestamp(),
                });

            isRegister = true;
            isLoading = false;
            notifyListeners();
            authProvider.logout();
            if (currentContext != null && context != null && context.mounted) {
              AppDialog.showSuccessDialog(
                context: currentContext,
                message: "Registrasi berhasil, silahkan login!",
                onConfirm: () {
                  navigationHelper.safeNavigate(currentContext, '/login');
                },
              );
            }
          } else {
            throw Exception('Failed to retrieve user after registration');
          }
        }
      } catch (e) {
        if (currentContext != null && context != null && context.mounted) {
          AppDialog.showErrorDialogSafely(
            context: currentContext,
            title: 'Registration Failed',
            message: e.toString(),
          );
        }
        isError = true;
        isLoading = false;
        notifyListeners();
      }
    }
  }

  void resetFormState() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    isRegister = false;
    isLoading = false;
    isEmailValid = false;
    isPasswordValid = false;
    isConfirmPasswordValid = false;
    isError = false;
    obscurePassword = true;
    obsecureConfirmPassword = true;
    errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    resetFormState();
    super.dispose();
  }
}
