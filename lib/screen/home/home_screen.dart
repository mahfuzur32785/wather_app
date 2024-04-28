import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:watherapp/core/remote_name.dart';
import 'package:watherapp/core/utils/utils.dart';
import 'package:watherapp/screen/home/controller/home_bloc.dart';
import 'package:watherapp/screen/setting/component/card_view.dart';
import 'package:watherapp/screen/setting/controller/setting_bloc.dart';
import 'package:watherapp/screen/setting/setting_screen.dart';
import 'package:watherapp/widget/csutom_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Future<void> _checkPermission(Permission permission) async {
  //   final status = await permission.request();
  //   if (status == PermissionStatus.granted) {
  //     print('Permission granted');
  //     _getCurrentLocation();
  //   } else if (status == PermissionStatus.denied) {
  //     print('Permission denied. Show a dialog and again ask for the permission');
  //     Utils.errorSnackBar(context, "Location permission is required");
  //   } else if (status == PermissionStatus.permanentlyDenied) {
  //     print('Take the user to the settings page.');
  //     Utils.errorSnackBar(context, "Location permission is required");
  //     openAppSettings();
  //   }
  // }
  //
  // void _getCurrentLocation() async {
  //   try {
  //     await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((value){
  //       print("vsdgsgs ${value.latitude}, ${value.longitude}");
  //       Future.microtask(() => context.read<HomeBloc>().add(HomeEventGetData("${value.latitude}, ${value.longitude}")));
  //     });
  //
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Utils.errorSnackBar(context, "Location services are disabled.");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Utils.errorSnackBar(context, "Location permission is required");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Utils.errorSnackBar(context, "Location permission is required");
      openAppSettings();
    }

    await Geolocator.getCurrentPosition().then((value) {
      if (value.longitude != null && value.longitude != null) {
        Future.microtask(() => context.read<HomeBloc>().add(HomeEventGetData(
            location: "${value.latitude}, ${value.longitude}", days: "3")));
      } else {
        Future.microtask(() => context
            .read<HomeBloc>()
            .add(const HomeEventGetData(location: "", days: "")));
      }
    });
  }

  @override
  void initState() {
    _determinePosition();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade600,
      body: WillPopScope(
        onWillPop: () {
          return context.read<HomeBloc>().onBackPressed(context);
        },
        child: RefreshIndicator(
          onRefresh: () async {
            _determinePosition();
            // return context.read<HomeBloc>().add(HomeEventGetData("Bangladesh"));
          },
          child: BlocConsumer<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state is HomeStateError) {
                Utils.errorSnackBar(context, state.errorMsg);
              }
            },
            builder: (context, state) {
              if (state is HomeStateLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              } else if (state is HomeStateError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        state.errorMsg,
                        style: const TextStyle(
                          color: Colors.white
                        ),
                      ),
                      IconButton(onPressed: () {
                        _determinePosition();
                      }, icon: Icon(Icons.refresh,color: Colors.white,))
                    ],
                  ),
                );
              } else if (state is HomeStateLoaded) {
                return CustomScrollView(
                  slivers: [
                    MultiSliver(children: [
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        backgroundColor: Colors.grey.shade600,
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      context
                                              .read<HomeBloc>()
                                              .weatherModel!
                                              .location!
                                              .name!
                                              .isNotEmpty
                                          ? "${context.read<HomeBloc>().weatherModel?.location?.name}"
                                          : "Current",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                          color: Colors.white),
                                    ),
                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.white,
                                      size: 15,
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                      onTap: () {
                                        // Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen()));
                                        Navigator.pushNamed(
                                                context, RouteNames.settingPage)
                                            .then((value) {
                                          print("jfjhdkjasfh $value");
                                          if (value != null) {
                                            context.read<SettingBloc>().locationController.clear();
                                            Future.microtask(() => context
                                                .read<HomeBloc>()
                                                .add(HomeEventGetData(
                                                    location: value.toString(),
                                                    days: "3")));
                                          }
                                        });
                                      },
                                      child: const Icon(Icons.settings,
                                          color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 50,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomImage(
                                    path:
                                        "https:${state.weatherModel.current?.condition?.icon}",
                                    height: 80,
                                  ),
                                  BlocBuilder<SettingBloc, SettingState>(
                                    buildWhen: (previous, current) =>
                                        previous != current,
                                    builder: (context, state) {
                                      return Text(
                                        context.read<SettingBloc>().switchStatus
                                            ? "${context.read<HomeBloc>().weatherModel?.current?.tempF?.toStringAsFixed(0)}\u00B0 F"
                                            : "${context.read<HomeBloc>().weatherModel?.current?.tempC?.toStringAsFixed(0)}\u00B0 C",
                                        style: const TextStyle(
                                            fontSize: 50,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      );
                                    },
                                  )
                                ],
                              ),
                              Text(
                                "${state.weatherModel.current?.condition?.text} - Wind Speed: ${state.weatherModel.current?.windKph} kph / Humidity: ${state.weatherModel.current?.humidity}",
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 50,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: const Text(
                            "Forecast",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Center(
                                          child: Text(
                                    Utils.formatDateByMoth(state.weatherModel
                                        .forecast?.forecastday?[index].date),
                                    style: const TextStyle(color: Colors.white),
                                  ))),
                                  Expanded(
                                      child: Center(
                                          child: Text(
                                    Utils.formatDateByDayName(state.weatherModel
                                        .forecast?.forecastday?[index].date),
                                    style: const TextStyle(color: Colors.white),
                                  ))),
                                  Expanded(
                                      child: CustomImage(
                                    path:
                                        "https:${state.weatherModel.forecast?.forecastday?[index].day?.condition?.icon}",
                                    height: 30,
                                  )),
                                  Expanded(
                                      child: Center(
                                          child: Text(
                                    "${state.weatherModel.forecast?.forecastday?[index].day?.avgtempC}\u00B0 C",
                                    style: const TextStyle(color: Colors.white),
                                  ))),
                                ],
                              ),
                            );
                          },
                          childCount:
                              state.weatherModel.forecast!.forecastday!.length,
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 20),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.all(16),
                        sliver: SliverGrid.count(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.9,
                          children: [
                            CardView(title: "UV",value: "${state.weatherModel.current?.uv}",image: "https://cdn-icons-png.flaticon.com/128/606/606795.png",),
                            CardView(title: "Feels like",value: "${state.weatherModel.current?.feelslikeC}\u00B0 C",image: "https://cdn-icons-png.flaticon.com/128/13844/13844141.png",),
                            CardView(title: "Humidity",value: "${state.weatherModel.current?.humidity} %",image: "https://cdn-icons-png.flaticon.com/128/5664/5664979.png",),
                            CardView(title: "SSW Wind",value: "${state.weatherModel.current?.windKph} kph",image: "https://cdn-icons-png.flaticon.com/128/11742/11742598.png",),
                            CardView(title: "Air Pressure",value: "${state.weatherModel.current?.pressureMb} kph",image: "https://cdn-icons-png.flaticon.com/128/2412/2412655.png",),
                            CardView(title: "Visibility",value: "${state.weatherModel.current?.visKm} kph",image: "https://cdn-icons-png.flaticon.com/128/6339/6339415.png",),
                          ],
                        ),
                      )
                    ])
                  ],
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
