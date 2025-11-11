import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    serverClientId:
        '484169081903-hhp579hiee8s0p0kbu0e4cf5hnbkfapk.apps.googleusercontent.com',
  );

  Future<UserCredential> signInAsGuest() async {
    return await auth.signInAnonymously();
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      print('Starting Google Sign-In...');

      // Trigger sign-in
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print('User canceled the sign-in');
        return null;
      }

      print('Google user signed in: ${googleUser.email}');

      // Obtain auth details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      print('Got authentication tokens');

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('Signing in to Firebase with credential...');

      // Sign in to Firebase
      final userCredential = await auth.signInWithCredential(credential);

      print('Firebase sign-in successful: ${userCredential.user?.email}');

      return userCredential;
    } catch (e, stackTrace) {
      print('Error signing in with Google: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();
    return auth.signOut();
  }

  User? get currentUser => auth.currentUser;

  Stream<User?> get authStateChanges => auth.authStateChanges();
}
