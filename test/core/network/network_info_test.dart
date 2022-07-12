import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:number_trivia/core/network/network_info.dart';

import 'network_info_test.mocks.dart';

class TestDataConnectionChecker extends Mock implements DataConnectionChecker {}

@GenerateMocks([TestDataConnectionChecker])
void main() {
  late NetworkInfoImpl networkInfoImpl;
  late MockTestDataConnectionChecker mockTestDataConnectionChecker;

  setUp(() {
    mockTestDataConnectionChecker = MockTestDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockTestDataConnectionChecker);
  });

  group('isConnected', () {
    test(
      'should forward the call to DataConnectionChecker.hasConnection',
      () async {
        // Arrange
        final tHasConnectionFuture = Future.value(true);
        when(mockTestDataConnectionChecker.hasConnection).thenAnswer(
          (_) => tHasConnectionFuture,
        );

        // Act
        final result = networkInfoImpl.isConnected;

        // Assert
        verify(mockTestDataConnectionChecker.hasConnection);
        expect(result, tHasConnectionFuture);
      },
    );
  });
}
