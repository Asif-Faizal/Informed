import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/connection/network_info.dart';
import 'features/news/bloc/news_bloc.dart';
import 'features/news/data/news_local_datasource.dart';
import 'features/news/data/news_remote_datasource.dart';
import 'features/news/data/news_repo_impl.dart';
import 'features/news/domain/get_country_news.dart';
import 'features/news/domain/get_query_news.dart';
import 'features/news/presentation/screen/home_screen.dart';
import 'core/injection/dependency_injection.dart' as di;
import 'package:http/http.dart'as http;

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initDependencies();
  Bloc.observer = SimpleBlocObserver();
  runApp(const MyApp());
}
// Add this in your main.dart before runApp()
class SimpleBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print('onCreate -- bloc: ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('onChange -- bloc: ${bloc.runtimeType}, change: $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('onError -- bloc: ${bloc.runtimeType}, error: $error');
    super.onError(bloc, error, stackTrace);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final sharedPreferences = snapshot.data!;
            return BlocProvider(
              create: (context) => NewsBloc(
                getQueryNews: GetQueryNews(NewsRepoImpl(
                  newsRemoteDatasource: NewsRemoteDatasourceImpl(client: http.Client()),
                  newsLocalDatasource: NewsLocalDatasourceImpl(sharedPreferences: sharedPreferences),
                  networkInfo: NetworkInfoImpl(connectivity: Connectivity())
                )),
                getCountryNews: GetCountryNews(NewsRepoImpl(
                  newsRemoteDatasource: NewsRemoteDatasourceImpl(client: http.Client()),
                  newsLocalDatasource: NewsLocalDatasourceImpl(sharedPreferences: sharedPreferences),
                  networkInfo: NetworkInfoImpl(connectivity: Connectivity())
                )),
              ),
              child: const HomeScreen(),
            );
          }
          return const Center(child: Text('Error initializing app'));
        },
      ),
    );
  }
}