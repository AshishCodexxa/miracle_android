import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('App Icon'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(4),
        child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1 / 1,
          ),
          itemCount: 6,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 206, 206, 206),
              ),
            );
          },
        ),
      ),
    );
  }
}
