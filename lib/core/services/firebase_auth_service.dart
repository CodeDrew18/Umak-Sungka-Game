import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  bool _isInitialized = false;

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await _googleSignIn.initialize();
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

      // Use authenticate with interactive flow
      final Completer<GoogleSignInAccount?> completer = Completer();

      // Set up event listener BEFORE calling authenticate
      late StreamSubscription<GoogleSignInAuthenticationEvent> subscription;
      subscription = _googleSignIn.authenticationEvents.listen(
        (GoogleSignInAuthenticationEvent event) {
          print('Auth event received: ${event.runtimeType}');
          if (event is GoogleSignInAuthenticationEventSignIn) {
            print('Sign-in event: ${event.user.email}');
            if (!completer.isCompleted) {
              completer.complete(event.user);
              subscription.cancel();
            }
          } else if (event is GoogleSignInAuthenticationEventSignOut) {
            print('Sign-out event');
            if (!completer.isCompleted) {
              completer.complete(null);
              subscription.cancel();
            }
          }
        },
        onError: (error) {
          print('Auth event error: $error');
          if (!completer.isCompleted) {
            completer.completeError(error);
            subscription.cancel();
          }
        },
      );

      // Trigger the authentication flow
      try {
        print('Calling authenticate...');
        await _googleSignIn.authenticate(scopeHint: ['email']);
        print('Authenticate call completed');
      } catch (e) {
        print('Authenticate threw: $e');
        // Don't fail here - the event listener will handle success/failure
      }

      // Wait for the event with a longer timeout
      final googleUser = await completer.future.timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          print('Authentication timed out');
          subscription.cancel();
          return null;
        },
      );

      if (googleUser == null) {
        print('No user from authentication');
        return null;
      }

      print('Google user authenticated: ${googleUser.email}');

      // Get the authorization
      final GoogleSignInClientAuthorization? authorization = await googleUser
          .authorizationClient
          .authorizationForScopes(['email']);

      if (authorization == null) {
        print('Failed to get authorization');
        throw Exception('Failed to get authorization from Google');
      }

      print(
        'Got authorization, access token: ${authorization.accessToken.substring(0, 20)}...',
      );

      final credential = GoogleAuthProvider.credential(
        accessToken: authorization.accessToken,
      );

      print('Signing in to Firebase with credential...');

      // Sign in to Firebase
      final userCredential = await auth.signInWithCredential(credential);

      print('Firebase sign-in successful: ${userCredential.user?.email}');

      return userCredential;
    } on GoogleSignInException catch (e) {
      print('Google Sign-In Exception: ${e.code} - ${e.description}');
      if (e.code == GoogleSignInExceptionCode.canceled) {
        print('User canceled the sign-in');
        return null;
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
