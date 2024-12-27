import 'package:tdd_clean/features/news/data/news_model.dart';

abstract class NewsRemoteDatasource {
  // calls API [https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=API_KEY]
  Future<NewsModel> getQueryNews(String query);
  // calls API [https://newsapi.org/v2/everything?q=apple&sortBy=publishedAt&apiKey=API_KEY]
  Future<NewsModel> getCountryNews(String country, String category);
}
