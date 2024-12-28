import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';
import 'news_entity.dart';
import 'news_repo.dart';

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
