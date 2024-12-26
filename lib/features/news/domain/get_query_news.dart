import 'package:dartz/dartz.dart';
import 'package:tdd_clean/features/news/domain/news_repo.dart';

import '../../../core/error/failures.dart';
import 'news_entity.dart';

class GetQueryNews {
  final NewsRepo repository;

  GetQueryNews(this.repository);

  Future<Either<Failure, NewsEntity>> call(String query) {
    return repository.getQueryNews(query);
  }
}
