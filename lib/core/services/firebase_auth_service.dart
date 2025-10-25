import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<UserCredential> signInAsGuest() async {
    return await auth.signInAnonymously();
  }

  Future<void> logout() {
    return auth.signOut();
  }
}
