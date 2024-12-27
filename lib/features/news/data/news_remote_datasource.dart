import 'package:tdd_clean/features/news/data/news_model.dart';

abstract class NewsRemoteDatasource {
  // calls API [https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=d26344a4cc7045a895af69f018609a64]
  Future<NewsModel> getQueryNews(String query);
  // calls API [https://newsapi.org/v2/everything?q=apple&sortBy=publishedAt&apiKey=d26344a4cc7045a895af69f018609a64]
  Future<NewsModel> getCountryNews(String country, String category);
}
