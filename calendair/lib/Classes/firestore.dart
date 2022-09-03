import 'package:calendair/classes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
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
  CollectionReference courses =
      FirebaseFirestore.instance.collection('Courses');
  CollectionReference popups = FirebaseFirestore.instance.collection('Popups');
  CollectionReference reminder =
      FirebaseFirestore.instance.collection('Reminders');

  Firestore._internal() {
    _initializeFirebase();
  }

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  void addUserIfNotExist(String UID, String type) {
    users.doc(UID).get().then((DocumentSnapshot ds) {
      if (!ds.exists) {
        users
            .doc(UID)
            .set({"classes": [], "type": type}, SetOptions(merge: true));
      }
    });
  }

  Future<String> getUserIfExist(String UID) async {
    final ds = await users.doc(UID).get();
    if (ds.exists) {
      return ds["type"];
    }
    return "";
  }

  void addPopUp(
      {required String classId,
      required DateTime date,
      required String title,
      required String cm}) {
    popups.add({
      "class": classId,
      "dueDate": date,
      "title": title,
      "numRate": 0,
      "sumRate": 0,
      "question": cm,
      "order": DateTime.now(),
      "students": []
    });
  }

  void addReminder(
      {required String classId,
      required DateTime date,
      required String title}) {
    reminder.add({
      "class": classId,
      "date": date,
      "title": title,
    });
  }

  void addCourse({
    required String classId,
    required String code,
    required String name,
  }) {
    FirebaseFirestore.instance.collection('Courses').add({
      "id": classId,
      "code": code,
      "name": name,
      "owner": ua.currentUser!.uid,
      "students": []
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getTeacherCourses() {
    return FirebaseFirestore.instance
        .collection('Courses')
        .where("owner", isEqualTo: ua.currentUser!.uid)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getStudentCourses() {
    return FirebaseFirestore.instance
        .collection('Courses')
        .where("students", arrayContains: ua.currentUser!.uid)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getTeacherRemider(String id) {
    print(id);
    return FirebaseFirestore.instance
        .collection('Reminders')
        .where("class", isEqualTo: id)
        .snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getCourse({
    required String code,
  }) async {
    return await FirebaseFirestore.instance
        .collection('Courses')
        .where('code', isEqualTo: code)
        .get();
  }

  Stream<QuerySnapshot<Object?>> getTeacherPopUps(String id) {
    return popups.where("class", isEqualTo: id).snapshots();
  }

  void addPopUpRate(String id, int rate) {
    popups.doc(id).update({
      "numRate": FieldValue.increment(1),
      "sumRate": FieldValue.increment(rate),
      "students": FieldValue.arrayRemove([ua.currentUser!.uid])
    });
  }

  void addCourseToUser(String classid) {
    users.doc(ua.currentUser!.uid).update({
      "courses": FieldValue.arrayUnion([classid])
    });
  }

  void addUserToCourse(String id) {
    courses.doc(id).update({
      "students": FieldValue.arrayUnion([ua.currentUser!.uid])
    });
  }

  Future<Map<String, dynamic>?> readUser(String uid) async {
    DocumentSnapshot documentSnapshot = await ua.users.doc(uid).get();
    return documentSnapshot.exists
        ? documentSnapshot.data()! as Map<String, dynamic>
        : null;
  }
}
