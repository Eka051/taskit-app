import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:taskit_app/helper/navigation_helper.dart';
import 'package:taskit_app/providers/register_provider.dart';
import 'package:taskit_app/utils/const.dart';
import 'package:taskit_app/utils/theme.dart';
import 'package:taskit_app/widgets/app_label.dart';
import 'package:taskit_app/widgets/back_button.dart';
import 'package:taskit_app/widgets/primary_button.dart';
import 'package:taskit_app/widgets/textform.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final registerProvider = Provider.of<RegisterProvider>(context);
    final navigationHelper = NavigationHelper();
    final isLoading = registerProvider.isLoading;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: theme.colors.background,
          appBar: AppBar(
            backgroundColor: theme.colors.background,
            elevation: 0,
            leading: AppBackButton(
              onPressed: () {
                navigationHelper.safeNavigate(context, '/login');
              },
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: theme.spacing.lg,
                  vertical: theme.spacing.xl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/object-2.png',
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(height: 12),
                    Form(
                      key: registerProvider.registerFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.signUp,
                            style: theme.textStyle.headlineMedium.copyWith(
                              color: theme.colors.primaryTextColor,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            AppStrings.signUpSubtitle,
                            style: theme.textStyle.bodyMedium.copyWith(
                              color: theme.colors.secondaryTextColor,
                            ),
                          ),
                          const SizedBox(height: 24),
                          AppLabelText(text: AppStrings.name),
                          AppTextFormField(
                            controller: registerProvider.nameController,
                            hintText: 'Input your name',
                            prefixIcon: Icons.person_outline_rounded,
                            keyboardType: TextInputType.name,
                            validator:
                                (value) =>
                                    registerProvider.validateName(value!),
                          ),
                          const SizedBox(height: 16),
                          AppLabelText(text: AppStrings.email),
                          AppTextFormField(
                            controller: registerProvider.emailController,
                            hintText: 'Input your email',
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator:
                                (value) =>
                                    registerProvider.validateEmail(value!),
                          ),
                          const SizedBox(height: 16),
                          AppLabelText(text: AppStrings.password),
                          AppTextFormField(
                            controller: registerProvider.passwordController,
                            hintText: 'Input your password',
                            prefixIcon: Icons.lock_outline_rounded,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: registerProvider.obscurePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                registerProvider.obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed:
                                  registerProvider.togglePasswordVisibility,
                            ),
                            validator:
                                (value) =>
                                    registerProvider.validatePassword(value!),
                          ),
                          const SizedBox(height: 16),
                          AppLabelText(text: AppStrings.confirmPassword),
                          AppTextFormField(
                            controller:
                                registerProvider.confirmPasswordController,
                            hintText: 'Input your password again',
                            prefixIcon: Icons.lock_outline_rounded,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText:
                                registerProvider.obsecureConfirmPassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                registerProvider.obsecureConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed:
                                  registerProvider
                                      .toggleConfirmPasswordVisibility,
                            ),
                            validator:
                                (value) =>
                                    registerProvider.validateConfirmPassword(
                                      registerProvider.passwordController.text,
                                      value!,
                                    ),
                          ),
                          const SizedBox(height: 30),
                          PrimaryButton(
                            onPressed:
                                isLoading
                                    ? null
                                    : () {
                                      registerProvider.register(context);
                                    },
                            isLoading: isLoading,
                            text: AppStrings.signUp,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppStrings.alreadyHaveAccount,
                                style: theme.textStyle.bodyMedium.copyWith(
                                  color: theme.colors.secondaryTextColor,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  navigationHelper.safeNavigate(
                                    context,
                                    '/login',
                                  );
                                },
                                child: Text(
                                  AppStrings.login,
                                  style: theme.textStyle.bodyMedium.copyWith(
                                    color: theme.colors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
