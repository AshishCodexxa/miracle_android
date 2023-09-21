import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miracle/src/data/model/quote.dart';
import 'package:miracle/src/di/app_module.dart';
import 'package:miracle/src/utils/constant.dart';
import 'package:path_provider/path_provider.dart';

class Screenshot1 extends ConsumerStatefulWidget {
  const Screenshot1({Key? key, required this.quote}) : super(key: key);

  final Quote quote;

  @override
  ConsumerState<Screenshot1> createState() => _ScreenshotState();
}

class _ScreenshotState extends ConsumerState<Screenshot1> {
  GlobalKey globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => capturePng());
  }

  Future<void> capturePng() async {
    try {
      RenderRepaintBoundary? boundary = globalKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;

      ui.Image? image = await boundary?.toImage(pixelRatio: 1.0);
      ByteData? byteData =
          await image?.toByteData(format: ui.ImageByteFormat.png);

      var pngBytes = byteData?.buffer.asUint8List();
      if (pngBytes != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath =
            await File('${directory.path}/container_image.png').create();
        await imagePath.writeAsBytes(pngBytes);
        GallerySaver.saveImage(imagePath.path, albumName: kTitle).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Saved to gallery'),
              duration: Duration(seconds: 3),
            ),
          );
          imagePath.delete();
          Navigator.of(context).pop();
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(quoteThemeProvider);

    final activatedTheme = GetStorage().read<String>(kActiveTheme) ?? '';

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: RepaintBoundary(
          key: globalKey,
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
              Center(
                child: Text(
                  widget.quote.quote,
                  style: GoogleFonts.getFont(theme.fontFamily).copyWith(
                    fontSize: theme.fontSize,
                    foreground: Paint()
                      ..style = theme.strokeWidth == 0
                          ? PaintingStyle.fill
                          : PaintingStyle.stroke
                      ..strokeWidth = theme.strokeWidth
                      ..color = theme.textColor,
                    shadows: [
                      Shadow(
                        offset: const Offset(1, 1),
                        blurRadius: 8,
                        color: theme.shadow,
                      ),
                    ],
                  ),
                  textAlign: theme.alignment,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
