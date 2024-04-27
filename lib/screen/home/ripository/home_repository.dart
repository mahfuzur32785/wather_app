import 'package:dartz/dartz.dart';
import 'package:watherapp/core/data/datasources/local_data_source.dart';
import 'package:watherapp/core/error/exceptions.dart';
import 'package:watherapp/core/error/failures.dart';
import 'package:watherapp/screen/home/model/wather_model.dart';

import '../../../../core/data/datasources/remote_data_source.dart';


abstract class HomeRepository {
  Future<Either<Failure, WeatherModel>> getWeather(Uri uri);
}

class HomeRepositoryImp extends HomeRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  HomeRepositoryImp({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, WeatherModel>> getWeather(Uri uri) async {
    try {
      final result = await remoteDataSource.getWeatherData(uri);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

}
