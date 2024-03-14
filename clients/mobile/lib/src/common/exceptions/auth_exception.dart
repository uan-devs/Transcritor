class AuthException implements Exception {
  static const Map<String, String> errors = {
    'INVALID_CREDENTIALS': 'Authentication credentials are incorrect',
    'INVALID_TOKEN': 'Authentication credentials are incorrect',
    'OPERATION_NOT_ALLOWED': 'You are not allowed',
    'TOO_MANY_ATTEMPTS_TRY_LATER': 'You are block, try later',
    'USER_DISABLED': 'You are disable for now',
    'SERVER_DOWN': 'Failed to connect with server',
    'BAD_REQUEST': 'Invalid data provided',
    'BAD_RESPONSE': 'Invalid data provided',
  };

  final String key;

  AuthException({required this.key});

  @override
  String toString() {
    return errors[key] ?? 'Authentication failed';
  }
}
