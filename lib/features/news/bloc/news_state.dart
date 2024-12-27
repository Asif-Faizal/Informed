part of 'news_bloc.dart';

sealed class NewsState extends Equatable {
  const NewsState();
  
  @override
  List<Object> get props => [];
}

final class NewsInitial extends NewsState {}

final class QueryNewsLoading extends NewsState {}

final class QueryNewsLoaded extends NewsState {
  final NewsEntity news;

  QueryNewsLoaded({required this.news});

  @override
  List<Object> get props => [news];
}

final class QueryNewsError extends NewsState {
  final String errorMessage;

  QueryNewsError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

final class CountryNewsLoading extends NewsState {}

final class CountryNewsLoaded extends NewsState {
    final NewsEntity news;

  CountryNewsLoaded({required this.news});

  @override
  List<Object> get props => [news];
}

final class CountryNewsError extends NewsState {
  final String errorMessage;

  CountryNewsError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
