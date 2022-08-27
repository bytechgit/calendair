import 'package:flutter/material.dart';

import 'bottomNavBar.dart';
import 'models/nbar.dart';

class AddClassReminderSend extends StatefulWidget {
  const AddClassReminderSend({Key? key}) : super(key: key);

  @override
  State<AddClassReminderSend> createState() => _AddClassReminderSendState();
}

class _AddClassReminderSendState extends State<AddClassReminderSend> {
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
            onPressed: () {},
          ),
        ),
        bottomNavigationBar: BottomNavBar(
          items: [
            NBar(
              slika: 'home',
            ),
          ],
          selected: 0,
        ),
        body: SafeArea(
            child: Center(
                child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: SizedBox(
              width: width * 0.5,
              child: const FittedBox(
                child: Text(
                  'Period 1',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
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
          SizedBox(
            width: width * 0.7,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: const Text(
                'Reminder Title',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 30),
            child: SizedBox(
              width: width * 0.7,
              //height: 40,
              child: TextField(
                maxLines: 3,
                minLines: 1,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(
                    color: Color.fromRGBO(38, 64, 78, 1), fontSize: 25),
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
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
          SizedBox(
            width: width * 0.7,
            child: const Text(
              'Date of Reminder',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 30),
            child: SizedBox(
              width: width * 0.7,
              //height: 40,
              child: TextField(
                maxLines: 3,
                minLines: 1,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(
                    color: Color.fromRGBO(38, 64, 78, 1), fontSize: 25),
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  filled: true,
                  hintStyle: const TextStyle(
                      color: Color.fromRGBO(38, 64, 78, 1), fontSize: 25),
                  hintText: "00",
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
                    primary: const Color.fromRGBO(94, 159, 197, 1),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    )),
                onPressed: () {},

                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: const Text(
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
        ]))));
  }
}
