import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  bool _isInitialized = false;

  // Web Client ID
  static const String _serverClientId =
      '484169081903-hhp579hiee8s0p0kbu0e4cf5hnbkfapk.apps.googleusercontent.com';

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await _googleSignIn.initialize(serverClientId: _serverClientId);
      _isInitialized = true;
    }
  }

  Future<UserCredential> signInAsGuest() async {
    return await auth.signInAnonymously();
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      await _ensureInitialized();

      // Trigger the Google Sign-In flow
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      // Get the authorization with email scope
      final GoogleSignInClientAuthorization? authorization = await googleUser
          .authorizationClient
          .authorizationForScopes(['email']);

      if (authorization == null) {
        throw Exception('Failed to get authorization from Google');
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: authorization.accessToken,
        // The idToken is not directly available in the new API
        // Firebase will handle the authentication with just the access token
      );

      // Sign in to Firebase with the Google credential
      return await auth.signInWithCredential(credential);
    } on GoogleSignInException catch (e) {
      print('Google Sign-In Exception: ${e.code} - ${e.description}');
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return null; // User canceled
      }
      rethrow;
    } catch (e) {
      print('Error signing in with Google: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    await _ensureInitialized();
    await _googleSignIn.disconnect();
    return auth.signOut();
  }

  User? get currentUser => auth.currentUser;

  Stream<User?> get authStateChanges => auth.authStateChanges();
}
