import 'package:calendair/classes/nav_bar.dart';
import 'package:calendair/models/nbar.dart';
import 'package:flutter/material.dart';
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
      padding: const EdgeInsets.only(bottom: 16),
      color: const Color.fromRGBO(93, 159, 196, 1),
      child: Row(
        children: [
          for (int i = 0; i < widget.items.length; i++)
            Expanded(
                child: SizedBox(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                ),
                child: InkWell(
                  onTap: widget.items[i].onclick,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: index1 == i
                            ? Colors.white
                            : const Color.fromRGBO(93, 159, 196, 1),
                        shape: BoxShape.circle),
                    child: SizedBox(
                      height: 45,
                      child: Image.asset(
                          'assets/images/${widget.items[i].slika}.png'),
                    ),
                  ),
                ),
              ),
            ))
        ],
      ),
    );
  }
}
