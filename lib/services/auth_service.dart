import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:imin/models/globals.dart' as globals;
import 'package:imin/main.dart';
import 'package:imin/models/user_model.dart';

class AuthService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  User? _userFromFirebase(auth.User? user) {
    if (user == null) {
      return null;
    }
    return User(user.uid, user.displayName, user.email);
  }

  Stream<User?>? get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _userFromFirebase(credential.user);
  }

  Future<User?> createUserWithEmailAndPassword(
    String name,
    String email,
    String password,
  ) async {
    globals.userName = name;
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    credential.user!.updateDisplayName(name);
    String _userUID = credential.user!.uid;
    try {
      final userReferance = dbReference.child('users/$_userUID');
      userReferance.set(
        {
          'name': name,
          'email': email,
          'class': {
            "dart": 0,
            "swift": 0,
            "c++": 0,
            "java": 0,
            "javascript": 0,
            "python": 0
          },
          'ia-marks': {
            "Dart": 0,
            "Swift": 0,
            "C++": 0,
            "Java": 0,
            "Javascript": 0,
            "Python": 0
          },
        },
      );
    } catch (e) {
      rethrow;
    }

    return _userFromFirebase(credential.user);
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
