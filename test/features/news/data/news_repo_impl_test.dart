import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_clean/core/connection/network_info.dart';
import 'package:tdd_clean/core/error/exceptions.dart';
import 'package:tdd_clean/core/error/failures.dart';
import 'package:tdd_clean/features/news/data/news_local_datasource.dart';
import 'package:tdd_clean/features/news/data/news_model.dart';
import 'package:tdd_clean/features/news/data/news_remote_datasource.dart';
import 'package:tdd_clean/features/news/data/news_repo_impl.dart';
import 'package:tdd_clean/features/news/domain/news_entity.dart';

import 'news_repo_impl_test.mocks.dart';

@GenerateMocks([NewsRemoteDatasource])
@GenerateMocks([NewsLocalDatasource])
@GenerateMocks([NetworkInfo])
void main() {
  late NewsRepoImpl newsRepoImpl;
  late MockNewsRemoteDatasource newsRemoteDatasource;
  late MockNewsLocalDatasource newsLocalDatasource;
  late MockNetworkInfo networkInfo;

  setUp(() {
    newsRemoteDatasource = MockNewsRemoteDatasource();
    newsLocalDatasource = MockNewsLocalDatasource();
    networkInfo = MockNetworkInfo();
    newsRepoImpl = NewsRepoImpl(
        newsRemoteDatasource: newsRemoteDatasource,
        newsLocalDatasource: newsLocalDatasource,
        networkInfo: networkInfo);
  });

  group('Get Query News', () {
    final tQuery = 'query';
    final tCountry = 'country';
    final tCategory = 'category';
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
    final NewsEntity newsEntity1 = tNewsModel1;

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
    final NewsEntity newsEntity2 = tNewsModel2;

    test('should check if the device is online for query news', () async {
      // arrange
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      // act
      newsRepoImpl.getQueryNews(tQuery);
      // assert
      verify(networkInfo.isConnected);
    });

    test('should check if the device is online for country wise news',
        () async {
      // arrange
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      // act
      newsRepoImpl.getCountryNews(tCountry, tCategory);
      // assert
      verify(networkInfo.isConnected);
    });

    group('Device is Online', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => true);
      });
      group('Query News', () {
        test(
            'Should return remote data when the call is Success for nullable Response',
            () async {
          // arrange
          when(newsRemoteDatasource.getQueryNews(any))
              .thenAnswer((_) async => tNewsModel1);

          // act
          final result =
              await newsRepoImpl.getQueryNews(tQuery); // Await the result

          // assert
          verify(newsRemoteDatasource
              .getQueryNews(tQuery)); // Verify the call was made
          expect(
              result, Right(newsEntity1)); // Assert the result is as expected
        });
        test(
            'Should return remote data when the call is Success for non nullable Response',
            () async {
          // arrange
          when(newsRemoteDatasource.getQueryNews(any))
              .thenAnswer((_) async => tNewsModel2);

          // act
          final result =
              await newsRepoImpl.getQueryNews(tQuery); // Await the result

          // assert
          verify(newsRemoteDatasource
              .getQueryNews(tQuery)); // Verify the call was made
          expect(
              result, Right(newsEntity2)); // Assert the result is as expected
        });

        // LOCAL
        test(
            'Should return local data when the call is Success for nullable Response',
            () async {
          // arrange
          when(newsRemoteDatasource.getQueryNews(any))
              .thenAnswer((_) async => tNewsModel1);

          // act
          await newsRepoImpl.getQueryNews(tQuery); // Await the result

          // assert
          verify(newsRemoteDatasource
              .getQueryNews(tQuery)); // Verify the call was made
          verify(newsLocalDatasource.cacheNews(tNewsModel1));
        });

        test(
            'Should return local data when the call is Success for non nullable Response',
            () async {
          // arrange
          when(newsRemoteDatasource.getQueryNews(any))
              .thenAnswer((_) async => tNewsModel2);

          // act
          await newsRepoImpl.getQueryNews(tQuery); // Await the result

          // assert
          verify(newsRemoteDatasource
              .getQueryNews(tQuery)); // Verify the call was made
          verify(newsLocalDatasource.cacheNews(tNewsModel2));
        });
        test('Should return server failure when the call is Failure', () async {
          // arrange
          when(newsRemoteDatasource.getQueryNews(any))
              .thenThrow(ServerException('Error'));

          // act
          final result = await newsRepoImpl.getQueryNews(
              tQuery); // Await the result

          // assert
          verify(newsRemoteDatasource.getQueryNews(
              tQuery)); // Verify the call was made
          verifyZeroInteractions(newsLocalDatasource);
          expect(result,
              Left(ServerFailure('Error'))); // Assert the result is as expected
        });
      });

      group('Country wise News', () {
        test(
            'Should return remote data when the call is Success for nullable Response',
            () async {
          // arrange
          when(newsRemoteDatasource.getCountryNews(any, any))
              .thenAnswer((_) async => tNewsModel1);

          // act
          final result = await newsRepoImpl.getCountryNews(
              tCountry, tCategory); // Await the result

          // assert
          verify(newsRemoteDatasource.getCountryNews(
              tCountry, tCategory)); // Verify the call was made
          expect(
              result, Right(newsEntity1)); // Assert the result is as expected
        });
        test(
            'Should return remote data when the call is Success for non nullable Response',
            () async {
          // arrange
          when(newsRemoteDatasource.getCountryNews(any, any))
              .thenAnswer((_) async => tNewsModel2);

          // act
          final result = await newsRepoImpl.getCountryNews(
              tCountry, tCategory); // Await the result

          // assert
          verify(newsRemoteDatasource.getCountryNews(
              tCountry, tCategory)); // Verify the call was made
          expect(
              result, Right(newsEntity2)); // Assert the result is as expected
        });

        // LOCAL
        test(
            'Should return local data when the call is Success for nullable Response',
            () async {
          // arrange
          when(newsRemoteDatasource.getCountryNews(any, any))
              .thenAnswer((_) async => tNewsModel1);

          // act
          await newsRepoImpl.getCountryNews(
              tCountry, tCategory); // Await the result

          // assert
          verify(newsRemoteDatasource.getCountryNews(
              tCountry, tCategory)); // Verify the call was made
          verify(newsLocalDatasource.cacheNews(tNewsModel1));
        });

        test(
            'Should return local data when the call is Success for non nullable Response',
            () async {
          // arrange
          when(newsRemoteDatasource.getCountryNews(any, any))
              .thenAnswer((_) async => tNewsModel2);

          // act
          await newsRepoImpl.getCountryNews(
              tCountry, tCategory); // Await the result

          // assert
          verify(newsRemoteDatasource.getCountryNews(
              tCountry, tCategory)); // Verify the call was made
          verify(newsLocalDatasource.cacheNews(tNewsModel2));
        });
      test('Should return server failure when the call is Failure', () async {
        // arrange
        when(newsRemoteDatasource.getCountryNews(any, any))
            .thenThrow(ServerException('Error'));

        // act
        final result = await newsRepoImpl.getCountryNews(
            tCountry, tCategory); // Await the result

        // assert
        verify(newsRemoteDatasource.getCountryNews(
            tCountry, tCategory)); // Verify the call was made
        verifyZeroInteractions(newsLocalDatasource);
        expect(result,
            Left(ServerFailure('Error'))); // Assert the result is as expected
      });
      });
    });

    group('Device is Offline', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => false);
      });
      test('Should return last cached data when cached data is Success for Query News',
        ()async{
          // arrange
          when(newsLocalDatasource.getLastNews()).thenAnswer((_) async => tNewsModel1);
          // act
          final result = await newsRepoImpl.getQueryNews(tQuery);
          // assert
          verifyZeroInteractions(newsRemoteDatasource);
          verify(newsLocalDatasource.getLastNews());
          expect(result, equals(Right(tNewsModel1)));
        }
      );

      test('Should return last cached data when cached data is Success for Country wise News',
        ()async{
          // arrange
          when(newsLocalDatasource.getLastNews()).thenAnswer((_) async => tNewsModel1);
          // act
          final result = await newsRepoImpl.getCountryNews(tCountry,tCategory);
          // assert
          verifyZeroInteractions(newsRemoteDatasource);
          verify(newsLocalDatasource.getLastNews());
          expect(result, equals(Right(tNewsModel1)));
        }
      );

      test('Should return Cache failure when there is no cached data present for Query news',
        ()async{
          // arrange
          when(newsLocalDatasource.getLastNews()).thenThrow(CacheException('Error'));
          // act
          final result = await newsRepoImpl.getQueryNews(tQuery);
          // assert
          verifyZeroInteractions(newsRemoteDatasource);
          verify(newsLocalDatasource.getLastNews());
          expect(result, equals(Left(CacheFailure('Error'))));
        }
      );

      test('Should return Cache failure when there is no cached data present for Country wise news',
        ()async{
          // arrange
          when(newsLocalDatasource.getLastNews()).thenThrow(CacheException('Error'));
          // act
          final result = await newsRepoImpl.getCountryNews(tCountry,tCategory);
          // assert
          verifyZeroInteractions(newsRemoteDatasource);
          verify(newsLocalDatasource.getLastNews());
          expect(result, equals(Left(CacheFailure('Error'))));
        }
      );
    });
  });
}
