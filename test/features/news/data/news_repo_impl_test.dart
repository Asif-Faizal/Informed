import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:tdd_clean/core/connection/network_info.dart';
import 'package:tdd_clean/features/news/data/news_local_datasource.dart';
import 'package:tdd_clean/features/news/data/news_remote_datasource.dart';
import 'package:tdd_clean/features/news/data/news_repo_impl.dart';

import 'news_repo_impl_test.mocks.dart';

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