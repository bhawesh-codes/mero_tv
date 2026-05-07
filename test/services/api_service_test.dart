// test/services/api_service_test.dart
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_tv/models/channel_model.dart';
import 'package:mero_tv/models/logo_model.dart';
import 'package:mero_tv/models/stream_model.dart';
import 'package:mero_tv/services/api_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'api_service_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late MockDio mockDio;
  late ApiService apiService;

  setUp(() {
    mockDio = MockDio();
    apiService = ApiService(mockDio);

    // Mock the options getter to avoid MissingStubError
    when(mockDio.options).thenReturn(BaseOptions());
  });

  group('ApiService - getStreams', () {
    final testStreams = [
      {
        'channel': 'channel1',
        'title': 'Stream 1',
        'url': 'https://stream1.com',
        'quality': 'HD',
        'label': 'English'
      },
      {
        'channel': 'channel2',
        'title': 'Stream 2',
        'url': 'https://stream2.com',
        'quality': 'SD',
        'label': 'Hindi'
      },
    ];

    test('should return list of streams on successful API call', () async {
      // Arrange
      final response = Response(
        data: testStreams,
        statusCode: 200,
        requestOptions: RequestOptions(path: 'streams.json'),
      );

      when(mockDio.fetch(any)).thenAnswer((_) async => response);

      // Act
      final result = await apiService.getStreams();

      // Assert
      expect(result, isA<List<StreamModel>>());
      expect(result.length, 2);
      expect(result[0].channel, 'channel1');
      expect(result[0].title, 'Stream 1');
      expect(result[1].channel, 'channel2');
      expect(result[1].title, 'Stream 2');
      verify(mockDio.fetch(any)).called(1);
    });

    test('should return empty list when API returns empty array', () async {
      // Arrange
      final response = Response(
        data: [],
        statusCode: 200,
        requestOptions: RequestOptions(path: 'streams.json'),
      );

      when(mockDio.fetch(any)).thenAnswer((_) async => response);

      // Act
      final result = await apiService.getStreams();

      // Assert
      expect(result, isEmpty);
      verify(mockDio.fetch(any)).called(1);
    });

    test('should throw DioException on network error', () async {
      // Arrange
      when(mockDio.fetch(any)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: 'streams.json'),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      // Act & Assert
      expect(
        () async => await apiService.getStreams(),
        throwsA(isA<DioException>()),
      );
    });

    test('should throw DioException on server error', () async {
      // Arrange
      when(mockDio.fetch(any)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: 'streams.json'),
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(path: 'streams.json'),
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      // Act & Assert
      expect(
        () async => await apiService.getStreams(),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('ApiService - getLogos', () {
    final testLogos = [
      {
        'channel': 'channel1',
        'url': 'https://logo1.png',
        'width': 100,
        'height': 100,
        'format': 'PNG'
      },
      {
        'channel': 'channel2',
        'url': 'https://logo2.png',
        'width': 200,
        'height': 200,
        'format': 'JPEG'
      },
    ];

    test('should return list of logos on successful API call', () async {
      // Arrange
      final response = Response(
        data: testLogos,
        statusCode: 200,
        requestOptions: RequestOptions(path: 'logos.json'),
      );

      when(mockDio.fetch(any)).thenAnswer((_) async => response);

      // Act
      final result = await apiService.getLogos();

      // Assert
      expect(result, isA<List<LogoModel>>());
      expect(result.length, 2);
      expect(result[0].channel, 'channel1');
      expect(result[0].url, 'https://logo1.png');
      expect(result[1].channel, 'channel2');
      expect(result[1].url, 'https://logo2.png');
      verify(mockDio.fetch(any)).called(1);
    });

    test('should return empty list when API returns empty array', () async {
      // Arrange
      final response = Response(
        data: [],
        statusCode: 200,
        requestOptions: RequestOptions(path: 'logos.json'),
      );

      when(mockDio.fetch(any)).thenAnswer((_) async => response);

      // Act
      final result = await apiService.getLogos();

      // Assert
      expect(result, isEmpty);
      verify(mockDio.fetch(any)).called(1);
    });

    test('should handle null values in logo response', () async {
      // Arrange
      final logoWithNulls = [
        {
          'channel': null,
          'url': null,
        }
      ];

      final response = Response(
        data: logoWithNulls,
        statusCode: 200,
        requestOptions: RequestOptions(path: 'logos.json'),
      );

      when(mockDio.fetch(any)).thenAnswer((_) async => response);

      // Act
      final result = await apiService.getLogos();

      // Assert
      expect(result, isA<List<LogoModel>>());
      expect(result.length, 1);
      expect(result[0].channel, null);
      expect(result[0].url, null);
    });

    test('should throw DioException on connection error', () async {
      // Arrange
      when(mockDio.fetch(any)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: 'logos.json'),
          type: DioExceptionType.connectionError,
        ),
      );

      // Act & Assert
      expect(
        () async => await apiService.getLogos(),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('ApiService - getChannels', () {
    final testChannels = [
      {'id': '1', 'name': 'Channel 1'},
      {'id': '2', 'name': 'Channel 2'},
    ];

    test('should return list of channels on successful API call', () async {
      // Arrange
      final response = Response(
        data: testChannels,
        statusCode: 200,
        requestOptions: RequestOptions(path: 'channels.json'),
      );

      when(mockDio.fetch(any)).thenAnswer((_) async => response);

      // Act
      final result = await apiService.getChannels();

      // Assert
      expect(result, isA<List<ChannelModel>>());
      expect(result.length, 2);
      verify(mockDio.fetch(any)).called(1);
    });
  });
}
