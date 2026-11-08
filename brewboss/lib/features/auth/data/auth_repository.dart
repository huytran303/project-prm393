import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  AuthRepository(this._auth);
  final FirebaseAuth _auth;

  Stream<User?> authStateChanges() => _auth.authStateChanges();
  Future<void> signIn(String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);
  Future<void> signOut() => _auth.signOut();
  Future<void> sendPasswordResetEmail(String email) => _auth.sendPasswordResetEmail(email: email);

  /// Firebase requires a recent login, so the current password is re-checked first.
  Future<void> changePassword(String current, String next) async {
    final user = _auth.currentUser!;
    await user.reauthenticateWithCredential(
        EmailAuthProvider.credential(email: user.email!, password: current));
    await user.updatePassword(next);
  }
}
