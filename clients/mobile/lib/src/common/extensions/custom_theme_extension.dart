import 'package:flutter/material.dart';
import 'package:transcritor/src/common/utils/my_colors.dart';

extension ExtendedTheme on BuildContext {
  CustomThemeExtension get theme {
    return Theme.of(this).extension<CustomThemeExtension>()!;
  }
}

class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  static CustomThemeExtension darkMode = CustomThemeExtension(
    circleImageColor: MyColors.grey,
    greyColor: MyColors.grey,
    pageBackground: MyColors.grey600,
  );

  final Color? circleImageColor;
  final Color? greyColor;
  final Color? pageBackground;

  CustomThemeExtension({
    this.circleImageColor,
    this.greyColor,
    this.pageBackground,
  });

  @override
  ThemeExtension<CustomThemeExtension> copyWith({
    Color? circleImageColor,
    Color? greyColor,
    Color? pageBackground,
  }) {
    return CustomThemeExtension(
      circleImageColor: circleImageColor ?? this.circleImageColor,
      greyColor: greyColor ?? this.greyColor,
      pageBackground: pageBackground ?? this.pageBackground,
    );
  }

  @override
  ThemeExtension<CustomThemeExtension> lerp(
    covariant ThemeExtension<CustomThemeExtension>? other,
    double t,
  ) {
    if (other is! CustomThemeExtension) return this;

    return CustomThemeExtension(
      circleImageColor: Color.lerp(
        circleImageColor,
        other.circleImageColor,
        t,
      ),
      greyColor: Color.lerp(
        greyColor,
        other.greyColor,
        t,
      ),
      pageBackground: Color.lerp(
        pageBackground,
        other.pageBackground,
        t,
      ),
    );
  }
}
