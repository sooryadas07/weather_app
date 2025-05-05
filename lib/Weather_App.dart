import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:lottie/lottie.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/model/gridview_model.dart';
import 'package:weather_app/model/list_mmodel.dart';
import 'package:weather_app/weather_data_model.dart';
import 'package:weather_app/widgets/gridview_widgets.dart';
import 'package:weather_app/widgets/weather_celsius_widgets.dart';
import 'model/list_mmodel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  Dio dio = Dio();
  GetWeatherModel? responseModel;
  String? _currentAddress;
  Position? _currentPosition;
  bool isLoading = true;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() => _currentPosition = position);
      await _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
    getWeather();
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress = '${place.subLocality}, ${place.locality}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  getWeather() async {
    final lat = _currentPosition!.latitude;
    final log = _currentPosition!.longitude;


    final response = await dio.get(
      'https://api.tomorrow.io/v4/weather/forecast?location=$lat,$log &apikey=6F0hjCQbbNMXRIjp9cJKxQ9SWIdcKqoB',
    );
    responseModel = GetWeatherModel.fromJson(response.data);
    // print(responseModel);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    _getCurrentPosition();
    // TODO: implement initState
    super.initState();
  }

  final List<ModelWeather> weather = [
    ModelWeather(
        time: "Now", image: "assets/images/clear-sky.png", celsius: "33°"),
    ModelWeather(
        time: "05:45", image: "assets/images/clear-sky.png", celsius: "29°"),
    ModelWeather(image: "assets/images/moon.png", celsius: "23°", time: '6:00'),
    ModelWeather(
        time: "6:37", image: "assets/images/clear-sky.png", celsius: "33°"),
    ModelWeather(
        time: "07:45", image: "assets/images/moon.png", celsius: "29°"),
    ModelWeather(
        time: "8:37", image: "assets/images/clear-sky.png", celsius: "33°"),

  ];
  final List<GridviewWidgets> weathergrid = [
    const GridviewWidgets(
        title: "UV INDEX",
        text: "55",
        image: "assets/images/moon.png",
        icon: Icons.sunny),
    const GridviewWidgets(
      title: "SUN SET",
      text: "86",
      image: "assets/images/moon.png",
      icon: Icons.thermostat,
    ),
    const GridviewWidgets(
      title: "WIND",
      text: "56",
      image: "assets/images/moon.png",
      icon: Icons.hotel_class,
    ),
    const GridviewWidgets(
      title: "FEEL LIKE",
      text: "65",
      image: "assets/images/moon.png",
      icon: Icons.shield_moon_sharp,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body:isLoading?const Center(child: CircularProgressIndicator(),): Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/winter2.jpg"),
                fit: BoxFit.cover),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(right: 100, left: 120, top: 50),
                  child: Lottie.asset(
                    "assets/lottie/weather animation.json",
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      ' ${_currentAddress ?? ""}',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    IconButton(
                      onPressed: _getCurrentPosition,
                      icon: Icon(Icons.refresh),
                      color: Colors.white,
                    ),
                  ],
                ),
                SizedBox(),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text('LAT: ${_currentPosition?.latitude ?? ""}',
                    //   style: TextStyle(color: Colors.white),),
                    // Text('LNG: ${_currentPosition?.longitude ?? ""}',
                    //   style: TextStyle(color: Colors.white),),
                    // Text('ADDRESS: ${_currentAddress ?? ""}',
                    //   style: TextStyle(color: Colors.white),),
                    SizedBox(),
                    // ElevatedButton(
                    //   onPressed: _getCurrentPosition,
                    //   child: const Text("Get Current Location"),
                    // )
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 130),
                      child: Text(
                        responseModel
                                ?.timelines?.daily?[0].values?.temperatureAvg
                                ?.round()
                                .toString() ??
                            "",
                        style: TextStyle(
                            fontSize: 100,
                            color: Colors.white,
                            fontWeight: FontWeight.w100),
                      ),
                    ),
                    Text(
                      "°c",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 70,
                          fontWeight: FontWeight.w100),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "Partly Cloudy",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                // Text(
                //   'LAT: ${_currentPosition?.latitude ?? ""}',
                //   style: TextStyle(color: Colors.white),
                // ),
                // Text(
                //   'LNG: ${_currentPosition?.longitude ?? ""}',
                //   style: TextStyle(color: Colors.white),
                // ),
                Container(
                    child: Card(
                  color: Colors.transparent,
                  surfaceTintColor: Colors.yellowAccent,
                  child: SizedBox(
                    height: 130,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      itemCount: weather.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15,left: 15),
                            child: WeatherCelsiusWidgets(
                                time: index == 0
                                    ? responseModel!.timelines!.daily![0].time!.day
                                        .round()
                                        .toString()
                                    : index == 1
                                        ? responseModel!.timelines!.daily![1].time!.day
                                            .round()
                                            .toString()
                                        : index == 2
                                            ? responseModel!.timelines!.daily![2].time!.day
                                                .round()
                                                .toString()
                                            : index == 3
                                                ? responseModel!.timelines!.daily![3].time!.day
                                                    .round()
                                                    .toString()
                                                : index == 4
                                                    ? responseModel!.timelines!
                                                        .daily![4].time!.day
                                                        .round()
                                                        .toString()
                                                    : responseModel!.timelines!
                                                            .daily![5].time!.day
                                                            .round()
                                                            .toString() ??
                                                        "",
                                image: AssetImage(weather[index].image),
                                celsius: index == 0
                                    ? responseModel!.timelines!.daily![0].values!.temperatureAvg!
                                        .round()
                                        .toString()
                                    : index == 1
                                        ? responseModel!.timelines!.daily![1]
                                            .values!.temperatureAvg!
                                            .round()
                                            .toString()
                                        : index == 2
                                            ? responseModel!.timelines!.daily![2]
                                                .values!.temperatureAvg!
                                                .round()
                                                .toString()
                                            : index == 3
                                                ? responseModel!
                                                    .timelines!
                                                    .daily![3]
                                                    .values!
                                                    .temperatureAvg!
                                                    .round()
                                                    .toString()
                                                : index == 4
                                                    ? responseModel!
                                                        .timelines!
                                                        .daily![4]
                                                        .values!
                                                        .temperatureAvg!
                                                        .round()
                                                        .toString()
                                                    :
                                                         responseModel!.timelines!.daily![5].values!.temperatureAvg!.round().toString()??""


                               ),
                          ),
                        );
                      },
                    ),
                  ),
                )),
                GridView.count(physics: const ScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  shrinkWrap: true,
                  children: List.generate(
                    weathergrid.length,
                    (index) {
                      return Center(
                        child: GridviewWidgets(
                          title: weathergrid[index].title,
                          text: index == 0
                              ? responseModel!
                                  .timelines!.daily![0].values!.uvIndexAvg!
                                  .round()
                                  .toString()
                              : index == 1
                                  ? DateFormat('HH:mm').format(DateTime.parse(responseModel!
                              .timelines!.daily![0].values!.sunsetTime!
                              .toString()))
                                  : index == 2
                                      ? responseModel!.timelines!.daily![0]
                                          .values!.windSpeedAvg
                                          ?.toString()
                                      : responseModel!.timelines!.daily![0]
                                              .values?.temperatureAvg
                                              ?.toString() ??
                                          "",
                          icon: weathergrid[index].icon,
                          image: weathergrid[index].image,
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
