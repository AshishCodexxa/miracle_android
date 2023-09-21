import 'package:flutter/material.dart';

final List<String> kNotificationReminderOptions = List.generate(48, (index) {
  String division = (index * 30 / 60).floor().toString().padLeft(2, '0');
  String reminder = (index * 30 % 60).toString().padLeft(2, '0');
  return '$division:$reminder';
});

final List<String> kNotificationFrequency =
    List.generate(30, (index) => '${index + 1} X');

final Map<String, int> kWeekDays = {
  'SUN': DateTime.sunday,
  'MON': DateTime.monday,
  'TUE': DateTime.tuesday,
  'WED': DateTime.wednesday,
  'THU': DateTime.thursday,
  'FRI': DateTime.friday,
  'SAT': DateTime.saturday
};

enum CollectionAction {
  shareCollection,
  editCollection,
  removeCollection,
  addQuoteToCollection,
  saveToFavorite,
  copyQuote,
  shareQuote,
  removeQuote,
  removeFavoriteQuote,
  editQuote,
}

final List<Color> colors = [
  Colors.white,
  Colors.black,
  Colors.red,
  Colors.yellow,
  Colors.amber,
  Colors.pink,
  Colors.indigo,
  Colors.green,
  Colors.blue,
  Colors.orange,
  Colors.purple,
  Colors.lime,
  Colors.teal,
  Colors.grey,
  Colors.teal,
  Colors.cyan,
];
final List<double> sizes = [14, 16, 20, 24, 32];

final List<double> strokes = [0.0, 1.0, 1.5, 2.0];

final List<Color> shadowColors = [
  Colors.transparent,
  Colors.white,
  Colors.black,
  Colors.red,
  Colors.yellow,
  Colors.amber,
  Colors.pink,
  Colors.indigo,
  Colors.green,
  Colors.blue,
  Colors.orange,
  Colors.purple,
  Colors.lime,
  Colors.teal,
  Colors.cyan,
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
  'Kaushan Script',
  'Bree Serif',
  'Oswald',
  'Rokkitt',
  'Pathway Gothic One',
  'Unna',
  'Abril Fatface',
  'Comfortaa',
  'Playfair Display',
  'Oswald',
  'Alegreya',
];

final List<TextAlign> align = [
  TextAlign.left,
  TextAlign.center,
  TextAlign.right,
];

final themeModes = [ThemeMode.system, ThemeMode.light, ThemeMode.dark];

final systemTheme = <String, dynamic>{
  'System Default': themeModes[0],
  'Light Mode': themeModes[1],
  'Dark Mode': themeModes[2],
};
