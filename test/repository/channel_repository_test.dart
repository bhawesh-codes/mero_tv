// test/repository/channel_repository_test.dart
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_tv/core/failures/failures.dart';
import 'package:mero_tv/models/logo_model.dart';
import 'package:mero_tv/models/stream_model.dart';
import 'package:mero_tv/repository/channel_repository.dart';
import 'package:mero_tv/services/api_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'channel_repository_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  late MockApiService mockApiService;
  late ChannelRepository repository;

  setUp(() {
    mockApiService = MockApiService();
    repository = ChannelRepository(mockApiService);
  });

  group('ChannelRepository - getStreams', () {
    final testStreams = [
      StreamModel(
          channel: 'channel1', title: 'Stream 1', url: 'https://stream1.com'),
      StreamModel(
          channel: 'channel2', title: 'Stream 2', url: 'https://stream2.com'),
    ];

    test('should return Right with streams when API call succeeds', () async {
      // Arrange
      when(mockApiService.getStreams()).thenAnswer((_) async => testStreams);

      // Act
      final result = await repository.getStreams();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (streams) {
          expect(streams, equals(testStreams));
          expect(streams.length, 2);
          expect(streams[0].channel, 'channel1');
          expect(streams[0].title, 'Stream 1');
        },
      );
      verify(mockApiService.getStreams()).called(1);
    });

    test('should return Left with NoDataFailure when API returns empty list',
        () async {
      // Arrange
      when(mockApiService.getStreams()).thenAnswer((_) async => []);

      // Act
      final result = await repository.getStreams();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<NoDataFailure>());
          expect(failure.message, 'No streams found.');
        },
        (streams) => fail('Expected Left but got Right'),
      );
      verify(mockApiService.getStreams()).called(1);
    });

    test('should return Left with ServerFailure when timeout occurs', () async {
      // Arrange
      when(mockApiService.getStreams()).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: 'streams.json'),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      // Act
      final result = await repository.getStreams();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
        },
        (streams) => fail('Expected Left but got Right'),
      );
      verify(mockApiService.getStreams()).called(1);
    });

    test('should return Left with ServerFailure when connection error occurs',
        () async {
      // Arrange
      when(mockApiService.getStreams()).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: 'streams.json'),
          type: DioExceptionType.connectionError,
        ),
      );

      // Act
      final result = await repository.getStreams();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
        },
        (streams) => fail('Expected Left but got Right'),
      );
    });

    test('should return Left with ServerFailure when API returns 500 error',
        () async {
      // Arrange
      when(mockApiService.getStreams()).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: 'streams.json'),
          response: Response(
            statusCode: 500,
            statusMessage: 'Internal Server Error',
            requestOptions: RequestOptions(path: 'streams.json'),
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      // Act
      final result = await repository.getStreams();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
        },
        (streams) => fail('Expected Left but got Right'),
      );
    });

    test('should return Left with ServerFailure when API returns 404 error',
        () async {
      // Arrange
      when(mockApiService.getStreams()).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: 'streams.json'),
          response: Response(
            statusCode: 404,
            statusMessage: 'Not Found',
            requestOptions: RequestOptions(path: 'streams.json'),
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      // Act
      final result = await repository.getStreams();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
        },
        (streams) => fail('Expected Left but got Right'),
      );
    });

    test('should return Left with ServerFailure for unexpected errors',
        () async {
      // Arrange
      when(mockApiService.getStreams())
          .thenThrow(Exception('Unexpected error'));

      // Act
      final result = await repository.getStreams();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
        },
        (streams) => fail('Expected Left but got Right'),
      );
    });
  });

  group('ChannelRepository - getLogos', () {
    final testLogos = [
      LogoModel(channel: 'channel1', url: 'https://logo1.png'),
      LogoModel(channel: 'channel2', url: 'https://logo2.png'),
    ];

    test('should return Right with logos when API call succeeds', () async {
      // Arrange
      when(mockApiService.getLogos()).thenAnswer((_) async => testLogos);

      // Act
      final result = await repository.getLogos();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (logos) {
          expect(logos, equals(testLogos));
          expect(logos.length, 2);
          expect(logos[0].channel, 'channel1');
          expect(logos[0].url, 'https://logo1.png');
        },
      );
      verify(mockApiService.getLogos()).called(1);
    });

    test('should return Right with empty list when API returns empty list',
        () async {
      // Arrange
      when(mockApiService.getLogos()).thenAnswer((_) async => []);

      // Act
      final result = await repository.getLogos();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (logos) {
          expect(logos, isEmpty);
        },
      );
      verify(mockApiService.getLogos()).called(1);
    });

    test('should return Left with ServerFailure when timeout occurs', () async {
      // Arrange
      when(mockApiService.getLogos()).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: 'logos.json'),
          type: DioExceptionType.receiveTimeout,
        ),
      );

      // Act
      final result = await repository.getLogos();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
        },
        (logos) => fail('Expected Left but got Right'),
      );
    });

    test('should return Left with ServerFailure when connection error occurs',
        () async {
      // Arrange
      when(mockApiService.getLogos()).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: 'logos.json'),
          type: DioExceptionType.connectionError,
        ),
      );

      // Act
      final result = await repository.getLogos();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
        },
        (logos) => fail('Expected Left but got Right'),
      );
    });

    test('should return Left with ServerFailure when API returns error',
        () async {
      // Arrange
      when(mockApiService.getLogos()).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: 'logos.json'),
          response: Response(
            statusCode: 503,
            statusMessage: 'Service Unavailable',
            requestOptions: RequestOptions(path: 'logos.json'),
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      // Act
      final result = await repository.getLogos();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
        },
        (logos) => fail('Expected Left but got Right'),
      );
    });

    test('should return Left with ServerFailure for unexpected errors',
        () async {
      // Arrange
      when(mockApiService.getLogos())
          .thenThrow(const FormatException('Invalid JSON format'));

      // Act
      final result = await repository.getLogos();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
        },
        (logos) => fail('Expected Left but got Right'),
      );
    });

    test('should handle large logo list efficiently', () async {
      // Arrange
      final largeLogoList = List.generate(
          100,
          (index) => LogoModel(
                channel: 'channel$index',
                url: 'https://logo$index.png',
              ));

      when(mockApiService.getLogos()).thenAnswer((_) async => largeLogoList);

      // Act
      final result = await repository.getLogos();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (logos) {
          expect(logos.length, 100);
          expect(logos[0].channel, 'channel0');
          expect(logos[99].channel, 'channel99');
        },
      );
    });
  });
}
