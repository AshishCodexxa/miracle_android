import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miracle/color.dart';
import 'package:miracle/src/data/model/quote_theme.dart';
import 'package:miracle/src/di/app_module.dart';
import 'package:miracle/src/widget/config_bar.dart';
import 'package:miracle/src/widget/config_item.dart';

class ThemesEdit extends ConsumerStatefulWidget {
  ThemesEdit({Key? key}) : super(key: key);

  final List<Color> colors = [
    Colors.white,
    Colors.black,
    Colors.red,
    Colors.yellow,
    Colors.amber
  ];
  final List<double> sizes = [14, 16, 20, 24, 32];

  final List<double> strokes = [0.0, 1.0, 1.5, 2.0];

  final List<Color> shadowColors = [
    Colors.transparent,
    Colors.white,
    Colors.black,
    Colors.red,
    Colors.yellow,
    Colors.amber
  ];

  final List<String> fonts = [
    'Poppins',
    'Roboto',
    'Dancing Script',
    'Racing Sans One',
    'Raleway',
    'Merriweather',
    'Peralta',
    'Lobster',
    'Pacifico',
    'Shadows Into Light',
    'Comforter Brush',
    'Nunito',
    'Kaushan Script'
  ];

  final List<TextAlign> align = [
    TextAlign.left,
    TextAlign.center,
    TextAlign.right,
  ];

  @override
  ConsumerState<ThemesEdit> createState() => _ThemesEditState();
}

class _ThemesEditState extends ConsumerState<ThemesEdit> {
  int _selectedSetting = 0;
  int _selectedConfig = 0;
  bool isChangesSaved = false;
  bool hasChanged = false;
  String title = 'Background';

  Widget _onSettingSelected(int index) {
    if (index == 0) {
      return ConfigBar(
        isFullWidth: true,
        items: const [
          ConfigItem(
            icon: Icons.library_add,
            label: 'Library',
          ),
          ConfigItem(
            icon: FontAwesomeIcons.palette,
            label: 'Colors',
          ),
        ],
        onTap: (i) {},
      );
    }

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
          ],
          onTap: (int i) {
            setState(() {
              _selectedConfig = i;
            });
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
          for (int i = 0; i < widget.colors.length; i++)
            Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.only(left: 12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.colors[i],
              ),
            )
        ];
        onTap = (int i) {
          hasChanged = true;
          setState(() {
            quoteTheme.state =
                quoteTheme.state.copyWith(textColor: widget.colors[i]);
          });
        };
        selectedValue = widget.colors.indexOf(quoteTheme.state.textColor);
        break;
      case 1:
        items = [
          for (int i = 0; i < widget.fonts.length; i++)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Font',
                style: GoogleFonts.getFont(widget.fonts[i])
                    .copyWith(fontSize: 18, color: Colors.white),
              ),
            )
        ];
        onTap = (int i) {
          hasChanged = true;
          setState(() {
            quoteTheme.state =
                quoteTheme.state.copyWith(fontFamily: widget.fonts[i]);
          });
        };
        selectedValue = widget.fonts.indexOf(quoteTheme.state.fontFamily);
        break;
      case 2:
        items = [
          for (int i = 0; i < widget.sizes.length; i++)
            SizedBox(
              width: 48,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'A',
                  style:
                      TextStyle(fontSize: widget.sizes[i], color: Colors.white),
                ),
              ),
            )
        ];
        onTap = (int i) {
          hasChanged = true;
          setState(() {
            quoteTheme.state =
                quoteTheme.state.copyWith(fontSize: widget.sizes[i]);
          });
        };
        selectedValue = widget.sizes.indexOf(quoteTheme.state.fontSize);
        break;
      case 3:
        items = [
          const SizedBox.square(dimension: 36, child: Icon(Icons.block)),
          for (int i = 1; i < widget.strokes.length; i++)
            Container(
              color: Colors.grey.shade100,
              width: 36,
              height: widget.strokes[i],
              margin: const EdgeInsets.symmetric(horizontal: 12),
            )
        ];
        onTap = (int i) {
          hasChanged = true;
          setState(() {
            quoteTheme.state =
                quoteTheme.state.copyWith(strokeWidth: widget.strokes[i]);
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
            quoteTheme.state =
                quoteTheme.state.copyWith(alignment: widget.align[i]);
          });
        };
        selectedValue = widget.align.indexOf(quoteTheme.state.alignment);
        break;
      case 5:
        items = [
          const SizedBox.square(dimension: 36, child: Icon(Icons.block)),
          for (int i = 1; i < widget.sizes.length; i++)
            Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.only(left: 12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.shadowColors[i],
              ),
            )
        ];
        onTap = (int i) {
          hasChanged = true;
          setState(() {
            quoteTheme.state =
                quoteTheme.state.copyWith(shadow: widget.shadowColors[i]);
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
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(color: Colors.red, image: null),
              child: Center(
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
            ),
          ),
          Container(
            color: primaryColor,
            child: Column(children: [
              if (_selectedSetting == 1) ...[
                _onConfigSelected(_selectedConfig),
                Divider(
                  color: Colors.grey[100],
                ),
              ],
              _onSettingSelected(_selectedSetting),
              Divider(
                color: Colors.grey[100],
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      hasChanged = false;
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  ConfigBar(
                    items: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Icon(
                          Icons.image_rounded,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Icon(
                          Icons.text_fields,
                          color: Colors.white,
                        ),
                      ),
                    ],
                    onTap: (int i) {
                      setState(() {
                        _selectedSetting = i;
                        _selectedConfig = 0;
                        if (i == 0) {
                          title = 'Background';
                          return;
                        }
                        title = 'Text';
                      });
                    },
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      isChangesSaved = true;
                      hasChanged = false;
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )
            ]),
          ),
        ],
      ),
    );
  }
}
