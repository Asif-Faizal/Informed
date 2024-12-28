import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_clean/core/error/failures.dart';
import 'package:tdd_clean/features/news/bloc/news_bloc.dart';
import 'package:tdd_clean/features/news/data/news_model.dart';
import 'package:tdd_clean/features/news/domain/get_query_news.dart';
import 'package:tdd_clean/features/news/domain/get_country_news.dart';

import 'news_bloc_test.mocks.dart';

@GenerateMocks([GetQueryNews])
@GenerateMocks([GetCountryNews])
void main() {
  late NewsBloc bloc;
  late MockGetQueryNews mockQueryNews;
  late MockGetCountryNews mockCountryNews;

  setUp(() {
    mockCountryNews = MockGetCountryNews();
    mockQueryNews = MockGetQueryNews();
    bloc = NewsBloc(getQueryNews:  mockQueryNews,getCountryNews:  mockCountryNews);
  });

  test('Initial State should be empty', () async {
    expect(bloc.state, equals(NewsInitial()));
  });

  group('GetQueryNewsEvent', () {
    final tQuery = 'query';
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
    test('should emit [QueryNewsLoading, QueryNewsLoaded] when data is gotten successfully', () async {
      // Arrange
      when(mockQueryNews(any)).thenAnswer(
        (_) async => Right(tNewsModelList),
      );

      // Act
      bloc.add(GetQueryNewsEvent(query: tQuery));

      // Assert
      await expectLater(
        bloc.stream,
        emitsInOrder([
          QueryNewsLoading(),
          QueryNewsLoaded(news: tNewsModelList),
        ]),
      );
    });

    // Error test case
    test('should emit [QueryNewsLoading, QueryNewsError] when getting data fails', () async {
      // Arrange
      when(mockQueryNews(any)).thenAnswer(
        (_) async => Left(ServerFailure('Error')),
      );

      // Act
      bloc.add(GetQueryNewsEvent(query: tQuery));

      // Assert
      await expectLater(
        bloc.stream,
        emitsInOrder([
          QueryNewsLoading(),
          QueryNewsError(errorMessage: 'Error'),
        ]),
      );
    });
  });

  group('GetCountryWiseNewsEvent', () {
    final tCountry = 'country';
    final tCategory = 'category';
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
    test('should emit [QueryNewsLoading, QueryNewsLoaded] when data is gotten successfully', () async {
      // Arrange
      when(mockCountryNews(any)).thenAnswer(
        (_) async => Right(tNewsModelList),
      );

      // Act
      bloc.add(GetCountryWiseNewsEvent(country: tCountry,category: tCategory));

      // Assert
      await expectLater(
        bloc.stream,
        emitsInOrder([
          CountryNewsLoading(),
          CountryNewsLoaded(news: tNewsModelList),
        ]),
      );
    });

    // Error test case
    test('should emit [QueryNewsLoading, QueryNewsError] when getting data fails', () async {
      // Arrange
      when(mockCountryNews(any)).thenAnswer(
        (_) async => Left(ServerFailure('Error')),
      );

      // Act
      bloc.add(GetCountryWiseNewsEvent(country: tCountry,category: tCategory));

      // Assert
      await expectLater(
        bloc.stream,
        emitsInOrder([
          CountryNewsLoading(),
          CountryNewsError(errorMessage: 'Error'),
        ]),
      );
    });
  });
}
