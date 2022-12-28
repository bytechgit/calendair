import 'package:calendair/student_teacher/login.dart';
import 'package:calendair/student_teacher/enter_school_code.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class LoginRegister extends StatelessWidget {
  const LoginRegister({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            child: Image.network(
              'https://pbs.twimg.com/profile_images/1234567890/profile_picture.jpg',
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Ime Prezime',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text('Kratki opis o sebi'),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text('30'),
                  Text('Pratioci'),
                ],
              ),
              Column(
                children: [
                  Text('20'),
                  Text('Pratim'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
