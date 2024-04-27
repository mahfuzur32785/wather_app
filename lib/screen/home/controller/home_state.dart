part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
   @override
  List<Object> get props => [];
}

class HomeStateInitial extends HomeState {
  const HomeStateInitial();
}

class HomeStateLoading extends HomeState {
  const HomeStateLoading();
}

class HomeStateLoaded extends HomeState {
  final WeatherModel weatherModel;
  const HomeStateLoaded(this.weatherModel);

  @override
  List<Object> get props => [weatherModel];
}


class HomeStateError extends HomeState {
  final String errorMsg;

  const HomeStateError(this.errorMsg);

  @override
  List<Object> get props => [errorMsg];
}
