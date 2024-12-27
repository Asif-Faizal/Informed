import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_clean/features/news/data/news_model.dart';
import 'package:tdd_clean/features/news/domain/news_entity.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  // Grouping all NewsModel tests together
  group('NewsModel tests', () {
    // Creating a test instance of NewsModel with nullable response fields
    final tNewsModel1 = NewsModel(
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
    );
    
    // Creating a test instance of NewsModel with non-nullable response fields
    final tNewsModel2 = NewsModel(
      sourceId: '28734685',
      sourceName: 'Reuters',
      author: 'Reuters',
      title:
          'Passenger plane flying from Azerbaijan to Russia crashes in Kazakhstan with many feared dead - Reuters',
      description: 'Passenger plane crashed',
      url:
          'https://www.reuters.com/world/asia-pacific/passenger-plane-crashes-kazakhstan-emergencies-ministry-says-2024-12-25/',
      urlToImage: 'http://example.com',
      publishedAt: DateTime.parse('2024-12-25T08:19:37Z'),
      content:
          'Passenger plane flying from Azerbaijan to Russia crashes in Kazakhstan with many feared dead - Reuters',
    );

    // Test case to check if nullable response is a subclass of NewsEntity
    test('Should be a subclass of NewsEntity for nullable response', () async {
      // assert that tNewsModel1 is a subclass of NewsEntity
      expect(tNewsModel1, isA<NewsEntity>());
    });

    // Test case to check if non-nullable response is a subclass of NewsEntity
    test('Should be a subclass of NewsEntity for non-nullable response', () async {
      // assert that tNewsModel2 is a subclass of NewsEntity
      expect(tNewsModel2, isA<NewsEntity>());
    });

    // Test case to verify the fromJson method for nullable response
    test('fromJson method for nullable response', () async {
      // arrange: reading json from a fixture file
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('news_null.json'));
      // act: converting the json into a NewsModel object
      final result = NewsModel.fromJson(jsonMap);
      // assert: checking if the result matches tNewsModel1
      expect(result, tNewsModel1);
    });

    // Test case to verify the fromJson method for non-nullable response
    test('fromJson method for non nullable response', () async {
      // arrange: reading json from a fixture file
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('news_non_null.json'));
      // act: converting the json into a NewsModel object
      final result = NewsModel.fromJson(jsonMap);
      // assert: checking if the result matches tNewsModel2
      expect(result, tNewsModel2);
    });

    // Test case to verify the toJson method for nullable response
    test('toJson method for nullable response', () async {
      // arrange: converting the NewsModel object to a JSON string with indentation
      final result = JsonEncoder.withIndent('    ').convert(tNewsModel1.toJson());
      // expected JSON string from the fixture file
      final expectedJson = fixture('news_null.json');
      
      // assert: checking if the result matches the expected JSON
      expect(result, expectedJson);
    });

    // Test case to verify the toJson method for non-nullable response
    test('toJson method for non nullable response', () async {
      // arrange: converting the NewsModel object to a JSON string with indentation
      final result = JsonEncoder.withIndent('    ').convert(tNewsModel2.toJson());
      // expected JSON string from the fixture file
      final expectedJson = fixture('news_non_null.json');
      
      // assert: checking if the result matches the expected JSON
      expect(result, expectedJson);
    });
  });
}
