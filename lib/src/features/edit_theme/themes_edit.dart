import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miracle/color.dart';
import 'package:miracle/src/data/model/quote_theme.dart';
import 'package:miracle/src/di/app_module.dart';
import 'package:miracle/src/utils/common.dart';
import 'package:miracle/src/utils/constant.dart';
import 'package:miracle/src/widget/config_bar.dart';
import 'package:miracle/src/widget/config_item.dart';
import 'package:path_provider/path_provider.dart';

class ThemesEdit extends ConsumerStatefulWidget {
  const ThemesEdit({Key? key}) : super(key: key);

  @override
  ConsumerState<ThemesEdit> createState() => _ThemesEditState();
}

class _ThemesEditState extends ConsumerState<ThemesEdit> {
  final int _selectedSetting = 0;
  int _selectedConfig = 0;
  bool isChangesSaved = false;
  bool hasChanged = false;
  String title = 'Text Theme';
  String activatedTheme = GetStorage().read<String>(kActiveTheme) ?? '';

  Widget _onSettingSelected(int index) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.4,
        ),
        child: ConfigBar(
          items: const [
            ConfigItem(
              icon: FontAwesomeIcons.palette,
              label: 'Color',
            ),
            ConfigItem(
              icon: FontAwesomeIcons.font,
              label: 'Font',
            ),
            ConfigItem(
              icon: Icons.format_size_outlined,
              label: 'Size',
            ),
            ConfigItem(
              icon: Icons.remove,
              label: 'Stroke',
            ),
            ConfigItem(
              icon: FontAwesomeIcons.alignCenter,
              label: 'Alignment',
            ),
            ConfigItem(
              icon: Icons.text_format,
              label: 'Shadow',
            ),
            ConfigItem(
              icon: FontAwesomeIcons.images,
              label: 'Image',
            ),
          ],
          onTap: (int i) {
            if (i == 6) {
              ImagePicker()
                  .pickImage(source: ImageSource.gallery)
                  .then((pickedImage) {
                if (pickedImage == null) return;
                setState(() {
                  activatedTheme = pickedImage.path;
                });
              });
            } else {
              setState(() {
                _selectedConfig = i;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _onConfigSelected(int index) {
    List<Widget> items = [];
    void Function(int) onTap = (i) {};
    final quoteTheme = ref.read(quoteThemeProvider.notifier);
    int selectedValue = 0;

    switch (index) {
      case 0:
        items = [
          for (int i = 0; i < colors.length; i++)
            Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.only(left: 12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors[i],
              ),
            )
        ];
        onTap = (int i) {
          hasChanged = true;
          setState(() {
            quoteTheme.state = quoteTheme.state.copyWith(textColor: colors[i]);
          });
        };
        selectedValue = colors.indexOf(quoteTheme.state.textColor);
        break;
      case 1:
        items = [
          for (int i = 0; i < fonts.length; i++)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Font',
                style: GoogleFonts.getFont(fonts[i])
                    .copyWith(fontSize: 18, color: Colors.white),
              ),
            )
        ];
        onTap = (int i) {
          hasChanged = true;
          setState(() {
            quoteTheme.state = quoteTheme.state.copyWith(fontFamily: fonts[i]);
          });
        };
        selectedValue = fonts.indexOf(quoteTheme.state.fontFamily);
        break;
      case 2:
        items = [
          for (int i = 0; i < sizes.length; i++)
            SizedBox(
              width: 48,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'A',
                  style: TextStyle(fontSize: sizes[i], color: Colors.white),
                ),
              ),
            )
        ];
        onTap = (int i) {
          hasChanged = true;
          setState(() {
            quoteTheme.state = quoteTheme.state.copyWith(fontSize: sizes[i]);
          });
        };
        selectedValue = sizes.indexOf(quoteTheme.state.fontSize);
        break;
      case 3:
        items = [
          const SizedBox.square(dimension: 36, child: Icon(Icons.block)),
          for (int i = 1; i < strokes.length; i++)
            Container(
              color: Colors.grey.shade100,
              width: 36,
              height: strokes[i],
              margin: const EdgeInsets.symmetric(horizontal: 12),
            )
        ];
        onTap = (int i) {
          hasChanged = true;
          setState(() {
            quoteTheme.state =
                quoteTheme.state.copyWith(strokeWidth: strokes[i]);
          });
        };
        break;
      case 4:
        items = [
          const SizedBox(
            width: 48,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: FaIcon(
                FontAwesomeIcons.alignLeft,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            width: 48,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: FaIcon(
                FontAwesomeIcons.alignCenter,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            width: 48,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: FaIcon(
                FontAwesomeIcons.alignRight,
                color: Colors.white,
              ),
            ),
          ),
        ];
        onTap = (int i) {
          hasChanged = true;
          setState(() {
            quoteTheme.state = quoteTheme.state.copyWith(alignment: align[i]);
          });
        };
        selectedValue = align.indexOf(quoteTheme.state.alignment);
        break;
      case 5:
        items = [
          const SizedBox.square(dimension: 36, child: Icon(Icons.block)),
          for (int i = 1; i < shadowColors.length; i++)
            Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.only(left: 12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: shadowColors[i],
              ),
            )
        ];
        onTap = (int i) {
          hasChanged = true;
          setState(() {
            quoteTheme.state =
                quoteTheme.state.copyWith(shadow: shadowColors[i]);
          });
        };
        break;
      default:
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.4,
        ),
        child: ConfigBar(
          items: items,
          onTap: onTap,
          selectedItem: selectedValue,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    QuoteTheme quoteTheme = ref.watch(quoteThemeProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('$title Editing'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                GetStorage().write(kActiveTextTheme, quoteTheme.toJson());

                saveImage(activatedTheme, '.jpg');

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Saved Successfully',
                    ),
                    duration: Duration(seconds: 3),
                  ),
                );
              },
              icon: const Icon(Icons.save))
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Center(
              child: Stack(children: [
                Align(
                  child: activatedTheme.isEmpty
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
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Don\'t talk, just act.\nDon\'t say, just show.\nDon\'t promise, just prove.',
                    style: GoogleFonts.getFont(quoteTheme.fontFamily,
                        fontSize: quoteTheme.fontSize,
                        foreground: Paint()
                          ..style = quoteTheme.strokeWidth == 0
                              ? PaintingStyle.fill
                              : PaintingStyle.stroke
                          ..strokeWidth = quoteTheme.strokeWidth
                          ..color = quoteTheme.textColor,
                        shadows: [
                          Shadow(
                            offset: const Offset(1, 1),
                            blurRadius: 8,
                            color: quoteTheme.shadow,
                          ),
                        ]),
                    textAlign: quoteTheme.alignment,
                  ),
                ),
              ]),
            ),
          ),
          Container(
            color: primaryColor,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              _onConfigSelected(_selectedConfig),
              Divider(
                color: Colors.grey[100],
              ),
              _onSettingSelected(_selectedSetting),
            ]),
          ),
        ],
      ),
    );
  }
}

saveImage(String filePath, String ext) async {
  final asd = await getApplicationDocumentsDirectory();

  final directory = Directory('${asd.path}/themes');
  if (!await directory.exists()) {
    await directory.create();
  }
  final file = File(filePath);
  String fileName = '${DateTime.now().toString()}$ext';
  await file.copy('${directory.path}/$fileName');
  GetStorage().write(kActiveTheme, '${directory.path}/$fileName');
  await file.delete();
}
