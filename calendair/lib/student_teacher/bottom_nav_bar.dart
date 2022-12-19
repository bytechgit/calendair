import 'package:calendair/controllers/nav_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// class BottomNavBar extends StatefulWidget {
//   final List<NBar> items;
//   final int selected;
//   const BottomNavBar({
//     Key? key,
//     required this.items,
//     required this.selected,
//   }) : super(key: key);

//   @override
//   State<BottomNavBar> createState() => _BottomNavBarState();
// }

// class _BottomNavBarState extends State<BottomNavBar> {
//   int index1 = 0;
//   @override
//   void initState() {
//     index1 = widget.selected;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final navBarController = context.watch<NavBarController>();
//    // navbar.index.value = widget.selected;
//     return Container(
//       padding: const EdgeInsets.only(bottom: 16),
//       color: const Color.fromRGBO(93, 159, 196, 1),
//       child: Row(
//         children: [
//           for (int i = 0; i < widget.items.length; i++)
//             Expanded(
//                 child: SizedBox(
//               child: Padding(
//                 padding: const EdgeInsets.only(
//                   top: 10.0,
//                 ),
//                 child: InkWell(
//                   onTap: widget.items[i].onclick,
//                   child: Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                         color: index1 == i
//                             ? Colors.white
//                             : const Color.fromRGBO(93, 159, 196, 1),
//                         shape: BoxShape.circle),
//                     child: SizedBox(
//                       height: 45,
//                       child: Image.asset(
//                           'assets/images/${widget.items[i].slika}.png'),
//                     ),
//                   ),
//                 ),
//               ),
//             ))
//         ],
//       ),
//     );
//   }
// }

class NavBar extends StatelessWidget {
  final List<NavBarItem> navBarItems;
  const NavBar({super.key, required this.navBarItems});
  @override
  Widget build(BuildContext context) {
    final navBarController = context.watch<NavBarController>();
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      color: const Color.fromRGBO(93, 159, 196, 1),
      child: Row(
        children: [
          for (int i = 0; i < navBarItems.length; i++)
            Expanded(
              child: SizedBox(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                  ),
                  child: InkWell(
                    onTap: (() {
                      navBarItems[i].onclick();
                      navBarController.index = i;
                    }),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: navBarController.index == i
                              ? Colors.white
                              : const Color.fromRGBO(93, 159, 196, 1),
                          shape: BoxShape.circle),
                      child: SizedBox(
                        height: 45,
                        child: Image.asset(
                            'assets/images/${navBarItems[i].image}.png'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class NavBarItem {
  final String image;
  final VoidCallback onclick;
  const NavBarItem({required this.image, required this.onclick});
}
