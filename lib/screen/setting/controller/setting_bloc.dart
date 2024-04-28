import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {

  var locationController = TextEditingController(text: "");

  bool switchStatus = false;

  SettingBloc() : super(const SettingStateInitial()) {

    on<SettingEventLocation>((event, emit) {
      locationController.text = event.location;
      // emit(state.copyWith(location: event.location));
    });
    on<SettingEventSwitchStatus>((event, emit) {
      switchStatus = event.switchValue;
      print("sdfghjkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk ${event.switchValue}");
      print("sdfghjkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk $switchStatus");
      emit(SettingStateSwitchChanged(switchStatus: event.switchValue));
      // emit(state.copyWith(location: event.location));
    });

  }


}
