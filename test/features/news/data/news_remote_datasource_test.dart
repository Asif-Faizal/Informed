import 'package:Informed/core/error/exceptions.dart';
import 'package:Informed/features/news/data/news_model.dart';
import 'package:Informed/features/news/data/news_remote_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:http/http.dart' as http;

import '../../../fixtures/fixture_reader.dart';
import 'news_remote_datasource_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late NewsRemoteDatasourceImpl datasource;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    datasource = NewsRemoteDatasourceImpl(client: mockClient);
  });

  group('Get Query News', () {
  final tQuery = 'query';
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
  ];

  test('should perform GET request on a URL with query', () async {
    // arrange
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('news_non_null.json'), 200));

    // act
    await datasource.getQueryNews(tQuery);

    // assert
    verify(mockClient.get(
      Uri.parse(
        "https://newsapi.org/v2/everything?q=$tQuery&sortBy=publishedAt&apiKey=d26344a4cc7045a895af69f018609a64",
      ),
      headers: {
        'Content-Type': 'application/json',
      },
    ));
  });

  test('should return a list of News Models when status code is 200', () async {
    // arrange
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('news_non_null.json'), 200));

    // act
    final result = await datasource.getQueryNews(tQuery);

    // assert
    expect(result, equals(tNewsModelList));
  });

  test('should throw ServerException when status code is not 200', () async {
    // arrange
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));

    // act
    final call = datasource.getQueryNews;

    // assert
    expect(
      () => call(tQuery),
      throwsA(isA<ServerException>().having((e) => e.message, 'message', 'Error')),
    );
  });
});


  group('Get Country News', () {
  final tCountry = 'country';
  final tCategory = 'category';
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
  ];

  test('should perform GET request on a URL with query', () async {
    // arrange
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('news_non_null.json'), 200));

    // act
    await datasource.getCountryNews(tCountry,tCategory);

    // assert
    verify(mockClient.get(
      Uri.parse(
        "https://newsapi.org/v2/top-headlines?country=$tCountry&category=$tCategory&apiKey=d26344a4cc7045a895af69f018609a64",
      ),
      headers: {
        'Content-Type': 'application/json',
      },
    ));
  });

  test('should return a list of News Models when status code is 200', () async {
    // arrange
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('news_non_null.json'), 200));

    // act
    final result = await datasource.getCountryNews(tCountry,tCategory);

    // assert
    expect(result, equals(tNewsModelList));
  });

  test('should throw ServerException when status code is not 200', () async {
    // arrange
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));

    // act
    final call = datasource.getCountryNews;

    // assert
    expect(
      () => call(tCountry,tCategory),
      throwsA(isA<ServerException>().having((e) => e.message, 'message', 'Error')),
    );
  });
});
}
