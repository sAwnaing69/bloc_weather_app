import 'package:bloc_weather_app/modles/current_weather_model.dart';
import 'package:bloc_weather_app/modles/focast_weather_model.dart';
import 'package:bloc_weather_app/screens/home_screen/home_bloc.dart';
import 'package:bloc_weather_app/screens/home_screen/home_even.dart';
import 'package:bloc_weather_app/repos/home_repo.dart';
import 'package:bloc_weather_app/screens/home_screen/home_state.dart';
import 'package:bloc_weather_app/screens/home_screen/home_widgets/current_weather_widget.dart';
import 'package:bloc_weather_app/screens/home_screen/home_widgets/focast_title_widget.dart';
import 'package:bloc_weather_app/screens/home_screen/home_widgets/forecast_weather_widget.dart';

import 'package:bloc_weather_app/utils/app_color.dart';
import 'package:bloc_weather_app/utils/dimesions.dart';
import 'package:bloc_weather_app/utils/text_style.dart';

import 'package:bloc_weather_app/widgets/app_loading_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  final Position position;
  const HomeScreen({
    super.key,
    required this.position,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
          homeRepo: RepositoryProvider.of<HomeRepo>(context), context: context)
        ..add(LoadedHomeEvent(widget.position, false)),
      child: Container(
        decoration: const BoxDecoration(gradient: AppColor.backGroundGr),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text(
              "Saw's Weather App",
              style: MyTextStyle.heading,
            ),
          ),
          body: BlocBuilder<HomeBloc, HomeState>(builder: (context, homestate) {
            if (homestate is HomeLoadingState) {
              return appLoadingWidget();
            }

            if (homestate is HomeLoadedState) {
              bool isFav = homestate.isFav;
              CurrentWeatherModel currentWeather = homestate.currentWeather;
              FocastWeatherModel forecastWeather = homestate.focastWeatherModel;
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: Dimesion.width20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: Dimesion.height20,
                    ),
                    currentWeatherWidget(
                        cityName: currentWeather.location!.name!,
                        temp: currentWeather.current!.tempC!,
                        humidity: currentWeather.current!.humidity,
                        conditionText: currentWeather.current!.condition!.text!,
                        cloud: currentWeather.current!.cloud,
                        icon: currentWeather.current!.condition!.icon!,
                        onPress: () {
                          BlocProvider.of<HomeBloc>(context)
                              .add(LoadedHomeEvent(widget.position, isFav));
                        },
                        isFav: isFav),
                    SizedBox(
                      height: Dimesion.height40,
                    ),
                    forecastTitleWidget(),
                    SizedBox(
                      height: Dimesion.height10,
                    ),
                    forecastWeatherWidget(forecastWeather: forecastWeather)
                  ],
                ),
              );
            }
            if (homestate is HomeErrorState) {
              return Center(
                child: Text(
                  homestate.error,
                  style: MyTextStyle.normalText.copyWith(color: Colors.red),
                ),
              );
            }
            return Container();
          }),
        ),
      ),
    );
  }
}
