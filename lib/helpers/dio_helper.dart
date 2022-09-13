
import 'package:dio/dio.dart';

class DioHelper {
  static Dio? dio; //write static to use it in init which it's a static method

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://student.valuxapps.com/api/',
        receiveDataWhenStatusError: true,
        receiveTimeout: 30 * 1000,
        connectTimeout: 20 * 1000,
      ),
    );
  }

  static Future<Response> get(
      {required String url, required Map<String, dynamic> query}) async {
    return await dio!.get(url,queryParameters: query);


    // get(url, queryParameters: query);
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    dio!.options.headers = {
      'lang': lang,
      'Authorization': token ?? '',
      'Content-Type': 'application/json',
    };
    return await dio!.get(
      url,
      queryParameters: query,
    );
  }

  static Future<Response> postData(
      {required String url,
        Map<String, dynamic>? query,
        required Map<String, dynamic> data,
        String lang = 'en',
        String? token}) async {
    dio!.options.headers = {'lang': lang, 'Authorization': token};

    return dio!.post(url, queryParameters: query, data: data);
  }

  static Future<Response> putData(
      {required String url,
        Map<String, dynamic>? query,
        required Map<String, dynamic> data,
        String lang = 'en',
        String? token}) async {
    dio!.options.headers = {'lang': lang, 'Authorization': token};

    return dio!.put(url, queryParameters: query, data: data);
  }
}