import 'package:dartz/dartz.dart';
import 'package:transcritor/src/common/exceptions/auth_exception.dart';
import 'package:transcritor/src/common/models/user.dart';

abstract class AuthRepository {
  Future<Either<AuthException, User?>> getCurrentUserInfo();

  Future<Either<AuthException, void>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<AuthException, void>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String province,
  });

  Future<void> signOut();

  Stream<User?> onAuthStateChanged();
}
