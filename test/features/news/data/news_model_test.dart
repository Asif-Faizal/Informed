import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_clean/features/news/data/news_model.dart';
import 'package:tdd_clean/features/news/domain/news_entity.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  group('NewsModel tests', () {
    // Creating a list of NewsModel instances for testing
    final tNewsModelList = [
      NewsModel(
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
      ),
      // Add more instances here for more test cases if needed
    ];

    // Test case to check if list of NewsModel objects is a subclass of NewsEntity
    test('Should be a subclass of NewsEntity for a list response', () async {
      // assert that tNewsModelList is a list of NewsEntity objects
      expect(tNewsModelList, everyElement(isA<NewsEntity>()));
    });

    // Test case to verify the fromJson method for a list of models
    test('fromJson method for list response', () async {
      // arrange: reading a JSON object with a list from a fixture file
      final Map<String, dynamic> jsonObject =
          json.decode(fixture('news_non_null.json'));

      // Assuming the list is under a key like 'articles' or 'news'
      final List<dynamic> jsonList =
          jsonObject['articles']; // Adjust this key as needed

      // act: converting the JSON list into a list of NewsModel objects
      final result = NewsModel.fromJsonList(jsonList);

      // assert: checking if the result matches tNewsModelList
      expect(result, equals(tNewsModelList));
    });

    // Test case to verify the toJson method for a list of models
    test('fromJson method for list response', () async {
      // arrange: reading a JSON object with a list from a fixture file
      final Map<String, dynamic> jsonObject =
          json.decode(fixture('news_non_null.json'));

      // Extract the 'articles' list from the root object
      final List<dynamic> jsonList = jsonObject['articles'];

      // act: converting the JSON list into a list of NewsModel objects
      final result = NewsModel.fromJsonList(jsonList);

      // assert: checking if the result matches tNewsModelList
      expect(result, equals(tNewsModelList));
    });
  });
}
