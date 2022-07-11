import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:number_trivia/injection.config.dart';

final getIt = GetIt.instance;

@injectableInit
void configureInjection(String environment) {
  $initGetIt(getIt, environment: environment);
}

abstract class Env {
  static const String dev = 'dev';
  static const String test = 'test';
}
