import 'dart:convert';

import 'package:tdd_clean/features/news/data/news_model.dart';
import 'package:http/http.dart' as http;

import '../../../core/error/exceptions.dart';

abstract class NewsRemoteDatasource {
  // calls API [https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=API_KEY]
  Future<NewsModel> getQueryNews(String query);
  // calls API [https://newsapi.org/v2/everything?q=apple&sortBy=publishedAt&apiKey=API_KEY]
  Future<NewsModel> getCountryNews(String country, String category);
}

class NewsRemoteDatasourceImpl implements NewsRemoteDatasource {
  final http.Client client;

  NewsRemoteDatasourceImpl({required this.client});

  @override
  Future<NewsModel> getCountryNews(String country, String category) {
    throw UnimplementedError();
  }

  @override
  Future<NewsModel> getQueryNews(String query) async {
    final response = await client.get(
      Uri.parse(
        "https://newsapi.org/v2/everything?q=$query&sortBy=publishedAt&apiKey=d26344a4cc7045a895af69f018609a64",
      ),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return NewsModel.fromJson(json.decode(response.body));
    } else {
    throw ServerException('Error');
  }
  }
}
