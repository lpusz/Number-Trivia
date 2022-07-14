// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:data_connection_checker/data_connection_checker.dart' as _i3;
import 'package:dio/dio.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i8;

import 'core/network/network_info.dart' as _i6;
import 'core/util/input_converter.dart' as _i5;
import 'features/number_trivia/data/data_sources/number_trivia_data_source_impl.dart'
    as _i11;
import 'features/number_trivia/data/data_sources/number_trivia_local_data_source.dart'
    as _i9;
import 'features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart'
    as _i10;
import 'features/number_trivia/data/data_sources/remote_client.dart' as _i7;
import 'features/number_trivia/data/repositories/number_trivia_repository_impl.dart'
    as _i13;
import 'features/number_trivia/domain/repositories/number_trivia_repository.dart'
    as _i12;
import 'features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart'
    as _i14;
import 'features/number_trivia/domain/use_cases/get_random_number_trivia.dart'
    as _i15;
import 'features/number_trivia/presentation/bloc/number_trivia_bloc.dart'
    as _i16;
import 'injection.dart' as _i17; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  gh.lazySingleton<_i3.DataConnectionChecker>(() => registerModule.checker);
  gh.lazySingleton<_i4.Dio>(() => registerModule.dio);
  gh.lazySingleton<_i5.InputConverter>(() => _i5.InputConverter());
  gh.lazySingleton<_i6.NetworkInfo>(
      () => _i6.NetworkInfoImpl(get<_i3.DataConnectionChecker>()));
  gh.lazySingleton<_i7.RemoteClient>(() => _i7.RemoteClient(get<_i4.Dio>()));
  await gh.lazySingletonAsync<_i8.SharedPreferences>(() => registerModule.prefs,
      preResolve: true);
  gh.factory<_i9.NumberTriviaLocalDataSource>(() =>
      _i9.NumberTriviaLocalDataSourceImpl(
          sharedPreferences: get<_i8.SharedPreferences>()));
  gh.factory<_i10.NumberTriviaRemoteDataSource>(() =>
      _i11.NumberTriviaRemoteDataSourceImpl(
          remoteClient: get<_i7.RemoteClient>()));
  gh.factory<_i12.NumberTriviaRepository>(() => _i13.NumberTriviaRepositoryImpl(
      remoteDataSource: get<_i10.NumberTriviaRemoteDataSource>(),
      localDataSource: get<_i9.NumberTriviaLocalDataSource>(),
      networkInfo: get<_i6.NetworkInfo>()));
  gh.lazySingleton<_i14.GetConcreteNumberTrivia>(
      () => _i14.GetConcreteNumberTrivia(get<_i12.NumberTriviaRepository>()));
  gh.lazySingleton<_i15.GetRandomNumberTrivia>(
      () => _i15.GetRandomNumberTrivia(get<_i12.NumberTriviaRepository>()));
  gh.factory<_i16.NumberTriviaBloc>(() => _i16.NumberTriviaBloc(
      getRandom: get<_i15.GetRandomNumberTrivia>(),
      getConcrete: get<_i14.GetConcreteNumberTrivia>(),
      converter: get<_i5.InputConverter>()));
  return get;
}

class _$RegisterModule extends _i17.RegisterModule {}
