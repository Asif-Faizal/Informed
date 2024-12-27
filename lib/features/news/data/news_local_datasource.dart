import 'package:tdd_clean/features/news/data/news_model.dart';

abstract class NewsLocalDatasource {
  Future<NewsModel> getLastNews();
  Future<void> cacheNews(NewsModel newsToCache);
}