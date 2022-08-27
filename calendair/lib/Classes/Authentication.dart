import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import './LocalDatabase.dart';
//import 'package:moj_majstor/models/Majstor.dart';
import 'package:calendair/models/User.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class UserAuthentication with ChangeNotifier {
  static final UserAuthentication _singleton = UserAuthentication._internal();

  StreamController<String> Events = StreamController.broadcast();
  factory UserAuthentication() {
    return _singleton;
  }

  LocalDatabase l = LocalDatabase();
  late Future<void> _hive;
  UserData? user;
  String _verificationCode = '000000';

  final _auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  UserAuthentication._internal() {
    _initializeFirebase();
    _hive = initializeHive().then((value) {
      getUserFromLocalDb().then((value) {
        user = value;
        notifyListeners();
        if (user != null) Events.add("SignIn");
      });
    });
  }

  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  final googleSignIn = new GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
      'https://www.googleapis.com/auth/classroom.courses'
    ],
  );

  UserData? get currentUser {
    if (user != null) {
      return user;
    }
    getUserFromLocalDb().then((value) {
      user = value;
      if (user != null) {
        return user;
      }
    });
    return null;
  }

  Future<void> signout() async {
    Events.add("SignOut");
    await googleSignIn.signOut();
    user = null;
    saveUserToLocalDb(null);
  }

  Future<bool> signInwithGoogle() async {
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
        UserCredential uc = await _auth.signInWithCredential(credential);
        notifyListeners();
        final user = await _auth.currentUser;
        inspect(user);
        Get.snackbar("Welcome ", user?.displayName ?? "",
            duration: Duration(seconds: 3));
        final idToken = await user?.getIdToken();
        print("token");
        print(googleAuth.accessToken);
        return true;
      }

      return false;
    } on FirebaseAuthException catch (e) {
      return false;
    } on Exception catch (e) {
      return false;
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
