import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transcritor/src/common/extensions/custom_theme_extension.dart';
import 'package:transcritor/src/common/utils/my_colors.dart';

ThemeData darkTheme() {
  final ThemeData base = ThemeData.dark();

  return base.copyWith(
    colorScheme: const ColorScheme.dark(
      background: MyColors.black87,
    ),
    scaffoldBackgroundColor: MyColors.black87,
    extensions: [CustomThemeExtension.darkMode],
    appBarTheme: const AppBarTheme(
      backgroundColor: MyColors.grey600,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColors.green,
        foregroundColor: Colors.white,
        splashFactory: NoSplash.splashFactory,
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: MyColors.grey600,
      modalBackgroundColor: MyColors.grey600,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
    ),
    dialogBackgroundColor: MyColors.grey600,
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: MyColors.green,
      foregroundColor: Colors.white,
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: Colors.white,
      tileColor: MyColors.grey,
    ),
    switchTheme: const SwitchThemeData(
      thumbColor: MaterialStatePropertyAll(MyColors.grey),
      trackColor: MaterialStatePropertyAll(Color(0xFF344047)),
    ),
  );
}
