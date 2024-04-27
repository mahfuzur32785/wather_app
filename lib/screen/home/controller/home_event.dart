part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}
class HomeEventGetData extends HomeEvent {
  final String location;
  const HomeEventGetData(this.location);

  @override
  List<Object> get props => [location,];
}

class HomeEventSubmit extends HomeEvent {
  const HomeEventSubmit();
}
