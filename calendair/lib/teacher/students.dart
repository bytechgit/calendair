import 'package:calendair/controllers/firebase_controller.dart';
import 'package:calendair/models/user_model.dart';
import 'package:calendair/student_teacher/bottom_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Students extends StatelessWidget {
  final String courseId;
  const Students({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    final firebaseController = context.read<FirebaseController>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(93, 159, 196, 1),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      bottomNavigationBar: NavBar(
        navBarItems: [
          NavBarItem(
              image: 'home',
              onclick: () {
                Get.until((route) =>
                    (route as GetPageRoute).routeName == '/TeacherDashboard');
              }),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: double.infinity,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                ),
                child: SizedBox(
                  width: 80.w,
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Students',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Center(
                child: SizedBox(
                  width: 80.w,
                  child: const Divider(
                    thickness: 10,
                    height: 15,
                    color: Color.fromRGBO(223, 223, 223, 1),
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                  stream: firebaseController.getStudents(courseId),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<dynamic, dynamic>>>
                          snapshot) {
                    if (snapshot.hasData) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            ...snapshot.data!.docs.map((d) {
                              final s = UserModel.fromMap(
                                  d.data() as Map<String, dynamic>, d.id);
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Container(
                                  height: 55,
                                  width: 75.w,
                                  decoration: const BoxDecoration(
                                      color: Color.fromRGBO(217, 217, 217, 1),
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(30),
                                          bottomRight: Radius.circular(30))),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: CachedNetworkImage(
                                            imageUrl: s.picture,
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator(),
                                            errorWidget: (context, url,
                                                    error) =>
                                                const Icon(Icons.no_accounts),
                                          ),
                                        ),
                                        Expanded(
                                          child: FittedBox(
                                            alignment: Alignment.centerLeft,
                                            fit: BoxFit.scaleDown,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 20, left: 10),
                                              child: Text(
                                                s.name,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 30,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
