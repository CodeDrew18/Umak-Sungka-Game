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

      print('Starting Google Sign-In...');

      // Try lightweight authentication first
      GoogleSignInAccount? googleUser;

      try {
        print('Attempting lightweight authentication...');
        googleUser = await _googleSignIn.attemptLightweightAuthentication();
        print('Lightweight auth result: ${googleUser?.email ?? "null"}');
      } catch (e) {
        print('Lightweight auth failed: $e');
      }

      // If no user from lightweight auth, try full authentication
      if (googleUser == null) {
        print('Attempting full authentication...');
        googleUser = await _googleSignIn.authenticate(scopeHint: ['email']);
        print('Full auth completed: ${googleUser.email}');
      }

      print('Google user authenticated: ${googleUser.email}');

      // Get the authorization with email scope
      final GoogleSignInClientAuthorization? authorization = await googleUser
          .authorizationClient
          .authorizationForScopes(['email']);

      if (authorization == null) {
        print('Failed to get authorization');
        throw Exception('Failed to get authorization from Google');
      }

      print('Got authorization token');
      print('Access token length: ${authorization.accessToken.length}');

      final credential = GoogleAuthProvider.credential(
        accessToken: authorization.accessToken,
      );

      print('Signing in to Firebase with credential...');
      // Sign in to Firebase with the Google credential
      final userCredential = await auth.signInWithCredential(credential);
      print('Firebase sign-in successful: ${userCredential.user?.email}');

      return userCredential;
    } on GoogleSignInException catch (e) {
      print('Google Sign-In Exception: ${e.code} - ${e.description}');
      if (e.code == GoogleSignInExceptionCode.canceled) {
        print('User canceled the sign-in');
        return null; // User canceled
      }
      rethrow;
    } catch (e, stackTrace) {
      print('Error signing in with Google: $e');
      print('Stack trace: $stackTrace');
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
