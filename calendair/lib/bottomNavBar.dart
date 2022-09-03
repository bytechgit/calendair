// ignore_for_file: unused_local_variable

import 'package:calendair/Classes/navBar.dart';
import 'package:calendair/models/nbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class BottomNavBar extends StatefulWidget {
  final List<NBar> items;
  final int selected;
  const BottomNavBar({
    Key? key,
    required this.items,
    required this.selected,
  }) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int index1 = 0;
  @override
  void initState() {
    index1 = widget.selected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final navbar = Get.find<NavBar>();

    navbar.index.value = widget.selected;
    return Container(
      color: const Color.fromRGBO(93, 159, 196, 1),
      height: 60,
      child: Row(
        children: [
          for (int i = 0; i < widget.items.length; i++)
            Expanded(
                child: SizedBox(
              child: Padding(
                padding: EdgeInsets.all(3.0),
                child: InkWell(
                  onTap: widget.items[i].onclick,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: index1 == i
                            ? Colors.white
                            : const Color.fromRGBO(93, 159, 196, 1),
                        shape: BoxShape.circle),
                    child: Image.asset(
                        'assets/images/${widget.items[i].slika}.png'),
                  ),
                ),
              ),
            ))
        ],
      ),
    );
  }
}




// Container(
//         height: 60,
//         color: const Color.fromRGBO(93, 159, 196, 1),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             InkWell(
//               onTap: () {
//                 Get.to(
//                   const Calendar(),
//                   transition: Transition.circularReveal,
//                   duration: const Duration(milliseconds: 800),
//                 );
//               },
//               child: InkWell(
//                   onTap: () {
//                     Get.to(
//                       const Calendar(),
//                       transition: Transition.circularReveal,
//                       duration: const Duration(milliseconds: 800),
//                     );
//                   },
//                   child: InkWell(
//                       onTap: () {
//                         Get.to(
//                           const dashboard(),
//                           transition: Transition.circularReveal,
//                           duration: const Duration(milliseconds: 800),
//                         );
//                       },
//                       child: Image.asset('assets/images/calendar.png'))),
//             ),
//             Image.asset('assets/images/home.png'),
//             InkWell(
//                 onTap: () {
//                   Get.to(
//                     const Settings(),
//                     transition: Transition.circularReveal,
//                     duration: const Duration(milliseconds: 800),
//                   );
//                 },
//                 child: Image.asset('assets/images/settings.png')),
//           ],
//         ),
//       ),