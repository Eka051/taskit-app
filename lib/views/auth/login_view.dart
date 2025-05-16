import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:taskit_app/helper/navigation_helper.dart';
import 'package:taskit_app/providers/auth_provider.dart';
import 'package:taskit_app/utils/const.dart';
import 'package:taskit_app/utils/theme.dart';
import 'package:taskit_app/widgets/app_label.dart';
import 'package:taskit_app/widgets/google_button.dart';
import 'package:taskit_app/widgets/textform.dart';
import '../../providers/login_provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final loginProvider = Provider.of<LoginProvider>(context);
    final isLoading = loginProvider.isLoading;
    final navigationHelper = NavigationHelper();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: theme.spacing.lg,
                  vertical: theme.spacing.xl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: theme.colors.primary.withAlpha(50),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            AppAssets.tLogo,
                            width: 50,
                            height: 50,
                            colorFilter: ColorFilter.mode(
                              theme.colors.primary,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      AppStrings.welcomeBack,
                      style: theme.textStyle.headlineMedium.copyWith(
                        color: theme.colors.onBackground,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      AppStrings.loginSubtitle,
                      style: theme.textStyle.bodyMedium.copyWith(
                        color: theme.colors.secondaryTextColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    Form(
                      key: loginProvider.loginFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppLabelText(text: AppStrings.email),
                          AppTextFormField(
                            controller: loginProvider.emailController,
                            keyboardType: TextInputType.emailAddress,
                            hintText: 'Enter your email',
                            prefixIcon: Icons.email_outlined,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator:
                                (value) =>
                                    loginProvider.validateEmail(value ?? ''),
                          ),
                          const SizedBox(height: 20),
                          AppLabelText(text: AppStrings.password),
                          AppTextFormField(
                            controller: loginProvider.passwordController,
                            hintText: 'Enter your password',
                            prefixIcon: Icons.lock_outline,
                            obscureText: loginProvider.obscurePassword,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            suffixIcon: IconButton(
                              icon: Icon(
                                loginProvider.obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: theme.colors.grey,
                              ),
                              onPressed: () {
                                loginProvider.togglePasswordVisibility();
                              },
                            ),
                            validator:
                                (value) =>
                                    loginProvider.validatePassword(value ?? ''),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed:
                                  isLoading
                                      ? null
                                      : () {
                                        loginProvider.login(context);
                                      },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colors.primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: theme.radius.allMd,
                                ),
                              ),
                              child:
                                  isLoading
                                      ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                      : Text(
                                        AppStrings.login,
                                        style: theme.textStyle.titleLarge
                                            .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: theme.colors.lightGrey,
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            AppStrings.orLoginWith,
                            style: TextStyle(
                              color: theme.colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: theme.colors.lightGrey,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    GoogleButton(
                      onPressed: () {
                        loginProvider.loginWithGoogle(context);
                      },
                      text: 'Login with Google',
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.dontHaveAccount,
                          style: theme.textStyle.bodyMedium.copyWith(
                            color: theme.colors.darkGrey,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            navigationHelper.safeNavigate(context, '/signUp');
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: theme.colors.primary,
                          ),
                          child: Text(
                            AppStrings.signUp,
                            style: theme.textStyle.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
