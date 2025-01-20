import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioSettings {
  DioSettings() {
    unawaited(setup());
  }

  Dio dio = Dio(
    BaseOptions(
      contentType: "application/json",
      headers: {
        "Accept": "application/json",
      },
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  Future<void> setup() async {
    final interceptors = dio.interceptors;
    interceptors.clear();

    final LogInterceptor logInterceptor = LogInterceptor(
      requestBody: true,
      responseBody: true,
    );

    final QueuedInterceptorsWrapper headerInterseptors =
        QueuedInterceptorsWrapper(
      onRequest: (options, handler) => handler.next(options),
      onError: (error, handler) => handler.next(error),
      onResponse: (response, handler) => handler.next(response),
    );

    interceptors.addAll(
      [
        if (kDebugMode) logInterceptor,
        headerInterseptors,
      ],
    );
  }
}