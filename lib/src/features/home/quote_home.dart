import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_storage/get_storage.dart';
import 'package:miracle/src/data/model/quote.dart';
import 'package:miracle/src/utils/constant.dart';
import 'package:miracle/src/widget/quote_widget.dart';

class QuoteHome extends HookWidget {
  const QuoteHome({Key? key, required this.quotes}) : super(key: key);

  final List<Quote> quotes;

  @override
  Widget build(BuildContext context) {
    final activatedTheme = GetStorage().read<String>(kActiveTheme) ?? '';

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            activatedTheme.isEmpty
                ? Image.asset(
                    'assets/images/background.jpeg',
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    File(activatedTheme),
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
            PageView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: quotes.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return QuoteWidget(
                  quote: quotes[index],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
