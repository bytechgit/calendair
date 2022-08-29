import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import '../models/popup.dart';
import 'Authentication.dart';
import 'googleClassroom.dart';

class Firestore {
  static final Firestore _singleton = Firestore._internal();
  final ua = UserAuthentication();
  final gc = Get.find<GoogleClassroom>();
  factory Firestore() {
    return _singleton;
  }

  final firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  CollectionReference popups = FirebaseFirestore.instance.collection('Popups');

  Firestore._internal() {
    _initializeFirebase();
  }

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  void addUserIfNotExist(String UID) {
    users.doc(UID).get().then((DocumentSnapshot ds) {
      if (!ds.exists) {
        users.doc(UID).set({"classes": []}, SetOptions(merge: true));
      }
    });
  }

  void addPopUp(
      {required String classId,
      required String date,
      required String title,
      required String cm}) {
    popups.add({
      "ClassId": classId,
      "Date": date,
      "Title": title,
      "numRate": 0,
      "sumRate": 0,
      "ConfidenceQuestion": cm,
      "order": DateTime.now(),
      "students": []
    });
  }

  void addcourse({
    required String classId,
    required String code,
    required String name,
  }) {
    FirebaseFirestore.instance
        .collection('Courses')
        .add({"id": classId, "code": code, "name": name});
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getcourse({
    required String code,
  }) async {
    return await FirebaseFirestore.instance
        .collection('Courses')
        .where('code', isEqualTo: code)
        .get();
  }

  Future<List<PopUp>> readPopUps() async {
    var pu = await popups
        .where("ClassId", whereIn: gc.courses.value.map((e) => e.id).toList())
        .get();

    return pu.docs.map((e) {
      var en = e.data() as Map<String, dynamic>;

      return PopUp(e.id, en["classId"] ?? "", en["date"] ?? "",
          en["title"] ?? "", en["numRate"] ?? 0, en["sumRate"] ?? 0);
    }).toList();
  }

  Future<List<PopUp>> readPopUpsTeacher(String classId) async {
    var pu = await popups.where("ClassId", isEqualTo: classId).get();

    return pu.docs.map((e) {
      var en = e.data() as Map<String, dynamic>;

      return PopUp(e.id, en["classId"] ?? "", en["date"] ?? "",
          en["title"] ?? "", en["numRate"] ?? 0, en["sumRate"] ?? 0);
    }).toList();
  }

  void addPopUpRate(String id, int rate) {
    popups.doc(id).update({
      "numRate": FieldValue.increment(1),
      "sumRate": FieldValue.increment(rate),
      "students": FieldValue.arrayUnion([ua.currentUser!.uid])
    });
  }

  void addClassToUser(String classid) {
    users.doc(ua.currentUser!.uid).update({
      "classes": FieldValue.arrayUnion([classid])
    });
  }

  Future<Map<String, dynamic>?> readUser(String uid) async {
    DocumentSnapshot documentSnapshot = await ua.users.doc(uid).get();
    return documentSnapshot.exists
        ? documentSnapshot.data()! as Map<String, dynamic>
        : null;
  }
}
