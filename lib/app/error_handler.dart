import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'failture.dart';

class ErrorHandler implements Exception {
  late Failture failture;

  ErrorHandler.handle(dynamic error) {
    // Already mapped further down (e.g. a validation message thrown by a
    // datasource): keep its message instead of collapsing it to "unknown".
    if (error is Failture) {
      failture = error;
    } else if (error is AuthException) {
      failture = _handleSupabaseAuthError(error);
    } else if (error is PostgrestException) {
      failture = _handleSupabasePostgrestError(error);
    } else if (error is StorageException) {
      failture = _handleSupabaseStorageError(error);
    } else if (error is SocketException ||
        error is HttpException ||
        // package:http's ClientException (transitive dep, not importable
        // here) is what Supabase throws when the device is offline.
        '$error'.startsWith('ClientException')) {
      failture = DataSource.noInternetConnection.toFailture();
    } else if (error is TimeoutException) {
      failture = DataSource.connectionTimeout.toFailture();
    } else {
      failture = DataSource.unknown.toFailture();
    }

    if (!kReleaseMode) {
      log("<-------> \n ${error.toString()} \n <------->");
      log("<====> ${failture.code} : ${failture.message} <====>");
    }
  }

  Failture _handleSupabaseAuthError(AuthException error) {
    switch (error.statusCode) {
      case '400':
        if (error.message.contains('Invalid login credentials') ||
            error.message.contains('Email not confirmed')) {
          return DataSource.unautorised.toFailture();
        }
        return DataSource.badRequest.toFailture();
      case '422':
        return DataSource.badRequest.toFailture();
      case '429':
        return DataSource.recieveTimeOut.toFailture();
      default:
        return DataSource.unknown.toFailture();
    }
  }

  Failture _handleSupabasePostgrestError(PostgrestException error) {
    if (error.message.contains('JWT')) {
      return DataSource.unautorised.toFailture();
    }

    switch (error.code) {
      case '42501': // insufficient_privilege
        return DataSource.forbidden.toFailture();
      case 'PGRST301': // JWT expired
        return DataSource.unautorised.toFailture();
      case '23505': // unique_violation
        return Failture(409, 'هذا البريد مسجل بالفعل');
      default:
        return DataSource.unknown.toFailture();
    }
  }

  Failture _handleSupabaseStorageError(StorageException error) {
    if (error.message.contains('not allowed')) {
      return DataSource.forbidden.toFailture();
    }
    if (error.statusCode == '413' ||
        error.message.toLowerCase().contains('maximum allowed size')) {
      return Failture(413, 'حجم الملف كبير جداً، اختر ملفاً أصغر');
    }
    return DataSource.unknown.toFailture();
  }
}

// Keep the rest of your DataSource enum and extensions unchanged
enum DataSource {
  success,
  noContent,
  badRequest,
  forbidden,
  unautorised,
  notFound,
  internalServerError,
  recieveTimeOut,
  cacheError,
  noInternetConnection,
  unknown,
  connectionTimeout,
  cancel,
}

extension DataSourceExtention on DataSource {
  Failture toFailture() {
    switch (this) {
      case DataSource.success:
        return Failture(ResponseCode.success, ResponseMessage.success);
      case DataSource.noContent:
        return Failture(ResponseCode.noContent, ResponseMessage.noContent);
      case DataSource.badRequest:
        return Failture(ResponseCode.badRequest, ResponseMessage.badRequest);
      case DataSource.forbidden:
        return Failture(ResponseCode.forbidden, ResponseMessage.forbidden);
      case DataSource.unautorised:
        return Failture(ResponseCode.unautorised, ResponseMessage.unautorised);
      case DataSource.notFound:
        return Failture(ResponseCode.notFound, ResponseMessage.notFound);
      case DataSource.internalServerError:
        return Failture(
          ResponseCode.internalServerError,
          ResponseMessage.internalServerError,
        );
      case DataSource.recieveTimeOut:
        return Failture(
          ResponseCode.recieveTimeOut,
          ResponseMessage.recieveTimeOut,
        );
      case DataSource.cacheError:
        return Failture(ResponseCode.cacheError, ResponseMessage.cacheError);
      case DataSource.noInternetConnection:
        return Failture(
          ResponseCode.noInternetConnection,
          ResponseMessage.noInternetConnection,
        );
      case DataSource.unknown:
        return Failture(ResponseCode.unknown, ResponseMessage.unknown);
      case DataSource.connectionTimeout:
        return Failture(
          ResponseCode.connectionTimeout,
          ResponseMessage.connectionTimeout,
        );
      case DataSource.cancel:
        return Failture(ResponseCode.cancel, ResponseMessage.cancel);
    }
  }
}

// Keep ResponseCode, ResponseMessage, and ApiInternalState unchanged
class ResponseCode {
  static const int success = 200;
  static const int noContent = 201;
  static const int badRequest = 400;
  static const int forbidden = 403;
  static const int unautorised = 401;
  static const int notFound = 404;
  static const int internalServerError = 500;

  static const int noInternetConnection = -1;
  static const int recieveTimeOut = -2;
  static const int cacheError = -3;
  static const int connectionTimeout = -4;
  static const int unknown = -5;
  static const int cancel = -6;
}

/// Shown to the user as-is (toasts / error states), so they are Arabic.
class ResponseMessage {
  static const String success = 'تم بنجاح';
  static const String noContent = 'لا توجد بيانات';
  static const String badRequest = 'طلب غير صالح، تحقق من البيانات';
  static const String forbidden = 'ليست لديك صلاحية لتنفيذ هذا الإجراء';
  static const String unautorised = 'انتهت الجلسة، يرجى تسجيل الدخول مجدداً';
  static const String notFound = 'العنصر غير موجود';
  static const String internalServerError = 'حدث خطأ في الخادم، حاول لاحقاً';

  static const String noInternetConnection =
      'لا يوجد اتصال بالإنترنت، تحقق من الشبكة';
  static const String recieveTimeOut = 'انتهت مهلة الاتصال، حاول مجدداً';
  static const String connectionTimeout = 'انتهت مهلة الاتصال، حاول مجدداً';
  static const String cacheError = 'تعذر قراءة البيانات المحفوظة';
  static const String unknown = 'حدث خطأ غير متوقع، حاول مجدداً';
  static const String cancel = 'تم إلغاء الطلب';
}

class ApiInternalState {
  static const success = true;
  static const failture = false;
}
