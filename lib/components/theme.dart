import 'package:flutter/material.dart';

import '../../constants.dart';

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    fontFamily: "DMSans",
    appBarTheme: appBarTheme(),
    textTheme: textTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}


TextTheme textTheme() {
  return TextTheme(
    bodyText1: TextStyle(color: bodyText1),
    bodyText2: TextStyle(color: bodyText1),
  );
}

AppBarTheme appBarTheme() {
  return AppBarTheme(
    color: odaPrimary,
    elevation: 0,
    brightness: Brightness.dark,
    iconTheme: IconThemeData(color: bodyText1),
      textTheme: TextTheme(
      headline6: TextStyle(color: bodyText1, fontSize: 12)
  )
  );
}