extension ExtendedString on String? {
  bool get isEmptyOrNull => this?.isEmpty ?? true;
}