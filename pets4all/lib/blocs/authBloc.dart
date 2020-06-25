import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  BehaviorSubject<FirebaseUser> _user = BehaviorSubject<FirebaseUser>();

  Stream<Map<String, dynamic>> profile;
  PublishSubject loading = PublishSubject();

  Stream<FirebaseUser> get user => _user.stream;
  FirebaseUser get fbUser => _user.value;

  AuthService() {
    _user = BehaviorSubject<FirebaseUser>();
    _auth.onAuthStateChanged.listen((FirebaseUser u) {
      _user.add(u);
    });

    profile = _user.switchMap((FirebaseUser u) {
      if (u != null) {
        return _db
            .collection("users")
            .document(u.uid)
            .snapshots()
            .map((snap) => snap.data);
      } else {
        return Observable.just({});
      }
    });
  }
  Future<FirebaseUser> googleSignIn() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final AuthResult res = await _auth.signInWithCredential(credential);
    final FirebaseUser user = res.user;
    print("signed in " + user.displayName);
    return user;
  }

  void signOut() async {
    _auth.signOut();
  }

  void upadteUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection("users").document(user.uid);
    return ref.setData({
      "uid": user.uid,
      'email': user.email,
      'displayName': user.displayName,
    }, merge: true);
  }
}
