import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tdd_clean/core/usecase/usecase.dart';
import 'package:tdd_clean/features/news/domain/news_repo.dart';

import '../../../core/error/failures.dart';
import 'news_entity.dart';

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
