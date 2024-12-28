import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_clean/features/news/data/news_model.dart';

import '../../../core/error/failures.dart';

abstract class NewsLocalDatasource {
  Future<List<NewsModel>> getLastNews();
  Future<void> cacheNews(List<NewsModel> newsToCache);
}

class NewsLocalDatasourceImpl implements NewsLocalDatasource {
  final SharedPreferences sharedPreferences;

  static const CACHED_NEWS_KEY = 'CACHED_NEWS';

  NewsLocalDatasourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheNews(List<NewsModel> newsToCache) async {
    // Convert the list of NewsModel to a JSON-encoded string
    final List<Map<String, dynamic>> jsonList =
        newsToCache.map((news) => news.toJson()).toList();
        print('#################################################');
        print(jsonList);
    await sharedPreferences.setString(
      CACHED_NEWS_KEY,
      json.encode(jsonList),
    );
  }

  @override
  Future<List<NewsModel>> getLastNews() {
    final jsonString = sharedPreferences.getString(CACHED_NEWS_KEY);
    if (jsonString != null) {
      try {
        // Decode JSON and map it to a List<NewsModel>
        final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
        final List<NewsModel> newsList = jsonList
            .map((jsonItem) => NewsModel.fromJson(jsonItem as Map<String, dynamic>))
            .toList();
        print('#################################################');
        print(newsList);
        return Future.value(newsList);
      } catch (e) {
        throw CacheFailure('Error parsing cached news');
      }
    } else {
      throw CacheFailure('No cached news found');
    }
  }
}
