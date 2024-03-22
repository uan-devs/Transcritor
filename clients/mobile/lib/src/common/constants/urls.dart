sealed class UrlsConstants {
  static const String baseURL = String.fromEnvironment('BASE_URL');
  static const String registerUrl = '/auth/register';
  static const String loginUrl = '/auth/login';
  static const String refreshTokenUrl = '/auth/refresh-token';
  static const String userInfoUrl = '/users/me';
  static const String editUserInfoUrl = '/users/me';
  static const String editUserProfilePhotoUrl = '/users/upload-image';
  static const String changeUserPassword = '/users/change-password';
  static const String updateUserPhoto = '/users/upload-image';
  static const String fetchTranscriptionsUrl = '/transcription/list';
  static const String singleTranscriptionUrl = '/transcription/';
  static const String createTranscriptionUrl = '/transcription/create';
}
