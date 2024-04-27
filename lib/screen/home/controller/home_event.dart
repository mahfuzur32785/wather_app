part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}
class HomeEventGetData extends HomeEvent {
  final String location;
  final String days;
  const HomeEventGetData({required this.location, required this.days});

  @override
  List<Object> get props => [location,days];
}

class HomeEventLoading extends HomeEvent {
  const HomeEventLoading();
}
