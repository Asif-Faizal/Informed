import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tdd_clean/features/news/domain/get_country_news.dart';
import 'package:tdd_clean/features/news/domain/get_query_news.dart';
import 'package:tdd_clean/features/news/domain/news_entity.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetQueryNews getQueryNews;
  final GetCountryNews getCountryNews;

  NewsBloc(this.getQueryNews, this.getCountryNews) : super(NewsInitial()) {
    on<GetQueryNewsEvent>(_onGetQueryNewsEvent);
    on<GetCountryWiseNewsEvent>(_onGetCountryWiseNewsEvent);
  }

  // Event handler for GetQueryNewsEvent
  Future<void> _onGetQueryNewsEvent(GetQueryNewsEvent event, Emitter<NewsState> emit) async {
    emit(QueryNewsLoading()); // Emit loading state first
    
    final result = await getQueryNews(GetQueryNewsParams(query: event.query)); // Call the use case
    
    result.fold(
      (failure) => emit(QueryNewsError(errorMessage: 'Error')), // Emit error if failure
      (newsList) => emit(QueryNewsLoaded(news: newsList)), // Emit loaded state with list if successful
    );
  }

  // Event handler for GetCountryWiseNewsEvent
  Future<void> _onGetCountryWiseNewsEvent(GetCountryWiseNewsEvent event, Emitter<NewsState> emit) async {
    emit(CountryNewsLoading()); // Emit loading state first
    
    final result = await getCountryNews(
      GetCountryNewsParams(country: event.country, category: event.category),
    ); // Call the use case
    
    result.fold(
      (failure) => emit(CountryNewsError(errorMessage: 'Error')), // Emit error if failure
      (newsList) => emit(CountryNewsLoaded(news: newsList)), // Emit loaded state with list if successful
    );
  }
}
