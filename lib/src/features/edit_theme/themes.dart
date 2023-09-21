import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:miracle/src/data/model/quote_theme.dart';
import 'package:miracle/src/data/network/dio_client.dart';
import 'package:miracle/src/di/app_module.dart';
import 'package:miracle/src/utils/common.dart';
import 'package:miracle/src/utils/constant.dart';

class Themes extends HookConsumerWidget {
  const Themes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState<bool>(false);
    // final themes = useState<List<BackgroundTheme>>([]);

    final themes = <QuoteTheme>[
      QuoteTheme(fontFamily: fonts[15], fontSize: 22, textColor: colors[1],shadow: shadowColors[0]),
      QuoteTheme(fontFamily: fonts[17], fontSize: 24, textColor: colors[1],shadow: shadowColors[0]),
      QuoteTheme(
        fontFamily: fonts[6],
        fontSize: 24,
        textColor: colors[1],
        shadow: shadowColors[0],
      ),
      QuoteTheme(fontFamily: fonts[14], fontSize: 24, textColor: colors[1],shadow: shadowColors[0]),
      QuoteTheme(
        fontFamily: fonts[18],
        fontSize: 28,
        textColor: colors[1],
        shadow: shadowColors[0],
      ),
      QuoteTheme(fontFamily: fonts[2], fontSize: 25, textColor: colors[0],shadow: shadowColors[0]),
      QuoteTheme(fontFamily: fonts[16], fontSize: 25, textColor: colors[1], shadow: shadowColors[0],),
      //QuoteTheme(fontFamily: fonts[6], fontSize: 24, textColor: colors[1], shadow: shadowColors[0],),
      QuoteTheme(fontFamily: fonts[0], fontSize: 27, textColor: colors[1], shadow: shadowColors[0],),
      QuoteTheme(fontFamily: fonts[7], fontSize: 27, textColor: colors[0], shadow: shadowColors[0],),
      QuoteTheme(fontFamily: fonts[11], fontSize: 26, textColor: colors[0], shadow: shadowColors[0],),
      QuoteTheme(fontFamily: fonts[6], fontSize: 25, textColor: colors[1],shadow: shadowColors[0]),
      QuoteTheme(fontFamily: fonts[17], fontSize: 30, textColor: colors[1], shadow: shadowColors[0],),
      QuoteTheme(fontFamily: fonts[13], fontSize: 32, textColor: colors[0], shadow: shadowColors[0],),
    ];



    final images = <String>[
      'https://admin.manifestmiracle.net/img/theme/background/20230201160830.png',
      'https://admin.manifestmiracle.net/img/theme/background/20230201160848.png',
      'https://admin.manifestmiracle.net/img/theme/background/20230201160951.png',
      'https://admin.manifestmiracle.net/img/theme/background/20230201161011.png',
      'https://admin.manifestmiracle.net/img/theme/background/20230201161031.png',
      'https://admin.manifestmiracle.net/img/theme/background/20230201161048.png',
      'https://admin.manifestmiracle.net/img/theme/background/20230201161114.png',
     // 'https://admin.manifestmiracle.net/img/theme/background/20230201161131.png',
      'https://admin.manifestmiracle.net/img/theme/background/20230201161148.png',
      'https://admin.manifestmiracle.net/img/theme/background/20230201161210.png',
      'https://admin.manifestmiracle.net/img/theme/background/20230201161235.png',
      'https://admin.manifestmiracle.net/img/theme/background/20230201161300.png',
      'https://admin.manifestmiracle.net/img/theme/background/20230201161335.png',
      'https://admin.manifestmiracle.net/img/theme/background/20230201161355.png'
    ];


    refresh() async {
      isLoading.value = true;
      // final response = await DioClient().getThemes();

      isLoading.value = false;
    }

    useEffect(() {
      refresh();
      return;
    }, []);


    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Themes'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            /*  GradientButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ThemesEdit(),
                  ),
                );
              },
              label: 'Edit Current Theme',
            ), 
            const SizedBox(
              height: 8,
            ),*/
            Expanded(
              child: isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1 / 1.5,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: themes.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Activating...'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            /* DioClient()
                                .downloadTheme(
                              '${kBaseUrl}img/theme/background/${themes.value[index].image}',
                              themes.value[index].image,
                            )
                                .then(
                              (value) {
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Theme Activated'),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              },
                            ); */
                            DioClient()
                                .downloadTheme(
                              images[index],
                              images[index].split('/').last,
                            )
                                .then(
                              (value) {
                                ref.read(quoteThemeProvider.notifier).state =
                                    themes[index];
                                GetStorage().write(
                                    kActiveTextTheme, themes[index].toJson());
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Theme Activated'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                            );
                          },
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image(
                                  image: CachedNetworkImageProvider(
                                  images[index],),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional.center,
                                child: Text(
                                  'ABCD',
                                  style: GoogleFonts.getFont(
                                    themes[index].fontFamily,
                                  ).copyWith(
                                    fontSize: themes[index].fontSize,
                                    foreground: Paint()
                                      ..style = themes[index].strokeWidth == 0
                                          ? PaintingStyle.fill
                                          : PaintingStyle.stroke
                                      ..strokeWidth = themes[index].strokeWidth
                                      ..color = themes[index].textColor,
                                    shadows: [
                                      Shadow(
                                        offset: const Offset(1, 1),
                                        blurRadius: 8,
                                        color: themes[index].shadow,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

}
