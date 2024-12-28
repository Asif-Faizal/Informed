import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_clean/core/error/failures.dart';
import 'package:tdd_clean/features/news/data/news_local_datasource.dart';
import 'package:tdd_clean/features/news/data/news_model.dart';
import '../../../fixtures/fixture_reader.dart';  // Ensure this is correctly implemented
import 'news_local_datasource_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late NewsLocalDatasourceImpl datasource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    datasource = NewsLocalDatasourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('Get News from Cache', () {
    final tNewsModelList = (json.decode(fixture('news_cached.json')) as List)
        .map((jsonItem) => NewsModel.fromJson(jsonItem as Map<String, dynamic>))
        .toList();

    test('should return News from shared preferences if present', () async {
      // Arrange
      const tKey = 'CACHED_NEWS'; 
      final tNewsJson = fixture('news_cached.json'); // Assuming this fixture is a valid JSON string
      when(mockSharedPreferences.getString(tKey)).thenReturn(tNewsJson);

      // Act
      final result = await datasource.getLastNews();

      // Assert
      verify(mockSharedPreferences.getString(tKey));  // Verify the correct method is called
      expect(result, equals(tNewsModelList));  // Compare with the list of models parsed from the fixture
    });

    test('should throw CacheFailure when there is no cache value', () async {
      // Arrange
      const tKey = 'CACHED_NEWS';
      when(mockSharedPreferences.getString(tKey)).thenReturn(null);

      // Act & Assert
      expect(
        () => datasource.getLastNews(),
        throwsA(isA<CacheFailure>()),
      );
    });
  });

  group('Cache the News', () {
    setUp(() {
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);
    });

    final tNewsModelList = [
      NewsModel(
        sourceId: null,
        sourceName: 'Reuters',
        author: 'Reuters',
        title:
            'Passenger plane flying from Azerbaijan to Russia crashes in Kazakhstan with many feared dead - Reuters',
        description: null,
        url:
            'https://www.reuters.com/world/asia-pacific/passenger-plane-crashes-kazakhstan-emergencies-ministry-says-2024-12-25/',
        urlToImage: null,
        publishedAt: DateTime.parse('2024-12-25T08:19:37Z'),
        content: null,
      ),
    ];

    test('should call shared preferences to Cache the data', () async {
      // Act
      await datasource.cacheNews(tNewsModelList); // Cache the news

      // Arrange
      final jsonString =
          json.encode(tNewsModelList.map((model) => model.toJson()).toList()); // Serialize list of models to JSON

      // Assert
      verify(mockSharedPreferences.setString('CACHED_NEWS', jsonString)); // Verify that setString was called with the expected arguments
    });
  });
}
