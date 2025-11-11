import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  bool _isInitialized = false;

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      // Initialize without serverClientId for Android (uses google-services.json)
      // Only web needs serverClientId
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

      // Use attemptLightweightAuthentication which works better on Android
      await _googleSignIn.attemptLightweightAuthentication();

      // Wait a moment for the auth event
      await Future.delayed(const Duration(milliseconds: 500));

      // Listen for authentication events with a completer
      final Completer<GoogleSignInAccount?> completer = Completer();

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

      // Wait for authentication with timeout
      final googleUser = await completer.future.timeout(
        const Duration(seconds: 10),
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

      print('Got authorization');

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
