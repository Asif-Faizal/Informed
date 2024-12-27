part of 'news_bloc.dart';

sealed class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object> get props => [];
}

class GetQueryNewsEvent extends NewsEvent {
  final String query;

  GetQueryNewsEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class GetCountryWiseNewsEvent extends NewsEvent {
  final String country;
  final String category;

  GetCountryWiseNewsEvent({required this.country, required this.category});

  @override
  List<Object> get props => [country, category];
}
