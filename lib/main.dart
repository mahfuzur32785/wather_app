import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watherapp/core/data/datasources/local_data_source.dart';
import 'package:watherapp/core/data/datasources/remote_data_source.dart';
import 'package:watherapp/core/remote_name.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watherapp/screen/home/controller/home_bloc.dart';
import 'package:watherapp/screen/home/ripository/home_repository.dart';

late final SharedPreferences _sharedPreferences;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _sharedPreferences = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        ///network client
        RepositoryProvider<Client>(
          create: (context) => Client(),
        ),
        RepositoryProvider<SharedPreferences>(
          create: (context) => _sharedPreferences,
        ),

        ///data source repository
        RepositoryProvider<RemoteDataSource>(
          create: (context) => RemoteDataSourceImpl(client: context.read()),
        ),
        RepositoryProvider<LocalDataSource>(
          create: (context) =>
              LocalDataSourceImpl(sharedPreferences: context.read()),
        ),

        ///Main Functionality
        RepositoryProvider<HomeRepository>(
          create: (context) => HomeRepositoryImp(
            remoteDataSource: context.read(),
            localDataSource: context.read(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<HomeBloc>(
            create: (BuildContext context) => HomeBloc(
              homeRepository: context.read(),
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(),
          onGenerateRoute: RouteNames.generateRoute,
          initialRoute: RouteNames.homePage,
          onUnknownRoute: (RouteSettings settings) {
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
            );
          },
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: child!,
            );
          },
        ),
      ),
    );
  }
}
