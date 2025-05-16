import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppAuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  User? user;
  bool _isLoading = false;
  bool _isError = false;
  String? _errorMessage;
  String? _profilePictureUrl;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  bool get isError => _isError;
  String? get errorMessage => _errorMessage;
  String? get profilePictureUrl => _profilePictureUrl;

  AppAuthProvider() {
    _firebaseAuth.authStateChanges().listen((User? user) {
      if (user == null) {
        _isLoggedIn = false;
        _profilePictureUrl = null;
      } else {
        _isLoggedIn = true;
        this.user = user;
        _profilePictureUrl = user.photoURL;
      }
      notifyListeners();
    });
  }

  Future<void> getLoginStatus() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      user = _firebaseAuth.currentUser;
      _isLoggedIn = user != null;

      if (!isLoggedIn) {
        final prefs = await SharedPreferences.getInstance();
        _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoggedIn = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _isError = false;
    notifyListeners();
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        _isLoggedIn = true;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        return true;
      } else {
        _isLoggedIn = false;
        return false;
      }
    } on FirebaseAuthException catch (e) {
      _isError = true;

      switch (e.code) {
        case 'email-already-in-use':
          _errorMessage = 'Gunakan email lain!';
          break;
        case 'invalid-email':
          _errorMessage = 'Format email tidak valid.';
          break;
        default:
          _errorMessage = 'Gagal mendaftar. Silakan coba lagi!';
      }
      return false;
    } catch (e) {
      _isError = true;
      _errorMessage = 'Terjadi kesalahan: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    _isError = false;
    notifyListeners();
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      var user = _firebaseAuth.currentUser;
      if (user != null) {
        _isLoggedIn = true;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
      } else {
        _isLoggedIn = false;
      }
      return true;
    } on FirebaseAuthException catch (e) {
      _isError = true;

      switch (e.code) {
        case 'user-not-found':
          _errorMessage = 'Akun dengan email ini tidak ditemukan.';
          break;
        case 'wrong-password':
          _errorMessage = 'Password yang Anda masukkan salah.';
          break;
        case 'invalid-email':
          _errorMessage = 'Format email tidak valid.';
          break;
        case 'user-disabled':
          _errorMessage = 'Akun ini telah dinonaktifkan.';
          break;
        case 'too-many-requests':
          _errorMessage = 'Terlalu banyak percobaan. Coba lagi nanti.';
          break;
        default:
          _errorMessage = 'Akun tidak ditemukan. Silakan coba lagi!';
      }
      return false;
    } catch (e) {
      _isError = true;
      _errorMessage = 'Terjadi kesalahan: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> loginWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    _isError = false;
    notifyListeners();

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _errorMessage = 'Login dibatalkan';
        return false;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _firebaseAuth.signInWithCredential(credential);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      _isLoggedIn = true;
      return true;
    } on FirebaseAuthException catch (e) {
      _isError = true;
      switch (e.code) {
        case 'invalid-credential':
          _errorMessage = 'Token login tidak valid. Silakan coba lagi.';
          break;
        default:
          _errorMessage = 'Gagal login dengan Google: ${e.message}';
      }
      return false;
    } catch (e) {
      _isError = true;
      _errorMessage = 'Terjadi kesalahan: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getPictureProfile() async {
    _isLoading = true;
    notifyListeners();
    try {
      final currentUser = _firebaseAuth.currentUser;
      String? photoUrl;
      String? initial;

      if (currentUser != null) {
        photoUrl = currentUser.photoURL;
        initial = currentUser.displayName?.substring(0, 1).toUpperCase();

        if ((photoUrl == null || photoUrl.isEmpty) &&
            currentUser.providerData.any(
              (info) => info.providerId == 'google.com',
            )) {
          final googleUser = await _googleSignIn.signInSilently();
          photoUrl = googleUser?.photoUrl;
          if ((photoUrl == null || photoUrl.isEmpty) &&
              initial != null &&
              initial.isNotEmpty) {
            _profilePictureUrl = initial;
            return;
          }
        }
      }

      if (photoUrl != null && photoUrl.isNotEmpty) {
        _profilePictureUrl = photoUrl;
      } else if (initial != null && initial.isNotEmpty) {
        _profilePictureUrl = initial;
      } else {
        _profilePictureUrl = null;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _profilePictureUrl = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
