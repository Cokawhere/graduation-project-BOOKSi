import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential?> signInWithEmail(String email, String password) async {
    final userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    await _saveUserToFirestore(userCredential);
    return userCredential;
  }

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();

    if (googleUser == null) throw "Sign-in aborted.";

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    await _saveUserToFirestore(userCredential);
    return userCredential;
  }

  Future<void> _saveUserToFirestore(UserCredential userCredential) async {
    final user = userCredential.user;
    if (user == null) return;

    final docRef = _firestore.collection('users').doc(user.uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      await docRef.set({
        "uid": user.uid,
        "name": user.displayName ?? "No Name",
        "email": user.email ?? "",
        "photoUrl": user.photoURL ?? "",
        "bio": "",
        "genres": [],
        "profileIncomplete": true,
        "listings": [],
        "transactions": [],
        "chatIds": [],
        "notifications": [],
        "blogPosts": [],
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),
      });
    } else {
      await docRef.update({"updatedAt": FieldValue.serverTimestamp()});
    }
  }
}
