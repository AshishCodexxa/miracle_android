import 'package:flutter/material.dart';

import 'package:miracle/src/utils/common.dart';

class QuoteTheme {
  Color textColor;
  double fontSize;
  String fontFamily;
  TextAlign alignment;
  Color shadow;
  double strokeWidth;

  QuoteTheme({
    this.textColor = Colors.white,
    this.fontFamily = 'Merriweather',
    this.alignment = TextAlign.center,
    this.fontSize = 24,
    this.shadow = Colors.black,
    this.strokeWidth = 0,
  });

  factory QuoteTheme.fromJson(Map<String, dynamic> json) {
    return QuoteTheme(
      textColor: Color(json['textColor']),
      fontSize: json['fontSize'],
      fontFamily: json['fontFamily'],
      alignment: align[json['alignment']],
      shadow: Color(json['shadow']),
      strokeWidth: json['strokeWidth'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['textColor'] = textColor.value;
    data['fontSize'] = fontSize;
    data['fontFamily'] = fontFamily;
    data['alignment'] = align.indexOf(alignment);
    data['shadow'] = shadow.value;
    data['strokeWidth'] = strokeWidth;
    return data;
  }

  QuoteTheme copyWith({
    Color? textColor,
    double? fontSize,
    String? fontFamily,
    TextAlign? alignment,
    Color? shadow,
    double? strokeWidth,
  }) {
    return QuoteTheme(
      textColor: textColor ?? this.textColor,
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
      alignment: alignment ?? this.alignment,
      shadow: shadow ?? this.shadow,
      strokeWidth: strokeWidth ?? this.strokeWidth,
    );
  }

  @override
  String toString() {
    return 'QuoteTheme(textColor: $textColor, fontSize: $fontSize, fontFamily: $fontFamily, alignment: $alignment, shadow: $shadow, strokeWidth: $strokeWidth)';
  }
}
