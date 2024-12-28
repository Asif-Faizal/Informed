import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../domain/get_country_news.dart';
import '../domain/get_query_news.dart';
import '../domain/news_entity.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetQueryNews getQueryNews;
  final GetCountryNews getCountryNews;
  String country = 'all';

  NewsBloc({required this.getQueryNews, required this.getCountryNews})
      : super(NewsInitial()) {
    on<GetQueryNewsEvent>((event, emit) async {
      try {
        // First emit loading state
        emit(QueryNewsLoading());
        print('Emitted QueryNewsLoading state');

        country = 'all';

        // Get the result
        final result =
            await getQueryNews(GetQueryNewsParams(query: event.query));

        // Handle the result
        result.fold(
          (failure) {
            emit(QueryNewsError(errorMessage: failure.toString()));
            print('Emitted QueryNewsError state');
          },
          (newsList) {
            emit(QueryNewsLoaded(news: newsList));
            print(
                'Emitted QueryNewsLoaded state with ${newsList.length} items');
          },
        );
      } catch (e) {
        emit(QueryNewsError(errorMessage: e.toString()));
        print('Emitted QueryNewsError state due to exception: $e');
      }
    });

    on<GetCountryWiseNewsEvent>((event, emit) async {
      try {
        // First emit loading state
        emit(CountryNewsLoading());
        print('Emitted CountryNewsLoading state');

        country = event.country;

        // Get the result
        final result = await getCountryNews(
          GetCountryNewsParams(
            country: event.country,
            category: event.category,
          ),
        );

        // Handle the result
        result.fold(
          (failure) {
            emit(CountryNewsError(errorMessage: failure.toString()));
            print('Emitted CountryNewsError state');
          },
          (newsList) {
            emit(CountryNewsLoaded(news: newsList));
            print(
                'Emitted CountryNewsLoaded state with ${newsList.length} items');
          },
        );
      } catch (e) {
        emit(CountryNewsError(errorMessage: e.toString()));
        print('Emitted CountryNewsError state due to exception: $e');
      }
    });
  }
}
