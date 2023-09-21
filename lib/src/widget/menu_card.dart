import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  final String name;
  final Widget designation;
  final Widget icon;

  const MenuCard({
    Key? key,
    required this.name,
    required this.designation,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => designation,
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(right: 5, left: 5),
        child: Container(
          // color: Theme.of(context).colorScheme.tertiaryContainer,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  const Color(0xFFA6D7F3).withAlpha(150),
                  const Color(0xff8458bb).withAlpha(150),
                ],
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 4,
                    spreadRadius: 1,
                    offset: const Offset(4, 4)),
              ],
              borderRadius: BorderRadius.circular(13)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipOval(
                  child: SizedBox.fromSize(
                    size: const Size.fromRadius(24),
                    child: icon,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Playfair_Medium',
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
