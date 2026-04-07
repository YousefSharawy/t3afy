import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'failture.dart';

class ErrorHandler implements Exception {
  late Failture failture;

  ErrorHandler.handle(dynamic error) {
    if (error is AuthException) {
      failture = _handleSupabaseAuthError(error);
    } else if (error is PostgrestException) {
      failture = _handleSupabasePostgrestError(error);
    } else if (error is StorageException) {
      failture = _handleSupabaseStorageError(error);
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

class ResponseMessage {
  static const String success = 'success';
  static const String noContent = 'noContent';
  static const String badRequest = 'badRequest';
  static const String forbidden = 'forbidden';
  static const String unautorised = 'unautorised';
  static const String notFound = 'notFound';
  static const String internalServerError = 'internalServerError';

  static const String noInternetConnection = 'noInternetConnection';
  static const String recieveTimeOut = 'recieveTimeOut';
  static const String connectionTimeout = 'connectionTimeout';
  static const String cacheError = 'cacheError';
  static const String unknown = 'unknown';
  static const String cancel = 'cancel';
}

class ApiInternalState {
  static const success = true;
  static const failture = false;
}
