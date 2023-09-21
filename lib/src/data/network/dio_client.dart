import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:miracle/src/utils/constant.dart';
import 'package:path_provider/path_provider.dart';

import 'responses/category_response.dart';
import 'responses/quote_response.dart';
import 'responses/theme_response.dart';

class DioClient {
  final Dio _client = Dio(
    BaseOptions(
        baseUrl: '${kBaseUrl}api/',
        headers: {
          "Accept": "application/json",
        },
        followRedirects: false),
  )..interceptors.add(
      LogInterceptor(
        requestHeader: false,
        responseHeader: false,
        responseBody: true,
      ),
    );

  Dio get _authClient {
    final accessToken = GetStorage().read<String>(kAccessToken);
    return _client
      ..options.headers.addAll(
        {HttpHeaders.authorizationHeader: 'Bearer $accessToken'},
      );
  }

  Future<Map<String, dynamic>?> login(Map<String, dynamic> data) async {
    final result =
        await _client.post<Map<String, dynamic>>('auth/login', data: data);
    return result.data;
  }

  Future<Map<String, dynamic>?> sendOtp(Map<String, dynamic> data) async {
    final result =
        await _client.post<Map<String, dynamic>>('user/sendOtp', data: data);
    return result.data;
  }

  Future<Map<String, dynamic>?> confirmPassword(
      Map<String, dynamic> data) async {
    final result = await _client
        .post<Map<String, dynamic>>('user/updatePassword', data: data);
    return result.data;
  }

  Future<Map<String, dynamic>?> logout() async {
    final result = await _authClient.post<Map<String, dynamic>>('auth/logout');
    return result.data;
  }

  Future<Map<String, dynamic>?> updatePreference(
      Map<String, dynamic> data) async {
    final result = await _authClient.post<Map<String, dynamic>>(
      'user/preferences',
      data: data,
    );
    return result.data;
  }

  Future<Map<String, dynamic>?> signUp(Map<String, dynamic> data) async {
    final result =
        await _client.post<Map<String, dynamic>>('auth/register', data: data);
    return result.data;
  }

  Future<Map<String, dynamic>?> getSubscription() async {
    final result = await _authClient.get<Map<String, dynamic>>('subscription');
    return result.data;
  }

  Future<Map<String, dynamic>?> subscribe(int subscriptionId) async {
    final result = await _authClient
        .get<Map<String, dynamic>>('subscribe/$subscriptionId');
    return result.data;
  }

  Future<Map<String, dynamic>?> applyCoupon(Map<String, dynamic> data) async {
    final result = await _authClient.post<Map<String, dynamic>>('apply_coupon',
        data: data);
    return result.data;
  }

  Future<Map<String, dynamic>?> getVideos() async {
    final result = await _authClient.get<Map<String, dynamic>>('videos');
    return result.data;
  }

  Future<Map<String, dynamic>?> getAudio() async {
    final result = await _authClient.get<Map<String, dynamic>>('audio');
    return result.data;
  }

  Future<Map<String, dynamic>?> getExercises() async {
    final result = await _authClient.get<Map<String, dynamic>>('exercises');
    return result.data;
  }

  Future<Map<String, dynamic>?> getCollections() async {
    final result =
        await _authClient.get<Map<String, dynamic>>('user/collections');
    return result.data;
  }

  Future<Map<String, dynamic>?> getCollectionQuotes(int collectionId) async {
    final result = await _authClient
        .get<Map<String, dynamic>>('user/collections/$collectionId');
    return result.data;
  }

  Future<Map<String, dynamic>?> createCollection(
      Map<String, dynamic> data) async {
    final result = await _authClient
        .post<Map<String, dynamic>>('user/collections', data: data);
    return result.data;
  }

  Future<Map<String, dynamic>?> updateCollection(
    int collectionId,
    Map<String, dynamic> data,
  ) async {
    final result = await _authClient.patch<Map<String, dynamic>>(
      'user/collections/$collectionId',
      data: data,
    );
    return result.data;
  }

  Future<Map<String, dynamic>?> deleteCollection(
    int collectionId,
  ) async {
    final result = await _authClient.delete<Map<String, dynamic>>(
      'user/collections/$collectionId',
    );
    return result.data;
  }

  Future<Map<String, dynamic>?> getFavorite() async {
    final result = await _authClient.get<Map<String, dynamic>>(
      'user/favorites',
    );
    return result.data;
  }

  Future<Map<String, dynamic>?> addFavorite(int quoteId) async {
    final result = await _authClient.post<Map<String, dynamic>>(
      'user/favorites',
      data: {'quote_id': quoteId},
    );
    return result.data;
  }

  Future<Map<String, dynamic>?> deleteFavorite(int quoteId) async {
    final result = await _authClient.delete<Map<String, dynamic>>(
      'user/favorites/$quoteId',
    );
    return result.data;
  }

  Future<Map<String, dynamic>?> addQuoteToCollection(
    int collectionId,
    int quoteId,
  ) async {
    final result = await _authClient.post<Map<String, dynamic>>(
      'user/collections/$collectionId/quote/$quoteId',
    );
    return result.data;
  }

  Future<Map<String, dynamic>?> deleteQuoteFromCollection(
    int collectionId,
    int quoteId,
  ) async {
    final result = await _authClient.delete<Map<String, dynamic>>(
      'user/collections/$collectionId/quote/$quoteId',
    );
    return result.data;
  }

  Future<Map<String, dynamic>?> getOwnQuotes() async {
    final result = await _authClient.get<Map<String, dynamic>>(
      'user/own_quotes',
    );
    return result.data;
  }

  Future<Map<String, dynamic>?> addOwnQuotes(Map<String, dynamic> data) async {
    final result = await _authClient.post<Map<String, dynamic>>(
      'user/own_quotes',
      data: data,
    );
    return result.data;
  }

  Future<Map<String, dynamic>?> updateOwnQuotes(
      Map<String, dynamic> data) async {
    final result = await _authClient.patch<Map<String, dynamic>>(
      'user/own_quotes',
      data: data,
    );
    return result.data;
  }

  Future<Map<String, dynamic>?> deleteOwnQuotes(int quote) async {
    final result = await _authClient.delete<Map<String, dynamic>>(
      'user/own_quotes/$quote',
    );
    return result.data;
  }

  Future<String> downloadTheme(String url, String fileName) async {
    final asd = await getApplicationDocumentsDirectory();

    final directory = Directory('${asd.path}/themes');
    if (!await directory.exists()) {
      await directory.create();
    }
    final themes =
        GetStorage().read<List<dynamic>>(kDownloadedThemes)?.cast<String>() ??
            <String>[];
    if (themes.contains(fileName)) {
      await GetStorage().write(kActiveTheme, '${directory.path}/$fileName');
      return 'Theme Activated';
    }
    themes.add(fileName);
    await _authClient.download(url, '${directory.path}/$fileName');
    await GetStorage().write(kActiveTheme, '${directory.path}/$fileName');
    await GetStorage().write(kDownloadedThemes, themes);
    return 'Theme Activated';
  }

  Future<CategoryResponse> getTags() async {
    final result = await _authClient.get<Map<String, dynamic>>('tags');
    return CategoryResponse.fromJson(result.data!);
  }

  Future<CategoryResponse> getCategories() async {
    final result = await _authClient.get<Map<String, dynamic>>('categories');
    return CategoryResponse.fromJson(result.data!);
  }

  Future<ThemeResponse> getThemes() async {
    final result = await _authClient.get<Map<String, dynamic>>('themes');
    return ThemeResponse.fromJson(result.data!);
  }

  Future<QuoteResponse> getQuotes(int page) async {
    final result = await _authClient
        .get<Map<String, dynamic>>('quotes', queryParameters: {'page': page});
    return QuoteResponse.fromJson(result.data!);
  }

  Future<QuoteResponse> getFreeQuotes() async {
    final result = await _authClient
        .get<Map<String, dynamic>>('free-quotes');
    return QuoteResponse.fromJson(result.data!);
  }

  Future<QuoteResponse> getQuotesByCategory(int categoryId) async {
    final result = await _authClient
        .get<Map<String, dynamic>>('category/$categoryId/quotes');
    return QuoteResponse.fromJson(result.data!);
  }

  Future<QuoteResponse> getNotificationQuote(int howMany) async {
    final result = await _authClient.post<Map<String, dynamic>>(
        'quotes/notifications',
        data: {'how_many': howMany});
    return QuoteResponse.fromJson(result.data!);
  }

  Future<Map<String, dynamic>> getProfile() async {
    final result = await _authClient.get<Map<String, dynamic>>(
      'profile',
    );
    return result.data!;
  }

  Future<Map<String, dynamic>> refundRequest() async {
    final result = await _authClient.get<Map<String, dynamic>>(
      'refund',
    );
    return result.data!;
  }

  Future<Map<String, dynamic>> deleteAccount() async {
    final result = await _authClient.get<Map<String, dynamic>>(
      'deactivate',
    );
    return result.data!;
  }
}
