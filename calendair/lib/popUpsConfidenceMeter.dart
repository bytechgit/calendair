import 'package:calendair/models/CustomCourse.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'classes/googleClassroom.dart';
import 'bottomNavBar.dart';
import 'models/nbar.dart';

class PopUpsConfidenceMeter extends StatefulWidget {
  final CustomCourse course;
  const PopUpsConfidenceMeter({Key? key, required this.course})
      : super(key: key);

  @override
  State<PopUpsConfidenceMeter> createState() => _PopUpsConfidenceMeterState();
}

class _PopUpsConfidenceMeterState extends State<PopUpsConfidenceMeter> {
  final gc = Get.find<GoogleClassroom>();
  final con = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              slika: 'home',
              onclick: () {
                Get.until((route) =>
                    (route as GetPageRoute).routeName == '/TeacherDashboard');
              }),
        ],
        selected: 0,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: SizedBox(
                width: width * 0.5,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.course.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: width * 0.8,
              child: const Divider(
                thickness: 10,
                height: 15,
                color: Color.fromRGBO(223, 223, 223, 1),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: width * 0.8,
              child: const FittedBox(
                child: Text(
                  'Confidence Meter Question',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 20),
              child: SizedBox(
                width: width * 0.7,
                //height: 40,
                child: TextField(
                  maxLines: 3,
                  controller: con,
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
            const Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: width * 0.60,
                height: 70,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shadowColor: const Color.fromRGBO(247, 247, 247, 1),
                      backgroundColor: const Color.fromRGBO(94, 159, 197, 1),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                  onPressed: () {
                    gc.confidence = con.text;
                    Get.back();
                  },
                  child: const Text(
                    'Update',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ), // <-- Text
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
