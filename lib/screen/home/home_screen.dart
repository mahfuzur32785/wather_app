import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:watherapp/core/utils/utils.dart';
import 'package:watherapp/screen/home/controller/home_bloc.dart';
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
      body: RefreshIndicator(
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
            /*if (state is HomeStateLoading) {
              return SizedBox(
                height: MediaQuery.of(context).size.width * 0.3,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            else */
            if (state is HomeStateError) {
              return SizedBox(
                height: MediaQuery.of(context).size.width * 0.3,
                child: Center(
                  child: Text(
                    state.errorMsg,
                    style: const TextStyle(),
                  ),
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
                        padding: EdgeInsets.symmetric(horizontal: 20),
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
                                        .country!
                                        .isNotEmpty
                                        ? "${context.read<HomeBloc>().weatherModel?.location?.country}"
                                        : "Current",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                        color: Colors.white),
                                  ),
                                  Icon(
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
                                    onTap: () {},
                                    child: const Icon(Icons.settings,
                                        color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
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
                                CustomImage(path:"https:${state.weatherModel.current?.condition?.icon}",height: 80,),

                                Text(
                                  "${state.weatherModel.current?.tempC?.toStringAsFixed(0)}\u00B0 C",
                                  style: TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                            Text(
                              "${state.weatherModel.current?.condition?.text} - Wind Speed: ${state.weatherModel.current?.windKph} kph / Humidity: ${state.weatherModel.current?.humidity}",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 50,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: const Text(
                          "Forecast",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SliverList(delegate: SliverChildBuilderDelegate((context, index){
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(child: Center(child: Text(Utils.formatDateByMoth(state.weatherModel.forecast?.forecastday?[index].date),style: TextStyle(color: Colors.white),))),
                            Expanded(child: Center(child: Text(Utils.formatDateByDayName(state.weatherModel.forecast?.forecastday?[index].date),style: TextStyle(color: Colors.white),))),
                            // Image.network("https:${state.weatherModel.forecast?.forecastday?[index].day?.condition?.icon}",height: 30,),
                            Expanded(child: CustomImage(path:"https:${state.weatherModel.forecast?.forecastday?[index].day?.condition?.icon}",height: 30,)),
                            Expanded(child: Center(child: Text("${state.weatherModel.forecast?.forecastday?[index].day?.avgtempC}\u00B0 C",style: TextStyle(color: Colors.white),))),
                          ],
                        ),
                      );
                    },childCount: state.weatherModel.forecast!.forecastday!.length))
                  ])
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
