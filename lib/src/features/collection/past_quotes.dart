import 'package:flutter/material.dart';
import 'package:miracle/color.dart';

class PastQuotes extends StatelessWidget {
  const PastQuotes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Past Quotes',
        style: TextStyle(
          color: Colors.white
        ),),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            const Image(
              image: AssetImage('assets/images/no-collection.png'),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              'You haven\'t have any \ncollections yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Collections group quotes you save together, like\n\'Loving myself\' or \'Reaching my goals\'.',
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width * 0.6, 40),
              ),
              onPressed: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => const CollectionQuotes(collection: ,),
                //   ),
                // );
              },
              child: const Text('Create Collection'),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
