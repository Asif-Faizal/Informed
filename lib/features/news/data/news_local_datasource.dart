import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_clean/features/news/data/news_model.dart';

import '../../../core/error/failures.dart';

abstract class NewsLocalDatasource {
  Future<NewsModel> getLastNews();
  Future<void> cacheNews(NewsModel newsToCache);
}

class NewsLocalDatasourceImpl implements NewsLocalDatasource {
  final SharedPreferences sharedPreferences;

  NewsLocalDatasourceImpl({required this.sharedPreferences});
  @override
  Future<void> cacheNews(NewsModel newsToCache) {
    throw UnimplementedError();
  }

  @override
  Future<NewsModel> getLastNews() {
    final jsonString = sharedPreferences.getString('CACHED_NEWS');
    if (jsonString != null) {
      return Future.value(NewsModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheFailure('Error');
    }
  }
}
