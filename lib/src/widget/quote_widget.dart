import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gallery_saver/gallery_saver.dart';
// import 'package:gallery_saver/gallery_saver.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:miracle/src/data/model/quote.dart';
import 'package:miracle/src/data/network/dio_client.dart';
import 'package:miracle/src/data/network/responses/quote_response.dart';
import 'package:miracle/src/di/app_module.dart';
import 'package:miracle/src/utils/common.dart';
import 'package:miracle/src/utils/constant.dart';
import 'package:miracle/src/utils/quote_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class QuoteWidget extends HookConsumerWidget {
  const QuoteWidget({Key? key, required this.quote}) : super(key: key);

  final Quote quote;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = useState<bool>(quote.favorite == 1);
    final theme = ref.watch(quoteThemeProvider);

    print("quotequotequote $quote");

    final favorite = useState<List<Quote>>([]);

    List<dynamic> favData = [];
    bool isQuotePresent = false;

    refresh() async {
      final data = await DioClient().getFavorite();
      final response = QuoteResponse.fromJson(data!);
      favData = response.data;
      isQuotePresent = favData.any((item) {
        print("itemssssss ${item.id} ${quote.id}");
        return item.id == quote.id;
      });
      print("isQuotePresent $isQuotePresent");
      if (isQuotePresent) {
        print("Yes, the quote is present in the favorites.");
        isFavorite.value = true;
      } else {
        print("No, the quote is not present in the favorites.");
        isFavorite.value = false;
      }
    }

    refresh();

    useEffect(() {
      refresh();
      return;
    }, []);

    Future<File> saveScreenshot() async {
      final activatedTheme = GetStorage().read<String>(kActiveTheme) ?? '';
      final imgBytes = await ScreenshotController().captureFromWidget(
        Stack(
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  quote.quote,
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
            ),
          ],
        ),
      );

      final directory = await getApplicationDocumentsDirectory();
      final imagePath = await File(
              '${directory.path}/${DateTime.now().microsecondsSinceEpoch}.png')
          .create();

      return imagePath.writeAsBytes(imgBytes);
    }
    test() async{
     await DioClient().deleteFavorite(quote.id).then((value) {
        print('value is= $value');
        isFavorite.value = !isFavorite.value;
      });
    }

/*    toggleFavorite() {
      try{
        test();
      }
      on DioError catch (e){
        print('fav error= ${e.response!.statusCode}');
      }
      if (isFavorite.value) {

      } else {
        DioClient().addFavorite(quote.id).then((value) {
          isFavorite.value = !isFavorite.value;
        });
      }
    }*/

    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomRight,
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            IconButton(
              icon: Icon(
                isFavorite.value
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_outlined,
                color: isFavorite.value ? Colors.red:const Color(0xff800020),
              ),
              onPressed: /*toggleFavorite*/(){
                if(isQuotePresent == false){
                  DioClient().addFavorite(quote.id).then((value) {
                    final response = QuoteResponse.fromJson(value!);
                    favData = response.data;
                    isQuotePresent = favData.any((item) {
                      print("itemssssss ${item.id} ${quote.id}");
                      return item.id == quote.id;
                    });
                    print("isQuotePresent $isQuotePresent");
                    if (isQuotePresent) {
                      print("Yes, the quote is present in the favorites.");
                      isFavorite.value = true;
                    } else {
                      print("No, the quote is not present in the favorites.");
                      isFavorite.value = false;
                    }
                  });
                }else if(isQuotePresent == true){
                  DioClient().deleteFavorite(quote.id).then((value) {
                    print('value is= $value');
                    isFavorite.value = false;
                  });
                }

              },
            ),
            IconButton(
              icon: const Icon(
                Icons.bookmark_outline,
                  color: Color(0xff800020)
              ),
              onPressed: () {
                showCollections(context, quoteId: quote.id);
              },
            ),
            IconButton(
                icon: const Icon(
                  Icons.save_alt_outlined,
                    color: Color(0xff800020)
                ),
                onPressed: () {
                  saveScreenshot().then(
                    (imagePath) {
                      GallerySaver.saveImage(imagePath.path, albumName: kTitle)
                          .then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Saved to gallery'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                        imagePath.delete();
                      });
                    },
                  );
                }),
            IconButton(
              icon: const Icon(
                Icons.share_outlined,
                  color: Color(0xff800020)
              ),
              onPressed: () {
                saveScreenshot().then((imagePath) {
                  Share.shareXFiles(
                    [XFile(imagePath.path)],
                    text:
                        'Hey there! Check out this app for inspiring, motivating quotes and sayings: https://play.google.com/store/apps/details?id=com.manifestmiracle.app',
                  ).then((value) {
                    imagePath.delete();
                  });
                });
                // share(quote.quote);
              },
            ),
          ]),
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  quote.quote,
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
            ),
          ),
        ),
      ],
    );
  }
}
