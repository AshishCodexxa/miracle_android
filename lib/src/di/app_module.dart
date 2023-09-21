import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:miracle/src/data/model/quote_theme.dart';
import 'package:miracle/src/data/network/dio_client.dart';
import 'package:miracle/src/utils/common.dart';
import 'package:miracle/src/utils/constant.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) {
  return themeModes[GetStorage().read<int>(kActiveThemeMode) ?? 0];
});

final quoteThemeProvider = StateProvider<QuoteTheme>((ref) {
  final map = GetStorage().read<Map<String, dynamic>>(kActiveTextTheme);
  return map != null ? QuoteTheme.fromJson(map) : QuoteTheme();
});

final dioHttpProvider = Provider((ref) {
  return DioClient();
});
