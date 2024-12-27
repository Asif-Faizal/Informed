import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_clean/features/news/data/news_model.dart';
import 'package:tdd_clean/features/news/domain/news_entity.dart';

void main() {
  group('NewsModel tests', () {
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
    final tNewsModel2 = NewsModel(
      sourceId: '16723541',
      sourceName: 'Reuters',
      author: 'Reuters',
      title:
          'Passenger plane flying from Azerbaijan to Russia crashes in Kazakhstan with many feared dead - Reuters',
      description: 'Passenger plane crashed',
      url:
          'https://www.reuters.com/world/asia-pacific/passenger-plane-crashes-kazakhstan-emergencies-ministry-says-2024-12-25/',
      urlToImage: 'http://example.com',
      publishedAt: DateTime.parse('2024-12-25T08:19:37Z'),
      content: 'Passenger plane flying from Azerbaijan to Russia crashes in Kazakhstan with many feared dead - Reuters',
    );

    test('Should be a subclass of NewsEntity for nullable response', () async {
      // arrange
      expect(tNewsModel1, isA<NewsEntity>());
    });

    test('Should be a subclass of NewsEntity for non-nullable response', () async {
      // arrange
      expect(tNewsModel2, isA<NewsEntity>());
    });
  });
}
