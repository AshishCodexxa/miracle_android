import 'package:flutter/material.dart';
import 'package:miracle/src/utils/sizeConfig.dart';

class Tag extends StatelessWidget {
  const Tag({super.key, required this.tag, this.isSelected = false});

  final bool isSelected;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              const Color(0xFFA6D7F3).withAlpha(150),
              const Color(0xff8458bb).withAlpha(150),
            ],
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black54.withOpacity(0.16),
                blurRadius: 3,
                offset: const Offset(4, 7))
          ],
          // border: Border.all(
          //   width: 1.1,
          //   color: Theme.of(context).colorScheme.primary,
          // ),
          borderRadius: BorderRadius.circular(5),
          // color:
          //     isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
          image: isSelected
              ? const DecorationImage(
                  image: AssetImage('assets/images/selected.png'),
                  alignment: Alignment.topRight,
                )
              : null
          //Container(decoration: const BoxDecoration(image:  DecorationImage(image: AssetImage('assets/images/selected.png')))
          // ? const DecorationImage(image: AssetImage('assets/images/selected.png',),)

          //
          // ? const LinearGradient(
          //     begin: Alignment.topRight,
          //     end: Alignment.bottomLeft,
          //     colors: [Colors.purple, Colors.blueAccent],
          //   )
          // gradient: !isSelected
          //     ? LinearGradient(
          //     begin: Alignment.topRight,
          //     end: Alignment.bottomLeft,
          //     colors: [
          //       const Color(0xFFA6D7F3).withAlpha(150),
          //       const Color(0xff8458bb).withAlpha(150),
          //     ],
          //   ) : null,
          ),
      child: Center(
        child: Text(
          tag,
          style: TextStyle(
              color: isSelected ? Colors.black : Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Playfair_Medium'),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
