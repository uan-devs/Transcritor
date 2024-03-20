import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transcritor/src/common/extensions/custom_theme_extension.dart';
import 'package:transcritor/src/common/utils/my_colors.dart';

ThemeData darkTheme() {
  final ThemeData base = ThemeData.dark();

  return base.copyWith(
    colorScheme: const ColorScheme.dark(
      background: MyColors.black87,
      primary: MyColors.green,
    ),
    scaffoldBackgroundColor: MyColors.black87,
    extensions: [CustomThemeExtension.darkMode],
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      backgroundColor: MyColors.black87,
      surfaceTintColor: Colors.grey,
      titleTextStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
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
        foregroundColor: Colors.black,
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
      foregroundColor: Colors.black,
    ),
    listTileTheme: ListTileThemeData(
      iconColor: MyColors.green,
      tileColor: Colors.grey.withOpacity(.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.normal,
      ),
      subtitleTextStyle: const TextStyle(
        fontSize: 12,
        color: MyColors.grey,
      ),
    ),
    switchTheme: const SwitchThemeData(
      thumbColor: MaterialStatePropertyAll(MyColors.grey),
      trackColor: MaterialStatePropertyAll(Color(0xFF344047)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}

/**
 * InputDecoration(
    labelText: 'Nome',
    prefixIcon: const Icon(Icons.person),
    suffixIcon: IconButton(
    icon: const Icon(Icons.close_rounded),
    onPressed: () {},
    ),
    isDense: true,
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    ),
    )
 */
