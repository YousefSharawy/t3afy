import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';

Right<Failture, T> success<T>(T data) => Right(data);
Left<Failture, T> failure<T>([String message = 'error']) =>
    Left(Failture(0, message));
