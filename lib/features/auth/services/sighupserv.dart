import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUpWithEmail(String email, String password, String name) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final user = userCredential.user;
    if (user != null) {
      await _firestore.collection("users").doc(user.uid).set({
        "uid": user.uid,
        "name": name,
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
    }
    return user;
  }

  Future<User?> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) throw "Sign-in aborted.";

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    final user = userCredential.user;

    final doc = await _firestore.collection("users").doc(user!.uid).get();
    if (!doc.exists) {
      await _firestore.collection("users").doc(user.uid).set({
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
    }
    return user;
  }
}