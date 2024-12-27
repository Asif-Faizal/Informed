import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_clean/features/news/data/news_local_datasource.dart';
import 'package:tdd_clean/features/news/data/news_remote_datasource.dart';
import 'package:tdd_clean/features/news/data/news_repo_impl.dart';
import 'package:tdd_clean/features/news/domain/news_repo.dart';

import '../../features/news/bloc/news_bloc.dart';
import '../../features/news/domain/get_country_news.dart';
import '../../features/news/domain/get_query_news.dart';
import '../connection/network_info.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> initDependencies()async {
  sl.registerFactory(() => NewsBloc(sl(), sl()));
  sl.registerLazySingleton(() => GetQueryNews(sl()));
  sl.registerLazySingleton(() => GetCountryNews(sl()));
  sl.registerLazySingleton<NewsRepo>(() => NewsRepoImpl(
      newsRemoteDatasource: sl(),
      newsLocalDatasource: sl(),
      networkInfo: sl()));
  sl.registerLazySingleton<NewsRemoteDatasource>(
      () => NewsRemoteDatasourceImpl(client: sl()));
  sl.registerLazySingleton<NewsLocalDatasource>(
      () => NewsLocalDatasourceImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(connectivity: sl()));
  sl.registerLazySingleton<Future<SharedPreferences>>(
      () async => await SharedPreferences.getInstance());
  sl.registerLazySingleton(()=>http.Client());
  sl.registerLazySingleton(()=>Connectivity());
}
