import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_clean/core/connection/network_info.dart';
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

    test('should check if the device is online', () async {
      // arrange
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      // act
      newsRepoImpl.getQueryNews(tQuery);
      // assert
      verify(networkInfo.isConnected);
    });
  });
}
