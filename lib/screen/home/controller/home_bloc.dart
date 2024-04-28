import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    emit(const HomeStateLoading());
    final uri = Uri.parse(RemoteUrls.getForecastData).replace(
      queryParameters: {
        'q': event.location,
        'days': event.days,
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

  Future<bool> onBackPressed(BuildContext context) async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        title: const Text(
          'Are you sure you want to close application?',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text(
              'No',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ),
          TextButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: const Text(
              'Yes',
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    )) ??
        false;
  }

}
