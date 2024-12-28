import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';
import 'news_entity.dart';
import 'news_repo.dart';

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
