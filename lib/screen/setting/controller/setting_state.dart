part of 'setting_bloc.dart';

abstract class SettingState extends Equatable {
  const SettingState();

  @override
  List<Object> get props => [];
}

class SettingStateInitial extends SettingState {
  const SettingStateInitial();
}

class SettingStateLoading extends SettingState {
  const SettingStateLoading();
}

class SettingStateError extends SettingState {
  final String errorMsg;
  final int statusCode;

  const SettingStateError(this.errorMsg, this.statusCode);

  @override
  List<Object> get props => [errorMsg, statusCode];
}

class SettingStateLoaded extends SettingState {
  final String message;
  const SettingStateLoaded({required this.message});

  @override
  List<Object> get props => [message];
}

class SettingStateSwitchChanged extends SettingState {

  final bool switchStatus;
  const SettingStateSwitchChanged({required this.switchStatus});

  @override
  List<Object> get props => [switchStatus];
}
