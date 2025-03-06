import 'package:flutter/material.dart';
import 'package:miracle/color.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: primaryColor,
        leading: const Icon(Icons.arrow_back,
          color: Colors.white,),
        title: const Text('Contact Us',
        style: TextStyle(
          color: Colors.white
        ),),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     Padding(
                    //       padding: EdgeInsets.only(left: 20),
                    //       child: Text("Contact Number",
                    //         style: TextStyle(
                    //           fontSize: 18,
                    //           fontWeight: FontWeight.w500,
                    //           color: Theme.of(context).colorScheme.onPrimaryContainer,
                    //         ),),
                    //     ),
                    //   ],
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children:  [
                    //     Padding(
                    //       padding: EdgeInsets.only(top: 10, left: 20),
                    //       child: Text("9437440284",
                    //         style: Theme.of(context).textTheme.titleSmall,),
                    //     ),
                    //   ],
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.only(top: 15),
                    //   child: Container(
                    //     height: 1,
                    //     color: Theme.of(context).colorScheme.outline,
                    //   ),
                    // ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            "Email Id",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 20),
                          child: Text(
                            "support@heeradhar.com",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                      ],
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(top: 15),
                    //   child: Container(
                    //     height: 1,
                    //     color: Theme.of(context).colorScheme.outline,
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
