import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendair/controllers/firebase_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  String? imgUrl;
  final name = TextEditingController();
  bool uploading = false;
  late final FirebaseController firebaseController;

  @override
  void initState() {
    firebaseController = context.read<FirebaseController>();
    name.text = firebaseController.currentUser?.name ?? " ";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(93, 159, 196, 1),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
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
                      width: 80.w,
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
                    width: 13.w,
                    child: const FittedBox(
                      child: Text(
                        'Icon',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
                                    imageUrl: firebaseController
                                            .currentUser?.picture ??
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
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0, bottom: 30),
                    child: SizedBox(
                      width: 70.w,
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
                              color: Color.fromRGBO(38, 64, 78, 1),
                              fontSize: 25),
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
                      width: 60.w,
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
                                "${firebaseController.currentUser?.uid}.jpg");
                            try {
                              await mountainsRef.putFile(file);
                              final img = await mountainsRef.getDownloadURL();
                              firebaseController.updateUser(
                                  name: name.text, img: img);
                              setState(() {});
                            } on FirebaseException catch (e) {
                              print(e);
                            }
                          } else if (firebaseController.currentUser?.name !=
                              name.text) {
                            firebaseController.updateUser(name: name.text);
                          }
                          setState(() {
                            uploading = false;
                          });
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pop();
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
      ),
    );
  }
}
