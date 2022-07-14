import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

const cachedNumberTrivia = 'CACHED_NUMBER_TRIVIA';

@Injectable(as: NumberTriviaLocalDataSource)
class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString(cachedNumberTrivia);
    if (jsonString != null) {
      final numberTriviaModel = _decodeModelFromJson(jsonString);
      return Future.value(numberTriviaModel);
    }

    throw CacheException();
  }

  @override
  Future<bool> cacheNumberTrivia(NumberTriviaModel triviaToCache) async {
    final jsonData = triviaToCache.toJson();
    final value = json.encode(jsonData);
    return sharedPreferences.setString(cachedNumberTrivia, value);
  }

  NumberTriviaModel _decodeModelFromJson(String? jsonString) {
    final text = jsonString ?? '';
    final decodedValue = json.decode(text);
    return NumberTriviaModel.fromJson(decodedValue);
  }
}
