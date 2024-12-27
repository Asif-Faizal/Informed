import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_clean/core/error/failures.dart';
import 'package:tdd_clean/features/news/data/news_local_datasource.dart';
import 'package:tdd_clean/features/news/data/news_model.dart';

import '../../../fixtures/fixture_reader.dart';
import 'news_local_datasource_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late NewsLocalDatasourceImpl
      datasource; // Use 'late' for non-nullable variables
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    datasource =
        NewsLocalDatasourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('Get News from Cache', () {
    final tNewsModel =
        NewsModel.fromJson(json.decode(fixture('news_cached.json')));
    test('should return News from shared preferences if present', () async {
      // Arrange
      const tKey = 'CACHED_NEWS'; // Match the key used in the implementation
      final tNews = fixture('news_cached.json');
      when(mockSharedPreferences.getString(tKey)).thenReturn(tNews);

      // Act
      final result = await datasource.getLastNews();

      // Assert
      verify(mockSharedPreferences.getString(tKey));
      expect(result, equals(tNewsModel));
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
}
