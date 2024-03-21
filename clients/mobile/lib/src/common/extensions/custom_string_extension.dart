extension ExtendedString on String? {
  bool get isEmptyOrNull => this?.isEmpty ?? true;
  String get toCapitalCase {
    if (this == null) return '';
    if (this!.isEmpty) return '';
    return '${this![0].toUpperCase()}${this!.substring(1)}';
  }
}