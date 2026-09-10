// import 'package:dio/dio.dart';

// abstract class Failure {
//   String errorMassage;
//   Failure(this.errorMassage);
// }

// class ServerFailure extends Failure {
//   ServerFailure(super.errorMassage);

//   factory ServerFailure.fromDioError(DioException dioException) {
//     switch (dioException.type) {
//       case DioExceptionType.connectionTimeout:
//         return ServerFailure('Connection Time out with ApiServer');
//       case DioExceptionType.sendTimeout:
//         return ServerFailure('Send Time out with ApiServer');
//       case DioExceptionType.receiveTimeout:
//         return ServerFailure('Receive Time out with ApiServer');
//       case DioExceptionType.badCertificate:
//         return ServerFailure('Bad Certificate with ApiServer');
//       case DioExceptionType.badResponse:
//         return ServerFailure.fromResponse(
//           dioException.response!.statusCode!,
//           dioException.response!.data,
//         );
//       case DioExceptionType.cancel:
//         return ServerFailure('Request to ApiServer was canceld');
//       case DioExceptionType.connectionError:
//         return ServerFailure('No Internet Connection..');
//       case DioExceptionType.unknown:
//         return ServerFailure('UnExpacted Error ,Please Try again!');
//       default:
//         return ServerFailure('Oops there was an error , please try later!');
//     }
//   }

//   factory ServerFailure.fromResponse(int statusCode, dynamic response) {
//     if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
//       // 1. استخراج الرسالة من المفتاح "errors" المكتوب بصيغة الجمع
//       final errorMessage =
//           response?["errors"]?[0]?["description"] ??
//           response?["message"] ??
//           'حدث خطأ غير متوقع، يرجى المحاولة لاحقاً';
//       return ServerFailure(errorMessage);
//     } else if (statusCode == 404) {
//       return ServerFailure('Your request not found , please try later!');
//     } else if (statusCode == 500) {
//       return ServerFailure('Internal sever error , please try later!');
//     } else {
//       return ServerFailure('Oops there was an error , please try later!');
//     }
//   }
// }
import 'package:dio/dio.dart';

abstract class Failure {
  final String errorMassage;
  const Failure(this.errorMassage);
}

class ServerFailure extends Failure {
  ServerFailure(super.errorMassage);

  /// 🎯 المصنع الرئيسي لمعالجة جميع أنواع الأخطاء من أي مكان في التطبيق
  factory ServerFailure.fromError(dynamic error) {
    if (error is DioException) {
      return ServerFailure.fromDioError(error);
    } else if (error is ServerFailure) {
      return error;
    } else if (error is Exception) {
      // التعامل مع الاستثناءات العادية واستخراج النص
      final msg = error.toString().replaceAll('Exception: ', '');
      return ServerFailure(msg.isNotEmpty ? msg : 'حدث خطأ غير متوقع');
    } else if (error is String) {
      return ServerFailure(error);
    } else {
      return ServerFailure('حدث خطأ غير متوقع، يرجى المحاولة لاحقاً');
    }
  }

  /// معالجة استثناءات مكتبة Dio
  factory ServerFailure.fromDioError(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure('انتهت مهلة الاتصال بالسيرفر');
      case DioExceptionType.sendTimeout:
        return ServerFailure('انتهت مهلة إرسال البيانات');
      case DioExceptionType.receiveTimeout:
        return ServerFailure('انتهت مهلة استقبال البيانات');
      case DioExceptionType.badCertificate:
        return ServerFailure('شهادة الأمان غير صالحة');
      case DioExceptionType.badResponse:
        if (dioException.response != null) {
          return ServerFailure.fromResponse(
            dioException.response!.statusCode ?? 500,
            dioException.response!.data,
          );
        }
        return ServerFailure('حدث خطأ في الاستجابة من السيرفر');
      case DioExceptionType.cancel:
        return ServerFailure('تم إلغاء الطلب');
      case DioExceptionType.connectionError:
        return ServerFailure('لا يوجد اتصال بالإنترنت، تحقق من الشبكة');
      case DioExceptionType.unknown:
        if (dioException.message?.contains('SocketException') ?? false) {
          return ServerFailure('لا يوجد اتصال بالإنترنت');
        }
        return ServerFailure('حدث خطأ غير متوقع، يرجى المحاولة لاحقاً');
      default:
        return ServerFailure('حدث خطأ ما، يرجى المحاولة لاحقاً');
    }
  }

  /// استخراج رسائل الخطأ القادمة من السيرفر (HTTP Status Codes)
  factory ServerFailure.fromResponse(int statusCode, dynamic response) {
    String extractErrorMessage(dynamic res) {
      try {
        if (res is Map<String, dynamic>) {
          // 1. فحص مفتاح errors
          if (res['errors'] != null) {
            if (res['errors'] is List && (res['errors'] as List).isNotEmpty) {
              var firstErr = res['errors'][0];
              if (firstErr is Map && firstErr.containsKey('description')) {
                return firstErr['description'];
              } else if (firstErr is String) {
                return firstErr;
              }
            } else if (res['errors'] is String) {
              return res['errors'];
            } else if (res['errors'] is Map) {
              // لحالات Validation Errors التي ترجع كـ Map
              final Map errorsMap = res['errors'];
              if (errorsMap.isNotEmpty) {
                var firstValue = errorsMap.values.first;
                if (firstValue is List && firstValue.isNotEmpty) {
                  return firstValue.first.toString();
                }
                return firstValue.toString();
              }
            }
          }

          // 2. فحص المفاتيح الشائعة لرسائل الخطأ
          if (res['message'] != null && res['message'].toString().isNotEmpty) {
            return res['message'].toString();
          }
          if (res['error'] != null && res['error'].toString().isNotEmpty) {
            return res['error'].toString();
          }
          if (res['title'] != null && res['title'].toString().isNotEmpty) {
            return res['title'].toString();
          }
        } else if (res is String && res.isNotEmpty) {
          return res;
        }
      } catch (_) {
        return 'حدث خطأ أثناء معالجة استجابة السيرفر';
      }
      return 'حدث خطأ غير متوقع، يرجى المحاولة لاحقاً';
    }

    if (statusCode == 400 ||
        statusCode == 401 ||
        statusCode == 403 ||
        statusCode == 422) {
      return ServerFailure(extractErrorMessage(response));
    } else if (statusCode == 404) {
      return ServerFailure('العنصر أو الصفحة المطلوبة غير موجودة');
    } else if (statusCode == 500 || statusCode == 502 || statusCode == 503) {
      return ServerFailure('خطأ داخلي في السيرفر، يرجى المحاولة لاحقاً');
    } else {
      return ServerFailure(extractErrorMessage(response));
    }
  }
}
