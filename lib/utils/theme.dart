import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  final BuildContext _context;

  AppTheme._(this._context);

  static AppTheme of(BuildContext context) {
    return AppTheme._(context);
  }

  static TextTheme createTextTheme(TextTheme base) {
    TextStyle withWeight(TextStyle? style, FontWeight weight) {
      return GoogleFonts.montserrat(textStyle: style, fontWeight: weight);
    }

    return GoogleFonts.manropeTextTheme(base).copyWith(
      displayLarge: withWeight(base.displayLarge, FontWeight.normal),
      displayMedium: withWeight(base.displayMedium, FontWeight.normal),
      displaySmall: withWeight(base.displaySmall, FontWeight.normal),
      headlineLarge: withWeight(base.headlineLarge, FontWeight.w800),
      headlineMedium: withWeight(base.headlineMedium, FontWeight.w700),
      headlineSmall: withWeight(base.headlineSmall, FontWeight.w600),
      titleLarge: withWeight(base.titleLarge, FontWeight.w500),
      titleMedium: withWeight(base.titleMedium, FontWeight.w600),
      titleSmall: withWeight(base.titleSmall, FontWeight.w500),
      bodyLarge: withWeight(base.bodyLarge, FontWeight.normal),
      bodyMedium: withWeight(base.bodyMedium, FontWeight.normal),
      bodySmall: withWeight(base.bodySmall, FontWeight.normal),
      labelLarge: withWeight(base.labelLarge, FontWeight.w500),
      labelMedium: withWeight(base.labelMedium, FontWeight.w500),
      labelSmall: withWeight(base.labelSmall, FontWeight.w500),
    );
  }

  static ThemeData createThemeData(BuildContext context) {
    final base = Theme.of(context).textTheme;
    final textTheme = createTextTheme(base);

    return ThemeData(
      useMaterial3: true,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      fontFamily: GoogleFonts.montserrat().fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF5E35B1), // modern purple
        brightness: Brightness.light,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        titleTextStyle: textTheme.headlineLarge,
      ),
      buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
      iconTheme: const IconThemeData(color: Color(0xFF003034)),
    );
  }

  AppColors get colors => _lightColors;

  Color get primary => colors.primary;

  AppTextStyles get textStyle => AppTextStyles(_context);

  AppSpacing get spacing => AppSpacing();

  AppRadius get radius => AppRadius();

  AppAnimations get animations => AppAnimations();
}

final _lightColors = AppColors(
  primary: const Color(0xFF4739EB),
  secondary: const Color(0xFFFFC900),
  background: const Color(0xFFF5F5F5),
  tertiary: const Color(0xFFFFA400),
  gradient: const Color(0xFF006CFF),
  green: const Color(0xFF52B35E),
  surface: Colors.white,
  error: const Color(0xFFE74C3C),
  onPrimary: Colors.white,
  onSecondary: Colors.black,
  onBackground: const Color(0xFF2C3E50),
  onSurface: const Color(0xFF2C3E50),
  onError: Colors.white,
);

class AppColors {
  final Color primary;
  final Color secondary;
  final Color background;
  final Color tertiary;
  final Color gradient;
  final Color green;
  final Color surface;
  final Color error;
  final Color onPrimary;
  final Color onSecondary;
  final Color onBackground;
  final Color onSurface;
  final Color onError;

  final Color grey = const Color(0xFF9E9E9E);
  final Color lightGrey = const Color(0xFFE0E0E0);
  final Color darkGrey = const Color(0xFF616161);
  final Color success = const Color(0xFF2ECC71);
  final Color info = const Color(0xFF3498DB);
  final Color warning = const Color(0xFFF39C12);
  final Color danger = const Color(0xFFE74C3C);

  final Color primaryTextColor = const Color(0xFF030119);
  final Color secondaryTextColor = const Color(0xFF7F8C8D);
  final Color hintTextColor = const Color(0xFFBDC3C7);

  AppColors({
    required this.primary,
    required this.secondary,
    required this.background,
    required this.tertiary,
    required this.gradient,
    required this.green,
    required this.surface,
    required this.error,
    required this.onPrimary,
    required this.onSecondary,
    required this.onBackground,
    required this.onSurface,
    required this.onError,
  });
}

class AppTextStyles {
  final BuildContext _context;

  AppTextStyles(this._context);

  TextTheme get _textTheme => Theme.of(_context).textTheme;

  TextStyle get headlineLarge => _textTheme.headlineLarge!;
  TextStyle get headlineMedium => _textTheme.headlineMedium!;
  TextStyle get headlineSmall => _textTheme.headlineSmall!;

  TextStyle get titleLarge => _textTheme.titleLarge!;
  TextStyle get titleMedium => _textTheme.titleMedium!;
  TextStyle get titleSmall => _textTheme.titleSmall!;

  TextStyle get bodyLarge => _textTheme.bodyLarge!;
  TextStyle get bodyMedium => _textTheme.bodyMedium!;
  TextStyle get bodySmall => _textTheme.bodySmall!;

  TextStyle get labelLarge => _textTheme.labelLarge!;
  TextStyle get labelMedium => _textTheme.labelMedium!;
  TextStyle get labelSmall => _textTheme.labelSmall!;

  TextStyle get buttonText =>
      _textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold);

  TextStyle get caption => _textTheme.bodySmall!.copyWith(
    color: AppTheme.of(_context).colors.secondaryTextColor,
  );

  TextStyle get heading1 => headlineLarge.copyWith(
    fontWeight: FontWeight.bold,
    color: AppTheme.of(_context).colors.primaryTextColor,
  );

  TextStyle get heading2 => headlineMedium.copyWith(
    fontWeight: FontWeight.bold,
    color: AppTheme.of(_context).colors.primaryTextColor,
  );

  TextStyle get bodyText =>
      bodyMedium.copyWith(color: AppTheme.of(_context).colors.primaryTextColor);
}

class AppSpacing {
  final double xs = 4.0;
  final double sm = 8.0;
  final double md = 16.0;
  final double lg = 24.0;
  final double xl = 32.0;
  final double xxl = 48.0;

  double get paddingS => sm;
  double get paddingM => md;
  double get paddingL => lg;

  EdgeInsets all(double value) => EdgeInsets.all(value);
  EdgeInsets horizontal(double value) =>
      EdgeInsets.symmetric(horizontal: value);
  EdgeInsets vertical(double value) => EdgeInsets.symmetric(vertical: value);

  EdgeInsets get allXs => EdgeInsets.all(xs);
  EdgeInsets get allSm => EdgeInsets.all(sm);
  EdgeInsets get allMd => EdgeInsets.all(md);
  EdgeInsets get allLg => EdgeInsets.all(lg);
  EdgeInsets get allXl => EdgeInsets.all(xl);

  EdgeInsets get horizontalXs => EdgeInsets.symmetric(horizontal: xs);
  EdgeInsets get horizontalSm => EdgeInsets.symmetric(horizontal: sm);
  EdgeInsets get horizontalMd => EdgeInsets.symmetric(horizontal: md);
  EdgeInsets get horizontalLg => EdgeInsets.symmetric(horizontal: lg);
  EdgeInsets get horizontalXl => EdgeInsets.symmetric(horizontal: xl);

  EdgeInsets get verticalXs => EdgeInsets.symmetric(vertical: xs);
  EdgeInsets get verticalSm => EdgeInsets.symmetric(vertical: sm);
  EdgeInsets get verticalMd => EdgeInsets.symmetric(vertical: md);
  EdgeInsets get verticalLg => EdgeInsets.symmetric(vertical: lg);
  EdgeInsets get verticalXl => EdgeInsets.symmetric(vertical: xl);
}

class AppRadius {
  final double xs = 4.0;
  final double sm = 8.0;
  final double md = 12.0;
  final double lg = 16.0;
  final double xl = 24.0;
  final double circular = 100.0;

  double get borderRadiusM => md;
  double get borderRadiusL => lg;

  BorderRadius all(double value) => BorderRadius.circular(value);

  BorderRadius get allXs => BorderRadius.circular(xs);
  BorderRadius get allSm => BorderRadius.circular(sm);
  BorderRadius get allMd => BorderRadius.circular(md);
  BorderRadius get allLg => BorderRadius.circular(lg);
  BorderRadius get allXl => BorderRadius.circular(xl);
  BorderRadius get allCircular => BorderRadius.circular(circular);
}

class AppAnimations {
  final Duration short = const Duration(milliseconds: 200);
  final Duration medium = const Duration(milliseconds: 300);
  final Duration long = const Duration(milliseconds: 500);

  final Curve standard = Curves.easeInOut;
  final Curve decelerate = Curves.decelerate;
}
