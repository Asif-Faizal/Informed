import 'package:dartz/dartz.dart';
import 'package:tdd_clean/core/connection/network_info.dart';

import 'package:tdd_clean/core/error/failures.dart';
import 'package:tdd_clean/features/news/data/news_local_datasource.dart';
import 'package:tdd_clean/features/news/data/news_remote_datasource.dart';

import 'package:tdd_clean/features/news/domain/news_entity.dart';

import '../domain/news_repo.dart';

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
  Future<Either<Failure, NewsEntity>> getCountryNews(String country, String category) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteNews = await newsRemoteDatasource.getCountryNews(country, category);
        newsLocalDatasource.cacheNews(remoteNews);
        return Right(remoteNews);
      } catch (e) {
        return Left(ServerFailure('Error'));
      }
    } else {
      try{
        final localNews = await newsLocalDatasource.getLastNews();
      return Right(localNews);
      }catch (e) {
        return Left(CacheFailure('Error'));
      }
    }
  }

  @override
  Future<Either<Failure, NewsEntity>> getQueryNews(String query) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteNews = await newsRemoteDatasource.getQueryNews(query);
        newsLocalDatasource.cacheNews(remoteNews);
        return Right(remoteNews);
      } catch (e) {
        return Left(ServerFailure('Error'));
      }
    } else {
      try{
        final localNews = await newsLocalDatasource.getLastNews();
      return Right(localNews);
      }catch (e){
        return Left(CacheFailure('Error'));
      }
    }
  }
}
