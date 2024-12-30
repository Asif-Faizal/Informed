
# Informed        <img src="https://github.com/user-attachments/assets/cb71cef2-1e3b-4b8e-a7a0-e338fb1705d1" width="30" height="30" />


Informed is a News app built with Flutter's Test-Driven Development (TDD) and Clean Architecture with 49 tests. It focuses on modularity, testability, scalability and maintainability.

![Untitled design](https://github.com/user-attachments/assets/dcd5afae-fa1f-4ddd-8159-5b3ad1b1db93)

## API
### URLs
News by Query
```bash
https://newsapi.org/v2/everything?q=query&sortBy=publishedAt&apiKey=API_KEY
```
News by Country and Category
```bash
https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=API_KEY
```

### Response
```json
{
    "status": "ok",
    "totalResults": 2,
    "articles": [
        {
            "source": {
                "id": "associated-press",
                "name": "Associated Press"
            },
            "author": "BRIAN P. D. HANNON",
            "title": "Charles Dolan, HBO and Cablevision founder, dies at 98 - The Associated Press",
            "description": "Charles Dolan, who founded some of the most prominent U.S. media companies including Home Box Office Inc. and Cablevision Systems Corp., has died at age 98. Newsday reports that a statement issued Saturday by his family says Dolan died of natural causes. Dola…",
            "url": "https://apnews.com/article/charles-dolan-dies-obituary-hbo-cablevision-bc5b48318f336f633b7df006afcd60c4",
            "urlToImage": "https://dims.apnews.com/dims4/default/f2a2365/2147483647/strip/true/crop/4364x2455+0+291/resize/1440x810!/quality/90/?url=https%3A%2F%2Fassets.apnews.com%2F37%2F90%2F56bc4c057c97e40ed424ca4dea58%2F9b635bd1d71340b9998b6cf1d63e1bd5",
            "publishedAt": "2024-12-29T04:39:00Z",
            "content": "Charles Dolan, who founded some of the most prominent U.S. media companies including Home Box Office Inc. and Cablevision Systems Corp., has died at age 98, according to a news report.\r\nA statement i… [+1269 chars]"
        },
        {
            "source": {
                "id": null,
                "name": "[Removed]"
            },
            "author": null,
            "title": "[Removed]",
            "description": "[Removed]",
            "url": "https://removed.com",
            "urlToImage": null,
            "publishedAt": "2024-12-28T22:09:33Z",
            "content": "[Removed]"
        },
    ]
}
```

## Entity

```dart
import 'package:equatable/equatable.dart';

class NewsEntity extends Equatable {
  final String? sourceId;
  final String sourceName;
  final String? author;
  final String title;
  final String? description;
  final String url;
  final String? urlToImage;
  final DateTime publishedAt;
  final String? content;

  const NewsEntity({
    required this.sourceId,
    required this.sourceName,
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
  });

  @override
  List<Object?> get props => [
        sourceId,
        sourceName,
        author,
        title,
        description,
        url,
        urlToImage,
        publishedAt,
        content,
      ];
}
```

## Failures
```dart
abstract class Failure extends Equatable {
  const Failure();

  @override
  List<Object?> get props => [];
}

// Server failure class
class ServerFailure extends Failure {
  final String message;

  const ServerFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// Cache failure class
class CacheFailure extends Failure {
  final String message;

  const CacheFailure(this.message);

  @override
  List<Object?> get props => [message];
}
```

## Repo
From the entity equest and response model neede to be tested
Repo with either failure or the entity is created using `dartz`
```dart
import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import 'news_entity.dart';

abstract class NewsRepo {
  Future<Either<Failure, List<NewsEntity>>> getQueryNews(String query);
  Future<Either<Failure, List<NewsEntity>>> getCountryNews(String country, String category);
}
```

## Usecases
A simple usecase class is made initially
```dart
class GetQueryNews {
  final NewsRepo repository;

  GetQueryNews(this.repository);
}
```
### UseCase Test
For mocking the repo
```dart
@GenerateMocks([NewsRepo])

void main(){}
```
and `build_runner` is initiated to create `MockNewsRepo`
```bash
flutter pub run build_runner build
```
To the main function
```dart
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
}
```
Test Input and Output for Mocking
```dart
  // Example news entity that will be used in the test.
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
```
Inside a group test success and failure tests should be performed
```dart
    test(
      'should return a list of NewsEntities when the repository call is successful',
      () async {
        // Arranging the mock to return a successful response (Right).
        when(mockNewsRepo.getQueryNews(tQuery))
            .thenAnswer((_) async => Right(tNewsEntityList));

        // Act: Calling the use case's call method with the test query.
        final result = await getQueryNews.call(tQuery);

        // Assert: Verifying the result and the expected outcome.
        expect(result, Right(tNewsEntityList)); // Should return the list of NewsEntities.
        verify(mockNewsRepo.getQueryNews(tQuery)); // Verifying that the repository's method was called with the correct query.
        verifyNoMoreInteractions(mockNewsRepo); // Verifying that no other interactions occurred with the mock.
      },
    );
```
```dart
    test(
      'should return ServerFailure when the repository call is unsuccessful',
      () async {
        // Arranging the mock to return a failure (Left).
        when(mockNewsRepo.getQueryNews(tQuery))
            .thenAnswer((_) async => Left(ServerFailure('Error')));

        // Act: Calling the use case's call method with the test query.
        final result = await getQueryNews.call(tQuery);

        // Assert: Verifying the result and the expected failure outcome.
        expect(result, Left(ServerFailure('Error'))); // Should return a ServerFailure.
        verify(mockNewsRepo.getQueryNews(tQuery)); // Verifying that the repository's method was called with the correct query.
        verifyNoMoreInteractions(mockNewsRepo); // Verifying that no other interactions occurred with the mock.
      },
    );
```
Similiar test should be done for `GetCountryNews`

also Params to be used in UseCase
```dart
class GetQueryNewsParams extends Equatable {
  final String query;

  GetQueryNewsParams({required this.query});

  @override
  List<Object?> get props => [query];
}
```
Params in the test 
```dart
final result = await getQueryNews.call(GetQueryNewsParams(query: tQuery));
```
Final Usecases
```dart
class GetQueryNews implements Usecase<List<NewsEntity>, GetQueryNewsParams> {
  final NewsRepo repository;

  GetQueryNews(this.repository);

  @override
  Future<Either<Failure, List<NewsEntity>>> call(GetQueryNewsParams params) {
    return repository.getQueryNews(params.query);
  }
}

class GetQueryNewsParams extends Equatable {
  final String query;

  GetQueryNewsParams({required this.query});

  @override
  List<Object?> get props => [query];
}
```
```dart
class GetCountryNews implements Usecase<List<NewsEntity>, GetCountryNewsParams> {
  final NewsRepo repository;

  GetCountryNews(this.repository);

  @override
  Future<Either<Failure, List<NewsEntity>>> call(GetCountryNewsParams params) {
    return repository.getCountryNews(params.country, params.category);
  }
}

class GetCountryNewsParams extends Equatable {
  final String country;
  final String category;

  GetCountryNewsParams({required this.country, required this.category});

  @override
  List<Object?> get props => [country, category];
}
```
Now the Model can be made

## Model
```dart
class NewsModel extends NewsEntity {
  const NewsModel({
    required String? sourceId,
    required String sourceName,
    required String? author,
    required String title,
    required String? description,
    required String url,
    required String? urlToImage,
    required DateTime publishedAt,
    required String? content,
  }) : super(
          sourceId: sourceId,
          sourceName: sourceName,
          author: author,
          title: title,
          description: description,
          url: url,
          urlToImage: urlToImage,
          publishedAt: publishedAt,
          content: content,
        );
}
```
### Model Test
All type of response need to be tested with nullable response and non nullable responses

Check if Model is SubType of Entity
```dart
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
```
### Test for fromJson
A json reader needs to be created to read .json files from the project directory.

```dart
import 'dart:io';

String fixture(String name) => File('test/fixtures/$name').readAsStringSync();
```
And store the types of json responses in a .json file

```dart
    test('fromJson method for nullable response', () async {
      //arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('news_null.json'));
      //act
      final result = NewsModel.fromJson(jsonMap);
      //assert
      expect(result, tNewsModel1);
    });

    test('fromJson method for non nullable response', () async {
      //arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('news_non_null.json'));
      //act
      final result = NewsModel.fromJson(jsonMap);
      //assert
      expect(result, tNewsModel2);
    });
```
formed fromJson
```dart
  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      sourceId: json['source']?['id'] as String?,
      sourceName: json['source']?['name'] as String? ?? '',
      author: json['author'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      url: json['url'] as String,
      urlToImage: json['urlToImage'] as String?,
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      content: json['content'] as String?,
    );
  }
```

### Test for `toJson` (optional)

```dart
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
```
formed toJson
```dart
  Map<String, dynamic> toJson() {
    return {
      'source': {
        'id': sourceId,
        'name': sourceName,
      },
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt.toUtc().toIso8601String().replaceAll('.000Z', 'Z'),
      'content': content,
    };
  }
```

## Initialising Datasource
Remote Datasource
```dart
abstract class NewsRemoteDatasource {
  // calls API [https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=API_KEY]
  Future<List<NewsModel>> getQueryNews(String query);
  // calls API [https://newsapi.org/v2/everything?q=apple&sortBy=publishedAt&apiKey=API_KEY]
  Future<List<NewsModel>> getCountryNews(String country, String category);
}
```

Local Datasource
```dart
abstract class NewsLocalDatasource {
  Future<List<NewsModel>> getLastNews();
  Future<void> cacheNews(List<NewsModel> newsToCache);
}
```

### Network Info
Used to detect weather to fetch from Remote or Local Datasource
```dart
abstract class NetworkInfo {
  Future<bool> get isConnected;
}
```
```dart
@GenerateMocks([Connectivity])
```

Test for checking the package behaves correctly
```dart
group('Mocked Connectivity Tests', () {
    late MockConnectivity mockConnectivity;

    setUp(() {
      mockConnectivity = MockConnectivity();

      // Initialize the mock method to return a default value
      when(mockConnectivity.checkConnectivity()).thenAnswer(
        (_) async => [ConnectivityResult.none],
      );
    });

    test('Check WiFi Connectivity with Mock', () async {
      // Mock the return value to simulate WiFi connection
      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.wifi]);

      // Call the method and assert the result
      final result = await mockConnectivity.checkConnectivity();
      expect(result, [ConnectivityResult.wifi]);
    });

    test('Check Mobile Data Connectivity with Mock', () async {
      // Mock the return value to simulate mobile data connection
      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.mobile]);

      // Call the method and assert the result
      final result = await mockConnectivity.checkConnectivity();
      expect(result, [ConnectivityResult.mobile]);
    });

    test('Check No Connectivity with Mock', () async {
      // Mock the return value to simulate no connectivity
      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.none]);

      // Call the method and assert the result
      final result = await mockConnectivity.checkConnectivity();
      expect(result, [ConnectivityResult.none]);
    });

    test('Check Connectivity Change Listener with Mock', () async {
      // Create a stream controller that emits lists of connectivity results
      final streamController = StreamController<List<ConnectivityResult>>();

      // Mock the connectivity change stream
      when(mockConnectivity.onConnectivityChanged)
          .thenAnswer((_) => streamController.stream);

      // Add test values to the stream as lists
      streamController.add([ConnectivityResult.wifi]);
      streamController
          .add([ConnectivityResult.wifi, ConnectivityResult.mobile]);
      streamController.add([ConnectivityResult.none]);

      // Listen for connectivity changes and assert the values
      await expectLater(
        mockConnectivity.onConnectivityChanged,
        emitsInOrder([
          [ConnectivityResult.wifi],
          [ConnectivityResult.wifi, ConnectivityResult.mobile],
          [ConnectivityResult.none]
        ]),
      );

      // Clean up
      await streamController.close();
    });
  });
```

Test for `NetworkInfo Implementation`
```dart
 group('Test connectivity on Network Info Implementation', () {
    late MockConnectivity mockConnectivity;
    late NetworkInfoImpl networkInfoImpl;

    setUp(() {
      mockConnectivity = MockConnectivity();
      networkInfoImpl = NetworkInfoImpl(connectivity: mockConnectivity);
    });

    test('Should return true when connectivity result is wifi', () async {
      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.wifi]);

      final result = await networkInfoImpl.isConnected;

      expect(result, true);
    });

    test('Should return true when connectivity result is mobile', () async {
      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.mobile]);

      final result = await networkInfoImpl.isConnected;

      expect(result, true);
    });

    test('Should return false when connectivity result is only none', () async {
      // Arrange
      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.none]);

      // Act
      final result = await networkInfoImpl.isConnected;

      // Assert
      expect(result, false);
      verify(mockConnectivity.checkConnectivity());
    });

    test(
        'Should return true when multiple connectivity results include a valid connection',
        () async {
      // Arrange
      when(mockConnectivity.checkConnectivity()).thenAnswer(
          (_) async => [ConnectivityResult.none, ConnectivityResult.wifi]);

      // Act
      final result = await networkInfoImpl.isConnected;

      // Assert
      expect(result, true);
      verify(mockConnectivity.checkConnectivity());
    });
  });
```
NetworkInfo Implementation can be created 
```dart
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl({required this.connectivity});

  @override
  Future<bool> get isConnected async {
    final results = await connectivity.checkConnectivity();
    // Check if there are any connectivity results that aren't 'none'
    return results.any((result) => result != ConnectivityResult.none);
  }
}
```

## Repo Implementation
Initial Repo Implementation is created
```dart
class NewsRepoImpl implements NewsRepo {
  @override
  Future<Either<Failure, NewsEntity>> getCountryNews(String country, String category) {
    // TODO: implement getCountryNews
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, NewsEntity>> getQueryNews(String query) {
    // TODO: implement getQueryNews
    throw UnimplementedError();
  }
}
```

### Test Setup for Repo Impl
```dart
@GenerateMocks([NewsRemoteDatasource])
@GenerateMocks([NewsLocalDatasource])
@GenerateMocks([NetworkInfo])

void main(){
  NewsRepoImpl newsRepoImpl;
  MockNewsRemoteDatasource newsRemoteDatasource;
  MockNewsLocalDatasource newsLocalDatasource;
  MockNetworkInfo networkInfo;

  setUp((){
    newsRemoteDatasource =  MockNewsRemoteDatasource();
    newsLocalDatasource =  MockNewsLocalDatasource();
    networkInfo = MockNetworkInfo();
    newsRepoImpl = NewsRepoImpl(
      newsRemoteDatasource: newsRemoteDatasource, newsLocalDatasource: newsLocalDatasource, networkInfo: networkInfo
    );
  });
}
```
Repo Implementation becomes:
```dart
class NewsRepoImpl implements NewsRepo {
  final NewsRemoteDatasource newsRemoteDatasource;
  final NewsLocalDatasource newsLocalDatasource;
  final NetworkInfo networkInfo;

  NewsRepoImpl({required this.newsRemoteDatasource, required this.newsLocalDatasource, required this.networkInfo});

  @override
  Future<Either<Failure, NewsEntity>> getCountryNews(String country, String category) {
    // TODO: implement getCountryNews
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, NewsEntity>> getQueryNews(String query) {
    // TODO: implement getQueryNews
    throw UnimplementedError();
  }
}
```

## Repo Implemetation Test
Setup
```dart
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
      networkInfo: networkInfo,
    );
  });
 }
}

group('Get News', () {
  final tQuery = 'query';
    final tCountry = 'country';
    final tCategory = 'category';

    final tNewsModel1 = [
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
      )
    ];
    final List<NewsEntity> newsEntity1 = tNewsModel1;

    final tNewsModel2 = [
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
      )
    ];
    final List<NewsEntity> newsEntity2 = tNewsModel2;
}
```
Test cases are:
* should check if the device is online for query news
* should check if the device is online for country wise news

```dart
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
```
### When Device is Online:
Test cases:
* Should return remote data when the call is Success for nullable Response
* Should return remote data when the call is Success for non nullable Response
* Should return local data when the call is Success for nullable Response
* Should return local data when the call is Success for non nullable Response
* Should return server failure when the call is Failure
For both QueryNews and CountryNews
```dart
test(
          'Should return remote data when the call is Success for nullable Response',
          () async {
            // arrange
            when(newsRemoteDatasource.getQueryNews(any))
                .thenAnswer((_) async => tNewsModel1);

            // act
            final result = await newsRepoImpl.getQueryNews(tQuery);

            // assert
            verify(newsRemoteDatasource.getQueryNews(tQuery));
            expect(result,
                Right(newsEntity1)); // Expect a List of NewsEntity directly
          },
        );

        test(
            'Should return remote data when the call is Success for non nullable Response',
            () async {
          // arrange
          when(newsRemoteDatasource.getQueryNews(any))
              .thenAnswer((_) async => tNewsModel2);

          // act
          final result = await newsRepoImpl.getQueryNews(tQuery);

          // assert
          verify(newsRemoteDatasource.getQueryNews(tQuery));
          expect(result, Right(newsEntity2));
        });

        test(
            'Should return local data when the call is Success for nullable Response',
            () async {
          // arrange
          when(newsRemoteDatasource.getQueryNews(any))
              .thenAnswer((_) async => tNewsModel1);

          // act
          await newsRepoImpl.getQueryNews(tQuery);

          // assert
          verify(newsRemoteDatasource.getQueryNews(tQuery));
          verify(newsLocalDatasource.cacheNews(tNewsModel1));
        });

        test(
            'Should return local data when the call is Success for non nullable Response',
            () async {
          // arrange
          when(newsRemoteDatasource.getQueryNews(any))
              .thenAnswer((_) async => tNewsModel2);

          // act
          await newsRepoImpl.getQueryNews(tQuery);

          // assert
          verify(newsRemoteDatasource.getQueryNews(tQuery));
          verify(newsLocalDatasource.cacheNews(tNewsModel2));
        });

        test('Should return server failure when the call is Failure', () async {
          // arrange
          when(newsRemoteDatasource.getQueryNews(any))
              .thenThrow(ServerException('Error'));

          // act
          final result = await newsRepoImpl.getQueryNews(tQuery);

          // assert
          verify(newsRemoteDatasource.getQueryNews(tQuery));
          verifyZeroInteractions(newsLocalDatasource);
          expect(result, Left(ServerFailure('Error')));
        });
      });
```
### When Device is Offline:
Test cases:
* Should return local data when the call is Failure for nullable Response
* Should return local data when the call is Failure for non nullable Response
* Should return cache failure when the local data is Failure
For both QueryNews and CountryNews
```dart
test(
            'Should return local data when the call is Failure for nullable Response',
            () async {
          // arrange
          when(newsLocalDatasource.getLastNews())
              .thenAnswer((_) async => tNewsModel1);

          // act
          final result = await newsRepoImpl.getQueryNews(tQuery);

          // assert
          verify(newsLocalDatasource.getLastNews());
          expect(result, Right(newsEntity1));
        });

        test(
            'Should return local data when the call is Failure for non nullable Response',
            () async {
          // arrange
          when(newsLocalDatasource.getLastNews())
              .thenAnswer((_) async => tNewsModel2);

          // act
          final result = await newsRepoImpl.getQueryNews(tQuery);

          // assert
          verify(newsLocalDatasource.getLastNews());
          expect(result, Right(newsEntity2));
        });

        test('Should return cache failure when the local data is Failure',
            () async {
          // arrange
          when(newsLocalDatasource.getLastNews())
              .thenThrow(CacheException('Error'));

          // act
          final result = await newsRepoImpl.getQueryNews(tQuery);

          // assert
          verify(newsLocalDatasource.getLastNews());
          expect(result, Left(CacheFailure('Error')));
        });
      });
```

Repo Implementation will be
```dart
class NewsRepoImpl implements NewsRepo {
  final NewsRemoteDatasource newsRemoteDatasource;
  final NewsLocalDatasource newsLocalDatasource;
  final NetworkInfo networkInfo;

  NewsRepoImpl({
    required this.newsRemoteDatasource,
    required this.newsLocalDatasource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<NewsEntity>>> getCountryNews(String country, String category) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteNews = await newsRemoteDatasource.getCountryNews(country, category);
        newsLocalDatasource.cacheNews(remoteNews);
        return Right(remoteNews);
      } catch (e) {
        return Left(ServerFailure('Error'));
      }
    } else {
      try {
        final localNews = await newsLocalDatasource.getLastNews();
        return Right(localNews); // return cached list of news
      } catch (e) {
        return Left(CacheFailure('Error'));
      }
    }
  }

  @override
  Future<Either<Failure, List<NewsEntity>>> getQueryNews(String query) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteNews = await newsRemoteDatasource.getQueryNews(query);
        newsLocalDatasource.cacheNews(remoteNews);
        return Right(remoteNews);
      } catch (e) {
        return Left(ServerFailure('Error'));
      }
    } else {
      try {
        final localNews = await newsLocalDatasource.getLastNews();
        return Right(localNews); // return cached list of news
      } catch (e) {
        return Left(CacheFailure('Error'));
      }
    }
  }
}
```

## DataSource Test
### Remote DataSource
Test Setup
```dart
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
 }
}
```

Test cases are:
* should perform GET request on a URL with query
* should return a list of News Models when status code is 200
* should throw ServerException when status code is not 200
for both getQueryNews and getCountryNews
```dart
test('should perform GET request on a URL with query', () async {
    // arrange
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('news_non_null.json'), 200));

    // act
    await datasource.getQueryNews(tQuery);

    // assert
    verify(mockClient.get(
      Uri.parse(
        "https://newsapi.org/v2/everything?q=$tQuery&sortBy=publishedAt&apiKey=API_KEY",
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
```
Similiarly for getCountryNews
The Remote DataSource Implementation will be
```dart
class NewsRemoteDatasourceImpl implements NewsRemoteDatasource {
  final http.Client client;

  NewsRemoteDatasourceImpl({required this.client});

  @override
  Future<List<NewsModel>> getCountryNews(
      String country, String category) async {
    final response = await client.get(
      Uri.parse(
        "https://newsapi.org/v2/top-headlines?country=$country&category=$category&apiKey=API_KEY",
      ),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body) as Map<String, dynamic>;
      final articles = (responseBody['articles'] as List)
          .map((article) => NewsModel.fromJson(article))
          .toList();
      return articles;
    } else {
      throw ServerException('Error');
    }
  }

  @override
  Future<List<NewsModel>> getQueryNews(String query) async {
    final response = await client.get(
      Uri.parse(
        "https://newsapi.org/v2/everything?q=$query&sortBy=publishedAt&apiKey=API_KEY",
      ),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body) as Map<String, dynamic>;
      final articles = (responseBody['articles'] as List)
          .map((article) => NewsModel.fromJson(article))
          .toList();
      return articles;
    } else {
      throw ServerException('Error');
    }
  }
}
```

## Local Datasource
Test Setup
```dart
@GenerateMocks([SharedPreferences])
void main() {
  late NewsLocalDatasourceImpl datasource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    datasource = NewsLocalDatasourceImpl(sharedPreferences: mockSharedPreferences);
  });
 }
}
```

Test cases are:
* should return News from shared preferences if present
* should throw CacheFailure when there is no cache value
* should call shared preferences to Cache the data
for both getQueryNews and getCountryNews

```dart
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
```
```dart
    test('should call shared preferences to Cache the data', () async {
      // Act
      await datasource.cacheNews(tNewsModelList); // Cache the news

      // Arrange
      final jsonString =
          json.encode(tNewsModelList.map((model) => model.toJson()).toList()); // Serialize list of models to JSON

      // Assert
      verify(mockSharedPreferences.setString('CACHED_NEWS', jsonString)); // Verify that setString was called with the expected arguments
    });
```
Now the Local DataSource Implementation will be:
```dart
class NewsLocalDatasourceImpl implements NewsLocalDatasource {
  final SharedPreferences sharedPreferences;

  static const CACHED_NEWS_KEY = 'CACHED_NEWS';

  NewsLocalDatasourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheNews(List<NewsModel> newsToCache) async {
    // Convert the list of NewsModel to a JSON-encoded string
    final List<Map<String, dynamic>> jsonList =
        newsToCache.map((news) => news.toJson()).toList();
    await sharedPreferences.setString(
      CACHED_NEWS_KEY,
      json.encode(jsonList),
    );
  }

  @override
  Future<List<NewsModel>> getLastNews() {
    final jsonString = sharedPreferences.getString(CACHED_NEWS_KEY);
    if (jsonString != null) {
      try {
        // Decode JSON and map it to a List<NewsModel>
        final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
        final List<NewsModel> newsList = jsonList
            .map((jsonItem) => NewsModel.fromJson(jsonItem as Map<String, dynamic>))
            .toList();
        return Future.value(newsList);
      } catch (e) {
        throw CacheFailure('Error parsing cached news');
      }
    } else {
      throw CacheFailure('No cached news found');
    }
  }
}
```




