part of 'setting_bloc.dart';

abstract class SettingEvent extends Equatable {
  const SettingEvent();

  @override
  List<Object> get props => [];
}

class SettingEventLocation extends SettingEvent {
  final String location;
  const SettingEventLocation(this.location);

  @override
  List<Object> get props => [location];
}

class SettingEventSwitchStatus extends SettingEvent {
  final bool switchValue;
  const SettingEventSwitchStatus(this.switchValue);

  @override
  List<Object> get props => [switchValue];
}
