import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUpWithEmail(
    String email,
    String password,
    String name,
  ) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user;
    if (user != null) {
      await _createUserDoc(user, name, ""); // imageBase64 is empty on sign up
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

    if (user != null) {
      final doc = await _firestore.collection("users").doc(user.uid).get();
      if (!doc.exists) {
        await _createUserDoc(user, user.displayName ?? "No Name", "");
      } else {
        await _updateUserTimestamp(user.uid);
      }
    }
    return user;
  }

  Future<User?> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status != LoginStatus.success) throw "Facebook Sign-in failed.";

    final OAuthCredential credential = FacebookAuthProvider.credential(
      result.accessToken!.token,
    );
    final userCredential = await _auth.signInWithCredential(credential);
    final user = userCredential.user;

    if (user != null) {
      final doc = await _firestore.collection("users").doc(user.uid).get();
      if (!doc.exists) {
        await _createUserDoc(user, user.displayName ?? "No Name", "");
      } else {
        await _updateUserTimestamp(user.uid);
      }
    }

    return user;
  }

  Future<void> _createUserDoc(User user, String name, [String? imageFileId]) async {
    await _firestore.collection("users").doc(user.uid).set({
      "uid": user.uid,
      "name": name,
      "email": user.email ?? "",
      "photoUrl": user.photoURL ?? "",
      "bio": "",
      "role": "reader",
      "averageRating": 0.0,
      "totalRatings": 0,
      "verified": false,
      "isBanned": false,
      "profileIncomplete": true,
      "genres": [],
      "address": null,
      "website": null,
      "bookIds": [],
      "transactionIds": [],
      "chatIds": [],
      "blogPostIds": [],
      "notificationIds": [],
      "imageFileId": imageFileId,
      "createdAt": FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> _updateUserTimestamp(String uid) async {
    await _firestore.collection("users").doc(uid).update({
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }
}
