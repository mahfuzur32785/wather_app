import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watherapp/core/remote_url.dart';
import 'package:watherapp/screen/home/model/wather_model.dart';
import 'package:watherapp/screen/home/ripository/home_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;

  HomeBloc({required HomeRepository homeRepository})
      : _homeRepository = homeRepository,
        super(const HomeStateInitial()) {
    on<HomeEventGetData>(_getData);
    // on<SearchAdsEventLoadMore>(_loadMore);
  }

  WeatherModel? weatherModel;

  void _getData(
      HomeEventGetData event, Emitter<HomeState> emit) async {

    weatherModel = null;
    emit(const HomeStateLoading());
    final uri = Uri.parse(RemoteUrls.getForecastData).replace(
      queryParameters: {
        'q': event.location,
        'key': "2e48f700fd434f80b9d140128242604",
      },
    );
    final result = await _homeRepository.getWeather(uri);

    result.fold((failure) {
      emit(HomeStateError(failure.message));
    }, (successData) {
      weatherModel = successData;
      emit(HomeStateLoaded(successData));
    });
  }

}
