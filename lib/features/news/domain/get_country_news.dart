import 'package:dartz/dartz.dart';
import 'package:tdd_clean/features/news/domain/news_repo.dart';

import '../../../core/error/failures.dart';
import 'news_entity.dart';

class GetCountryNews {
  final NewsRepo repository;

  GetCountryNews(this.repository);

  Future<Either<Failure, NewsEntity>> call(String country, String category) {
    return repository.getCountryNews(country,category);
  }
}
