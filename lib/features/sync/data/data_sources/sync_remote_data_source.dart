import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:recipe/core/services/api_service.dart';
import 'package:recipe/features/sync/data/models/sync_request_model.dart';

abstract class SyncRemoteDataSource {
  Future<void> executeSyncRequest(SyncRequestModel request);
}

class SyncRemoteDataSourceImpl implements SyncRemoteDataSource {
  final ApiService apiService;

  SyncRemoteDataSourceImpl({required this.apiService});

  @override
  Future<void> executeSyncRequest(SyncRequestModel request) async {
    Map<String, dynamic> payload = {};
    if (request.payloadJson != null && request.payloadJson!.isNotEmpty) {
      payload = jsonDecode(request.payloadJson!);
    }

    dynamic dataToSend;
    bool isFormData = false;

    if (request.imagePath != null && request.imagePath!.isNotEmpty) {
      isFormData = true;
      FormData formData = FormData.fromMap(payload);
      formData.files.add(
        MapEntry('image', await MultipartFile.fromFile(request.imagePath!)),
      );
      dataToSend = formData;
    } else {
      dataToSend = payload;
    }

    switch (request.method.toUpperCase()) {
      case 'POST':
        await apiService.post(
          endpoint: request.endpoint,
          data: dataToSend,
          isFormData: isFormData,
        );
        break;
      case 'PUT':
        await apiService.put(
          endpoint: request.endpoint,
          data: dataToSend,
          isFormData: isFormData,
        );
        break;
      case 'DELETE':
        await apiService.delete(endpoint: request.endpoint);
        break;
      default:
        throw Exception('Unsupported HTTP method: ${request.method}');
    }
  }
}
