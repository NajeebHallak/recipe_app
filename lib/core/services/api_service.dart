import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;
  static const String baseUrl = 'https://recipe-backend-app.onrender.com/api';

  ApiService(this._dio) {
    _dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json'},
    );
  }

  Future<dynamic> get({required String endpoint}) async {
    final response = await _dio.get(endpoint);
    return response.data;
  }

  Future<dynamic> post({
    required String endpoint,
    dynamic data,
    bool isFormData = false,
  }) async {
    final response = await _dio.post(
      endpoint,
      data: data,
      options: Options(
        contentType: isFormData ? 'multipart/form-data' : 'application/json',
      ),
    );
    return response.data;
  }

  Future<dynamic> put({
    required String endpoint,
    dynamic data,
    bool isFormData = false,
  }) async {
    final response = await _dio.put(
      endpoint,
      data: data,
      options: Options(
        contentType: isFormData ? 'multipart/form-data' : 'application/json',
      ),
    );
    return response.data;
  }

  Future<dynamic> delete({required String endpoint}) async {
    final response = await _dio.delete(endpoint);
    return response.data;
  }
}
