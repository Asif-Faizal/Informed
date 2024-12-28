import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import 'news_entity.dart';

abstract class NewsRepo {
  Future<Either<Failure, List<NewsEntity>>> getQueryNews(String query);
  Future<Either<Failure, List<NewsEntity>>> getCountryNews(String country, String category);
}
