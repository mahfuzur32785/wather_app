import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:watherapp/screen/setting/controller/setting_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:watherapp/screen/setting/model/location_model.dart';
import 'package:watherapp/widget/custom_switch.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade600,
      appBar: AppBar(
        title: const Text("Setting"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey.shade600,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Add new Location",style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),),
            SizedBox(height: 5),
            TypeAheadFormField(
              textFieldConfiguration: TextFieldConfiguration(
                  controller: context.read<SettingBloc>().locationController,
                  cursorColor: Colors.white,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                      hintText: 'Search Location',
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                  )),
              suggestionsCallback: (pattern) async {
                await getPlaces(pattern);
                return placesSearchResult
                    .where((element) => element.description!
                    .toLowerCase()
                    .contains(
                    pattern.toString().toLowerCase()))
                    // .take(10)
                    .toList();
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text("${suggestion.description}"),
                );
              },
              noItemsFoundBuilder: (context) {
                return const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("Location not found!",textAlign: TextAlign.center,style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  ),),
                );
              },
              transitionBuilder:
                  (context, suggestionsBox, controller) {
                return suggestionsBox;
              },
              onSuggestionSelected: (Prediction suggestion) async {
                context.read<SettingBloc>().locationController.text = suggestion.description.toString().trim()/*.substring(0, suggestion.description.toString().trim().indexOf(','))*/;
                print("Final value ${suggestion.description.toString().trim()/*.substring(0, suggestion.description.toString().trim().indexOf(','))*/}");
                context.read<SettingBloc>().add(SettingEventLocation(suggestion.description.toString().trim()/*.substring(0, suggestion.description.toString().trim().indexOf(','))*/));
                final location = await getLocation(suggestion.description.toString().trim()/*.substring(0, suggestion.description.toString().trim().indexOf(','))*/, 'locality', "AIzaSyCGYnCh2Uusd7iASDhsUCxvbFgkSifkkTM");
            
                // print('Lat & Lang is: ${double.parse(location['lat']).toDouble().toStringAsFixed(2)}, ${double.parse(location['lng']).toDouble().toStringAsFixed(2)}');
                print('Lat & Lang is: ${location.results?[0].geometry?.location?.lat?.toStringAsFixed(2)}, ${location.results?[0].geometry?.location?.lng?.toStringAsFixed(2)}');
                Navigator.pop(context,"${location.results?[0].geometry?.location?.lat?.toStringAsFixed(2)}, ${location.results?[0].geometry?.location?.lng?.toStringAsFixed(2)}");
              },
              validator: (value) {
                if (value == '') {
                  return 'Please enter your Location';
                } else {
                  return null;
                }
              },
              onSaved: (value) {},
            ),
            const SizedBox(height: 20),
            
            const Text("Temperature Unit",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
            const SizedBox(height: 5),

            BlocBuilder<SettingBloc, SettingState>(
              buildWhen: (previous, current) => previous != current,
              builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CustomSwitch(
                    height: 30,
                    showOnOff: true,
                    activeTextColor: Colors.black,
                    inactiveTextColor: Colors.blue[50]!,
                    value: context.read<SettingBloc>().switchStatus,
                    onToggle: (val) {
                      context.read<SettingBloc>().switchStatus = val;
                      context.read<SettingBloc>().add(SettingEventSwitchStatus(val));
                      print("ajkfj $val");
                    },
                  ),
                ],
              );
            },)
          ],
        ),
      ),
      
    );
  }

  ///......... Location search ................
  List<Prediction> placesSearchResult = [];
  static const kGoogleApiKey = "AIzaSyCGYnCh2Uusd7iASDhsUCxvbFgkSifkkTM";
  final places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  late PlacesSearchResponse response;

  Future<List<Prediction>> getPlaces(text) async {
    await places
        .autocomplete(text,
        // types: ['establishment'],
        //types: ['address'],
        // types: ['locality'],
        // components: [Component(Component.country, countryCode.toString())],
        // radius: 1000,
    )
        .then((value) {
      placesSearchResult = value.predictions;
      if (value.predictions.isNotEmpty) {
        placesSearchResult = value.predictions;
      }
    });

    return placesSearchResult;
  }

  Future<LocationModel> getLocation(String query, String placeType, String apiKey) async {
    final url = Uri.https('maps.googleapis.com', '/maps/api/place/textsearch/json', {
      'query': query,
      'type': placeType,
      'key': apiKey,
    });
    final response = await http.get(url);
    final body = json.decode(response.body);
    // return body['results'][0]['geometry']['location'];
    return LocationModel.fromJson(body);
  }

}
