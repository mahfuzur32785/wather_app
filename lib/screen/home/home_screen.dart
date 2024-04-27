import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:watherapp/core/utils/utils.dart';
import 'package:watherapp/screen/home/controller/home_bloc.dart';
import 'package:watherapp/widget/csutom_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future<void> _checkPermission(Permission permission) async {
    final status = await permission.request();
    if (status == PermissionStatus.granted) {
      print('Permission granted');
      Future.microtask(() => context.read<HomeBloc>().add(HomeEventGetData("Bangladesh")));
    } else if (status == PermissionStatus.denied) {
      print('Permission denied. Show a dialog and again ask for the permission');
      Utils.errorSnackBar(context, "Location permission is required");
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Take the user to the settings page.');
      Utils.errorSnackBar(context, "Location permission is required");
      openAppSettings();
    }
  }

  @override
  void initState() {
    _checkPermission(Permission.location);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade600,
      body: RefreshIndicator(
        onRefresh: () async {
          return context.read<HomeBloc>().add(HomeEventGetData("Bangladesh"));
        },
        child: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is HomeStateError) {
              Utils.errorSnackBar(context, state.errorMsg);
            }
          },
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.grey.shade600,
                  foregroundColor: Colors.white,
                  centerTitle: true,
                  scrolledUnderElevation: 0,
                  leadingWidth: MediaQuery.of(context).size.width * 0.5,
                  leading: const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Current",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Icon(
                          Icons.location_on,
                          size: 15,
                        )
                      ],
                    ),
                  ),
                  floating: true,
                  snap: true,
                  pinned: false,
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: GestureDetector(
                          onTap: () {}, child: const Icon(Icons.settings)),
                    )
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
