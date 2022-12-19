import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendair/classes/authentication.dart';
import 'package:calendair/models/nbar.dart';
import 'package:calendair/student/settings.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../student_teacher/bottom_nav_bar.dart';
import 'dashboard.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({Key? key}) : super(key: key);

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  String? imgUrl;
  final name = TextEditingController();
  bool uploading = false;
  late final UserAuthentication userAuthentication;

  @override
  void initState() {
    userAuthentication = context.read<UserAuthentication>();
    name.text = userAuthentication.currentUser?.name ?? " ";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

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
      bottomNavigationBar: BottomNavBar(
        items: [
          NBar(
              slika: 'calendar',
              onclick: () {
                Get.off(
                  const Dashboard(),
                  transition: Transition.circularReveal,
                  duration: const Duration(milliseconds: 800),
                );
              }),
          NBar(
              slika: 'home',
              onclick: () {
                Get.until(
                    (route) => route.settings.name == '/StudentDashboard');
              }),
          NBar(
              slika: 'settings',
              onclick: () {
                Get.off(
                  const Settings(),
                  transition: Transition.circularReveal,
                  duration: const Duration(milliseconds: 800),
                );
              })
        ],
        selected: 2,
      ),
      body: SafeArea(
          child: Stack(
        children: [
          Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: SizedBox(
                    width: width * 0.8,
                    child: const FittedBox(
                      child: Text(
                        'Account Settings',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(child: Container()),
                SizedBox(
                  width: width * 0.13,
                  child: const FittedBox(
                    child: Text(
                      'Icon',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(93, 159, 196, 1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                        child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: (imgUrl == null || imgUrl == "")
                              ? CachedNetworkImage(
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      userAuthentication.currentUser?.picture ??
                                          "",
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.no_accounts),
                                )
                              : Image.file(
                                  width: 200,
                                  height: 200,
                                  File(imgUrl!),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Align(
                            alignment: Alignment.bottomRight,
                            child: InkWell(
                                onTap: () async {
                                  FilePickerResult? result =
                                      await FilePicker.platform.pickFiles();
                                  if (result != null) {
                                    setState(() {
                                      imgUrl = result.files.single.path;
                                    });
                                  } else {
                                    // User canceled the picker
                                  }
                                },
                                child: SizedBox(
                                  width: 45,
                                  child: Image.asset(
                                      'assets/images/changePhoto.png'),
                                ))),
                      ],
                    )),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: FittedBox(
                    child: Text(
                      "Name",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0, bottom: 30),
                  child: SizedBox(
                    width: width * 0.7,
                    //height: 40,
                    child: TextField(
                      controller: name,
                      maxLines: 3,
                      minLines: 1,
                      keyboardType: TextInputType.multiline,
                      style: const TextStyle(
                          color: Color.fromRGBO(38, 64, 78, 1), fontSize: 25),
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10.0),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        filled: true,
                        hintStyle: const TextStyle(
                            color: Color.fromRGBO(38, 64, 78, 1), fontSize: 25),
                        hintText: "Please Enter",
                        fillColor: const Color.fromRGBO(94, 159, 197, 1),
                      ),
                    ),
                  ),
                ),
                Expanded(child: Container()),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: SizedBox(
                    width: width * 0.6,
                    height: 80,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shadowColor: const Color.fromRGBO(247, 247, 247, 1),
                          backgroundColor:
                              const Color.fromRGBO(94, 159, 197, 1),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                      onPressed: () async {
                        if (imgUrl != null) {
                          setState(() {
                            uploading = true;
                          });
                          final storageRef = FirebaseStorage.instance.ref();
                          File file = File(imgUrl!);
                          final mountainsRef = storageRef.child(
                              "${userAuthentication.currentUser?.uid}.jpg");
                          try {
                            await mountainsRef.putFile(file);
                            final img = await mountainsRef.getDownloadURL();
                            userAuthentication.updateUser(
                                name: name.text, img: img);
                            setState(() {});
                          } on FirebaseException catch (e) {
                            //   // ...
                          }
                        } else if (userAuthentication.currentUser?.name !=
                            name.text) {
                          userAuthentication.updateUser(name: name.text);
                        }
                        setState(() {
                          uploading = false;
                        });
                        Get.back();
                      },

                      child: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Update',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ), // <-- Text
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (uploading)
            const InkWell(child: Center(child: CircularProgressIndicator()))
        ],
      )),
    );
  }
}
