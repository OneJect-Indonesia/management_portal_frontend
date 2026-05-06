import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../constants/constants.dart';
import '../utils/logger.dart';

class ApiConfig {
  static Dio? _dio;
  static bool _isInitialized = false;

  static Future<Dio> get dio async {
    if (_dio == null) {
      _dio = Dio();
      await init();
    }
    return _dio!;
  }

  static Future<void> init() async {
    if (_isInitialized) return;
    
    final d = _dio ?? Dio();
    _dio = d;

    d.options.baseUrl = AppConstants.apiBaseUrl;
    d.options.connectTimeout = const Duration(seconds: AppConstants.apiTimeoutSeconds);
    d.options.receiveTimeout = const Duration(seconds: AppConstants.apiTimeoutSeconds);
    d.options.headers['Accept'] = 'application/json';
    d.options.headers['Content-Type'] = 'application/json';

    if (kIsWeb) {
      d.options.extra['withCredentials'] = true;
    } else {
      final appDocDir = await getApplicationDocumentsDirectory();
      final cookieJar = PersistCookieJar(
        ignoreExpires: true,
        storage: FileStorage("${appDocDir.path}/.cookies/"),
      );
      d.interceptors.add(CookieManager(cookieJar));
    }

    d.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        Log.d('[Dio Request] ${options.method} ${options.uri}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        Log.d('[Dio Response] ${response.statusCode} ${response.realUri}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
          Log.w('[Dio Error] User unauthorized (${e.response?.statusCode}). Redirecting to login...');
        } else {
          Log.e('[Dio Error] ${e.message}');
        }
        return handler.next(e);
      },
    ));

    _isInitialized = true;
  }
}
