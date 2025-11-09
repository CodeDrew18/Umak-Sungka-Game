import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  bool _isInitialized = false;
  StreamSubscription<GoogleSignInAuthenticationEvent>? _authEventSubscription;

  // Web Client ID
  static const String _serverClientId =
      '992190293501-cu3obugq580rnl6g8v9ucv03bm25m6pj.apps.googleusercontent.com';

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

      // Create a completer to handle async authentication
      final Completer<GoogleSignInAccount?> completer = Completer();

      // Listen to authentication events
      _authEventSubscription = _googleSignIn.authenticationEvents.listen(
        (event) {
          print('Auth event received: ${event.runtimeType}');
          if (event is GoogleSignInAuthenticationEventSignIn) {
            print('Sign-in event: ${event.user.email}');
            if (!completer.isCompleted) {
              completer.complete(event.user);
            }
          } else if (event is GoogleSignInAuthenticationEventSignOut) {
            print('Sign-out event');
            if (!completer.isCompleted) {
              completer.complete(null);
            }
          }
        },
        onError: (error) {
          print('Auth event error: $error');
          if (!completer.isCompleted) {
            completer.completeError(error);
          }
        },
      );

      // Trigger authentication
      try {
        await _googleSignIn.authenticate(scopeHint: ['email']);
      } catch (e) {
        print('Authenticate call threw: $e');
        // Don't fail here - wait for the event
      }

      // Wait for the authentication event with timeout
      final googleUser = await completer.future.timeout(
        Duration(seconds: 30),
        onTimeout: () {
          print('Authentication timed out');
          return null;
        },
      );

      // Cancel subscription
      await _authEventSubscription?.cancel();
      _authEventSubscription = null;

      if (googleUser == null) {
        print('No user from authentication');
        return null;
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
      await _authEventSubscription?.cancel();
      _authEventSubscription = null;
      if (e.code == GoogleSignInExceptionCode.canceled) {
        print('User canceled the sign-in');
        return null; // User canceled
      }
      rethrow;
    } catch (e, stackTrace) {
      print('Error signing in with Google: $e');
      print('Stack trace: $stackTrace');
      await _authEventSubscription?.cancel();
      _authEventSubscription = null;
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
