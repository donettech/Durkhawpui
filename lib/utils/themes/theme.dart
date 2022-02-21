import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData.light().copyWith(
      primaryColor: Constants.primary,
      scaffoldBackgroundColor: Colors.white,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: Constants.primary,
        ),
      ),
      appBarTheme: AppBarTheme().copyWith(
        backgroundColor: Colors.white,
      ),
      toggleableActiveColor: Constants.primary,
      primaryColorLight: Constants.primary,
      primaryColorDark: Constants.secondary,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      primaryIconTheme: IconThemeData(
        color: Colors.black,
      ),
      dialogBackgroundColor: Colors.grey[200],
      textTheme: TextTheme().copyWith(
        headline1: GoogleFonts.roboto(
          color: Colors.black,
        ),
        headline2: GoogleFonts.roboto(
          color: Colors.black,
        ),
        headline3: GoogleFonts.roboto(
          color: Colors.black,
        ),
        headline4: GoogleFonts.roboto(
          color: Colors.black,
        ),
        headline5: GoogleFonts.roboto(
          color: Colors.black,
        ),
        headline6: GoogleFonts.roboto(
          color: Colors.black,
        ),
        caption: GoogleFonts.roboto(
          color: Colors.black,
        ),
        subtitle1: GoogleFonts.roboto(
          color: Colors.black,
        ),
        subtitle2: GoogleFonts.roboto(
          color: Colors.black,
        ),
        bodyText1: GoogleFonts.roboto(
          color: Colors.black,
        ),
        bodyText2: GoogleFonts.roboto(
          color: Colors.black,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      primaryColor: Constants.primary,
      primaryColorLight: Constants.primary,
      primaryColorDark: Constants.primary,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: AppBarTheme().copyWith(
        backgroundColor: CardTheme().copyWith().color,
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      primaryIconTheme: IconThemeData(
        color: Colors.white,
      ),
      dialogBackgroundColor: Colors.black54,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: Constants.primary,
        ),
      ),
      colorScheme: ColorScheme.dark(
        secondary: Constants.primary,
      ),
      textTheme: TextTheme().copyWith(
        headline1: GoogleFonts.roboto(
          color: Colors.white,
        ),
        headline2: GoogleFonts.roboto(
          color: Colors.white,
        ),
        headline3: GoogleFonts.roboto(
          color: Colors.white,
        ),
        headline4: GoogleFonts.roboto(
          color: Colors.white,
        ),
        headline5: GoogleFonts.roboto(
          color: Colors.white,
        ),
        headline6: GoogleFonts.roboto(
          color: Colors.white,
        ),
        caption: GoogleFonts.roboto(
          color: Colors.white,
        ),
        subtitle1: GoogleFonts.roboto(
          color: Colors.white,
        ),
        subtitle2: GoogleFonts.roboto(
          color: Colors.white,
        ),
        bodyText1: GoogleFonts.roboto(
          color: Colors.white,
        ),
        bodyText2: GoogleFonts.roboto(
          color: Colors.white,
        ),
      ),
    );
  }
}
