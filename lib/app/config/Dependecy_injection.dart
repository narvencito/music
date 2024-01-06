// ignore_for_file: lines_longer_than_80_chars, file_names, cascade_invocations

import 'package:dio/dio.dart';
import 'package:music/app/app.dart';
import 'package:music/app/config/flavor_config.dart';

class DependencyInjection {
  void setup() {
    final dio = Dio(
      BaseOptions(
        baseUrl: InitFlavorConfig.urlApp,
        contentType: 'application/json',
        receiveTimeout: const Duration(seconds: 30),
        connectTimeout: const Duration(seconds: 10),
        // validateStatus: (status) => true,
      ),
    );

    getItApp.registerLazySingleton(() => dio);
  }
}
