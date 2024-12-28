import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_clean/features/news/data/news_local_datasource.dart';
import 'package:tdd_clean/features/news/data/news_remote_datasource.dart';
import 'package:tdd_clean/features/news/data/news_repo_impl.dart';
import 'package:tdd_clean/features/news/domain/news_repo.dart';
import 'package:tdd_clean/features/news/bloc/news_bloc.dart';
import 'package:tdd_clean/features/news/domain/get_query_news.dart';
import 'package:tdd_clean/features/news/domain/get_country_news.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import '../connection/network_info.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Register the Bloc
  sl.registerFactory(() => NewsBloc(getQueryNews:  sl(),getCountryNews:  sl()));
  
  // Register use cases
  sl.registerLazySingleton(() => GetQueryNews(sl()));
  sl.registerLazySingleton(() => GetCountryNews(sl()));
  
  // Register repository with dependencies
  sl.registerLazySingleton<NewsRepo>(() => NewsRepoImpl(
    newsRemoteDatasource: sl(),
    newsLocalDatasource: sl(),
    networkInfo: sl(),
  ));
  
  // Register the data sources
  sl.registerLazySingleton<NewsRemoteDatasource>(() => NewsRemoteDatasourceImpl(client: sl()));
  
  // Register NewsLocalDatasource with async SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<NewsLocalDatasource>(() => NewsLocalDatasourceImpl(sharedPreferences: sharedPreferences));
  
  // Register network info
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(connectivity: sl()));
  
  // Register SharedPreferences (if needed)
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  
  // Register other dependencies
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());
}
