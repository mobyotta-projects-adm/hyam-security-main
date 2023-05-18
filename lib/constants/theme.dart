import 'package:flutter/material.dart';

Color lightsky = const Color(0xFFA6C0FF);
Color whiteshade = const Color(0xFFF8F9FA);
Color blue = const Color(0xFF1137FF);
Color lightblueshade = const Color(0xFF758CC8);
Color grayshade = const Color(0xFF9FA4AF);
Color lightblue = const Color(0xFF4B68D1);
Color blackshade = const Color(0xFF555555);

class AppThemes {
  /// Colors from Tailwind CSS
  ///
  /// https://tailwindcss.com/docs/customizing-colors

  static const Color _primaryColor = Color.fromRGBO(8, 62, 183, 1);


  static const int _textColor = 0xFF6B7280;
  static const MaterialColor textSwatch =
      MaterialColor(_textColor, <int, Color>{
    50: Color(0xFFF9FAFB),
    100: Color(0xFFF3F4F6),
    200: Color(0xFFE5E7EB),
    300: Color(0xFFD1D5DB),
    400: Color(0xFF9CA3AF),
    500: Color(_textColor),
    600: Color(0xFF4B5563),
    700: Color(0xFF374151),
    800: Color(0xFF1F2937),
    900: Color(0xFF111827),
  });

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    backgroundColor: Colors.white,
    primaryColor: _primaryColor,
    cardColor: Colors.white,
    bottomAppBarColor: Colors.white,
    dividerColor: Colors.white54,
    textTheme: TextTheme(
      headline1: TextStyle(
        color: textSwatch.shade700,
        fontWeight: FontWeight.w300,
      ),
      headline2: TextStyle(
        color: textSwatch.shade600,
      ),
      headline3: TextStyle(
        color: textSwatch.shade700,
      ),
      headline4: TextStyle(
        color: textSwatch.shade700,
      ),
      headline5: TextStyle(
        color: textSwatch.shade600,
      ),
      headline6: TextStyle(
        color: textSwatch.shade700,
      ),
      subtitle1: TextStyle(
        color: textSwatch.shade700,
      ),
      subtitle2: TextStyle(
        color: textSwatch.shade600,
      ),
      bodyText1: TextStyle(
        color: textSwatch.shade700,
      ),
      bodyText2: TextStyle(
        color: textSwatch.shade500,
      ),
      button: TextStyle(
        color: textSwatch.shade500,
      ),
      caption: TextStyle(
        color: textSwatch.shade500,
      ),
      overline: TextStyle(
        color: textSwatch.shade500,
      ),
    ),
  );

  static final darkTheme = ThemeData.dark().copyWith(
    brightness: Brightness.dark,
    primaryColor: _primaryColor,
    scaffoldBackgroundColor: Colors.black,
    backgroundColor:  Colors.black,
    cardColor: Colors.black54,
    bottomAppBarColor: const Color(0xFF35353a),
    appBarTheme: ThemeData.dark().appBarTheme.copyWith(
      backgroundColor: Colors.black,
    ),
    dividerColor: Colors.white70,
    textTheme: const TextTheme(
      headline1: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w300,
      ),
      headline2: TextStyle(
        color: Colors.white70,
      ),
      headline3: TextStyle(
        color: Colors.white54,
      ),
      headline4: TextStyle(
        color: Colors.white60,
      ),
      headline5: TextStyle(
        color: Colors.white38,
      ),

    ),
  );
}

const kSpacingUnit = 10;

const kDarkPrimaryColor = Color(0xFF212121);
const kDarkSecondaryColor = Color(0xFF373737);
const kLightPrimaryColor = Color(0xFFFFFFFF);
const kLightSecondaryColor = Color(0xFFF3F7FB);
const kAccentColor = Color(0xFFFFC107);

const kTitleTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
);

const kCaptionTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w100,
);

const kButtonTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w400,
  color: kDarkPrimaryColor,
);

final kDarkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'SFProText',
  primaryColor: kDarkPrimaryColor,
  canvasColor: kDarkPrimaryColor,
  backgroundColor: kDarkSecondaryColor,
  accentColor: kAccentColor,
  iconTheme: ThemeData.dark().iconTheme.copyWith(
    color: kLightSecondaryColor,
  ),
  textTheme: ThemeData.dark().textTheme.apply(
    fontFamily: 'SFProText',
    bodyColor: kLightSecondaryColor,
    displayColor: kLightSecondaryColor,
  ),
);

final kLightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'SFProText',
  primaryColor: kLightPrimaryColor,
  canvasColor: kLightPrimaryColor,
  backgroundColor: kLightSecondaryColor,
  accentColor: kAccentColor,
  iconTheme: ThemeData.light().iconTheme.copyWith(
    color: kDarkSecondaryColor,
  ),
  textTheme: ThemeData.light().textTheme.apply(
    fontFamily: 'SFProText',
    bodyColor: kDarkSecondaryColor,
    displayColor: kDarkSecondaryColor,
  ),
);