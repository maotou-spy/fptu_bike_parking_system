import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fptu_bike_parking_system/api/model/weather/weather.dart';
import 'package:fptu_bike_parking_system/core/helper/asset_helper.dart';
import 'package:fptu_bike_parking_system/representation/fundin_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../api/service/weather/open_weather_api.dart';

class HomeAppScreen extends StatefulWidget {
  const HomeAppScreen({super.key});

  static String routeName = '/home_screen';

  @override
  State<HomeAppScreen> createState() => _HomeAppScreenState();
}

class _HomeAppScreenState extends State<HomeAppScreen> {
  var log = Logger();

  //default location: FPT University HCM Hi-tech park Campus
  double lat = 10.8411276;
  double lon = 106.809883;
  WeatherData? weatherData;
  String visibility = "null";
  String aqi = "null";

  Future getLocation() async {
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      lat = position.latitude;
      lon = position.longitude;
    });
    log.i('Latitude: $lat/nLongitude: $lon');
  }

  //get data from API
  void getWeather() async {
    await getLocation();
    weatherData = await OpenWeatherApi.fetchWeather(lat, lon);
    visibility = (weatherData!.visibility / 1000).toStringAsFixed(2);
    aqi = await OpenWeatherApi.fetchAirQuality(lat, lon);
    setState(() {
      weatherData = weatherData;
      visibility = visibility;
      aqi = aqi;
      log.i('Visibility: $visibility km');
    });
    log.i('Weather: ${weatherData!.weather[0].main}');
  }

  @override
  void initState() {
    super.initState();
    getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(bottom: 130),
                  child: ImageSlideshow(
                    indicatorColor: Theme.of(context).colorScheme.secondary,
                    indicatorBottomPadding: 45,
                    indicatorRadius: 4,
                    indicatorBackgroundColor:
                        Theme.of(context).colorScheme.primary,
                    initialPage: 0,
                    indicatorPadding: 5,
                    autoPlayInterval: 5000,
                    isLoop: true,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const FullScreenImageDialog(
                                imagePath: AssetHelper.banner1,
                              );
                            },
                          );
                        },
                        child: const ClipRRect(
                          child: Image(
                            width: double.infinity,
                            image: AssetImage(
                              AssetHelper.banner1,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const FullScreenImageDialog(
                                imagePath: AssetHelper.banner2,
                              );
                            },
                          );
                        },
                        child: const ClipRRect(
                          child: Image(
                            width: double.infinity,
                            image: AssetImage(
                              AssetHelper.banner2,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const FullScreenImageDialog(
                                imagePath: AssetHelper.banner3,
                              );
                            },
                          );
                        },
                        child: const ClipRRect(
                          child: Image(
                            width: double.infinity,
                            image: AssetImage(
                              AssetHelper.banner3,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const FullScreenImageDialog(
                                imagePath: AssetHelper.banner4,
                              );
                            },
                          );
                        },
                        child: const ClipRRect(
                          child: Image(
                            width: double.infinity,
                            image: AssetImage(
                              AssetHelper.banner4,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const FullScreenImageDialog(
                                imagePath: AssetHelper.banner5,
                              );
                            },
                          );
                        },
                        child: const ClipRRect(
                          child: Image(
                            width: double.infinity,
                            image: AssetImage(
                              AssetHelper.banner5,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                    vertical: MediaQuery.of(context).size.width * 0.025,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(11),
                    color: Theme.of(context).colorScheme.background,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Image(
                            image: AssetImage(AssetHelper.bic),
                            fit: BoxFit.fitWidth,
                            width: 30,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Text(
                              '45.000 bic',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(FundinScreen.routeName);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.input_rounded,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Fund in',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  )
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              //
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.history_rounded,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'History',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  )
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              //
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      //report
                                      Icons.insert_chart_outlined_rounded,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Report',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  )
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              //
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.motorcycle_rounded,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Bais',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium!,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              //height: MediaQuery.of(context).size.height * 0.2,
              padding: const EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: MediaQuery.of(context).size.width * 0.025,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
                color: Theme.of(context).colorScheme.background,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),

              //location's weather
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Outside weather',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Row(
                        children: [
                          Text(
                              '${weatherData?.name}, ${weatherData?.sys.country}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontSize: 12,
                                  )),
                          const SizedBox(width: 5),
                          GestureDetector(
                            onTap: () => getWeather(),
                            child: Icon(
                              Icons.refresh_rounded,
                              color: Theme.of(context).colorScheme.primary,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 13),
                  //weather data
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            (weatherData?.weather[0].icon == null)
                                ? const Icon(Icons.hourglass_top_rounded)
                                : Image.network(
                                    'http://openweathermap.org/img/wn/${weatherData?.weather[0].icon}.png',
                                    alignment: Alignment.center,
                                    fit: BoxFit.contain,
                                    filterQuality: FilterQuality.high,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Text(
                              '${weatherData?.main.temp}°C',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              'Real feel: ${weatherData?.main.feelsLike}°C',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        // Temperature and cloud
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.temperatureHalf,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.6),
                                  ),
                                  const SizedBox(height: 6),
                                  Icon(
                                    FontAwesomeIcons.cloud,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.6),
                                  )
                                ],
                              ),
                            ),
                            const Expanded(
                              flex: 1,
                              child: SizedBox(),
                            ),
                            Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${weatherData?.main.temp}°C',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '${weatherData?.clouds.all}%',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        // Wind speed and humidity
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.wind,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.6),
                                  ),
                                  const SizedBox(height: 6),
                                  Icon(
                                    FontAwesomeIcons.droplet,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.6),
                                  )
                                ],
                              ),
                            ),
                            const Expanded(
                              flex: 1,
                              child: SizedBox(),
                            ),
                            Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${weatherData?.wind.speed} m/s',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '${weatherData?.main.humidity}%',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        // Wind speed and humidity
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.visibility_rounded,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.6),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'AQI',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(0.6),
                                        ),
                                  )
                                ],
                              ),
                            ),
                            const Expanded(
                              flex: 1,
                              child: SizedBox(),
                            ),
                            Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$visibility km',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    aqi,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      'Last updated: ${weatherData?.dt != null ? DateFormat('dd/MM/yyyy HH:mm').format(DateTime.fromMillisecondsSinceEpoch(weatherData!.dt * 1000)) : 'loading...'} Timezone: ',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              padding: const EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: MediaQuery.of(context).size.width * 0.025,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
                color: Theme.of(context).colorScheme.background,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Image(
                          image: AssetImage(AssetHelper.imgLogo),
                          fit: BoxFit.contain,
                          width: 60,
                        ),
                        Text(
                          'Bai Parking',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: const Image(
                      image: AssetImage(AssetHelper.bai),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}

class FullScreenImageDialog extends StatelessWidget {
  final String imagePath;

  const FullScreenImageDialog({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
