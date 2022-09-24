import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'LocalDatabase.dart';
import 'package:calendair/models/User.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'firestore.dart';

class UserAuthentication extends GetxController {
  static final UserAuthentication _singleton = UserAuthentication._internal();
  factory UserAuthentication() {
    return _singleton;
  }

  LocalDatabase l = LocalDatabase();
  late Future<void> _hive;
  UserData? user;
  User? currentUser;

  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  UserAuthentication._internal() {
    _initializeFirebase();
    // _hive = initializeHive().then((value) {
    //   getUserFromLocalDb().then((value) {
    //     user = value;
    //   });
    // });
  }

  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  final googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
      'https://www.googleapis.com/auth/classroom.courses',
      'https://www.googleapis.com/auth/classroom.rosters',
      'https://www.googleapis.com/auth/classroom.coursework.students'
    ],
  );

  // UserData? get currentUser {
  //   if (user != null) {
  //     return user;
  //   }
  //   getUserFromLocalDb().then((value) {
  //     user = value;
  //     if (user != null) {
  //       return user;
  //     }
  //   });
  //   return null;
  // }

  Future<void> signout() async {
    await googleSignIn.signOut();
    user = null;
    //  saveUserToLocalDb(null);
  }

  Future<String> signInwithGoogle() async {
    signout();
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final googleAuth = await googleSignInAccount.authentication;
        googleAuth.accessToken;
        UserCredential uc = await auth.signInWithCredential(credential);
        currentUser = auth.currentUser;
        // Get.snackbar("Welcome ", currentUser?.displayName ?? "",
        //     duration: const Duration(seconds: 3));
        return await Firestore().getUserIfExist(currentUser!.uid);
      }

      return "error";
    } on FirebaseAuthException catch (e) {
      return "error";
    } on Exception catch (e) {
      return "error";
    }
  }

  ///hive
  ///
  ///
  Future<void> initializeHive() async {
    final directory = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(directory.path);
    Hive.registerAdapter(UserDataAdapter(), override: true);
  }

  Future<void> saveUserToLocalDb(UserData? user) async {
    await _hive;
    var userBox = await Hive.openBox('userBox');
    await userBox.put('profile', user);
  }

  Future<UserData?> getUserFromLocalDb() async {
    await _hive;
    var userBox = await Hive.openBox('userBox');
    return userBox.get('profile');
  }

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }
}
