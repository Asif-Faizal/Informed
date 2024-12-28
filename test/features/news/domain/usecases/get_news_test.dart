import 'package:mockito/annotations.dart';
import 'package:tdd_clean/features/news/domain/get_query_news.dart';
import 'package:tdd_clean/features/news/domain/get_country_news.dart';
import 'package:tdd_clean/features/news/domain/news_entity.dart';
import 'package:tdd_clean/features/news/domain/news_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:tdd_clean/core/error/failures.dart';

import 'get_news_test.mocks.dart';

@GenerateMocks([NewsRepo]) // Annotating to generate mocks for the NewsRepo class.
void main() {
  late GetCountryNews getCountryNews; // Declaring a variable for the GetCountryNews use case.
  late GetQueryNews getQueryNews; // Declaring a variable for the GetQueryNews use case.
  late MockNewsRepo mockNewsRepo; // Declaring a variable for the mocked NewsRepo.

  // This is the setup method, which runs before each test.
  setUp(() {
    mockNewsRepo = MockNewsRepo(); // Initializing the mocked NewsRepo.
    getQueryNews = GetQueryNews(mockNewsRepo); // Initializing the use case with the mocked repository.
    getCountryNews = GetCountryNews(mockNewsRepo); // Initializing the use case with the mocked repository.
  });

  // Example news entity list that will be used in the test.
  final tNewsEntityList = [
    NewsEntity(
      sourceId: '1',
      sourceName: 'Test Source',
      author: 'Test Author',
      title: 'Test Title 1',
      description: 'Test Description 1',
      url: 'https://example.com',
      urlToImage: 'https://example.com/image1.jpg',
      publishedAt: DateTime.now(),
      content: 'Test Content 1',
    ),
    NewsEntity(
      sourceId: '2',
      sourceName: 'Test Source 2',
      author: 'Test Author 2',
      title: 'Test Title 2',
      description: 'Test Description 2',
      url: 'https://example.com',
      urlToImage: 'https://example.com/image2.jpg',
      publishedAt: DateTime.now(),
      content: 'Test Content 2',
    ),
  ];

  const tQuery = 'test query'; // A test query to search news with.
  const tCountry = 'test Country'; // A test country to search news with.
  const tCategory = 'test Category'; // A test category to search news with.

  group('getQueryNews', () {
    // Test case when the repository call is successful.
    test(
      'should return a list of NewsEntities when the repository call is successful',
      () async {
        // Arranging the mock to return a successful response (Right).
        when(mockNewsRepo.getQueryNews(tQuery))
            .thenAnswer((_) async => Right(tNewsEntityList));

        // Act: Calling the use case's call method with the test query.
        final result = await getQueryNews.call(GetQueryNewsParams(query: tQuery));

        // Assert: Verifying the result and the expected outcome.
        expect(result, Right(tNewsEntityList)); // Should return the list of NewsEntities.
        verify(mockNewsRepo.getQueryNews(tQuery)); // Verifying that the repository's method was called with the correct query.
        verifyNoMoreInteractions(mockNewsRepo); // Verifying that no other interactions occurred with the mock.
      },
    );

    // Test case when the repository call is unsuccessful.
    test(
      'should return ServerFailure when the repository call is unsuccessful',
      () async {
        // Arranging the mock to return a failure (Left).
        when(mockNewsRepo.getQueryNews(tQuery))
            .thenAnswer((_) async => Left(ServerFailure('Error')));

        // Act: Calling the use case's call method with the test query.
        final result = await getQueryNews.call(GetQueryNewsParams(query: tQuery));

        // Assert: Verifying the result and the expected failure outcome.
        expect(result, Left(ServerFailure('Error'))); // Should return a ServerFailure.
        verify(mockNewsRepo.getQueryNews(tQuery)); // Verifying that the repository's method was called with the correct query.
        verifyNoMoreInteractions(mockNewsRepo); // Verifying that no other interactions occurred with the mock.
      },
    );
  });

  group('getCountryNews', () {
    // Test case when the repository call is successful.
    test(
      'should return a list of NewsEntities when the repository call is successful',
      () async {
        // Arranging the mock to return a successful response (Right).
        when(mockNewsRepo.getCountryNews(tCountry, tCategory))
            .thenAnswer((_) async => Right(tNewsEntityList));

        // Act: Calling the use case's call method with the test query.
        final result = await getCountryNews.call(GetCountryNewsParams(country: tCountry, category: tCategory));

        // Assert: Verifying the result and the expected outcome.
        expect(result, Right(tNewsEntityList)); // Should return the list of NewsEntities.
        verify(mockNewsRepo.getCountryNews(tCountry, tCategory)); // Verifying that the repository's method was called with the correct query.
        verifyNoMoreInteractions(mockNewsRepo); // Verifying that no other interactions occurred with the mock.
      },
    );

    // Test case when the repository call is unsuccessful.
    test(
      'should return ServerFailure when the repository call is unsuccessful',
      () async {
        // Arranging the mock to return a failure (Left).
        when(mockNewsRepo.getCountryNews(tCountry, tCategory))
            .thenAnswer((_) async => Left(ServerFailure('Error')));

        // Act: Calling the use case's call method with the test query.
        final result = await getCountryNews.call(GetCountryNewsParams(country: tCountry, category: tCategory));

        // Assert: Verifying the result and the expected failure outcome.
        expect(result, Left(ServerFailure('Error'))); // Should return a ServerFailure.
        verify(mockNewsRepo.getCountryNews(tCountry, tCategory)); // Verifying that the repository's method was called with the correct query.
        verifyNoMoreInteractions(mockNewsRepo); // Verifying that no other interactions occurred with the mock.
      },
    );
  });
}
