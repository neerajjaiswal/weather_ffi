import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

typedef TemperatureFunction = Double Function();
typedef TemperatureFunctionDart = double Function();
// TODO: Add new typedef declarations here
typedef ForecastFunction = Pointer<Utf8> Function();
typedef ForecastFunctionDart = Pointer<Utf8> Function();

// TODO: Add ThreeDayForecast here
class ThreeDayForecast extends Struct {
  // 1
  @Double()
  external double get today;
  external set today(double value);

  @Double()
  external double get tomorrow;
  external set tomorrow(double value);

  @Double()
  external double get day_after;
  external set day_after(double value);

  // 2
  @override
  String toString() {
    return 'Today : ${today.toStringAsFixed(1)}\n'
        'Tomorrow : ${tomorrow.toStringAsFixed(1)}\n'
        'Day After ${day_after.toStringAsFixed(1)}';
  }
}

// 3
typedef ThreeDayForecastFunction = ThreeDayForecast Function(Uint8 useCelsius);
typedef ThreeDayForecastFunctionDart = ThreeDayForecast Function(
    int useCelsius);



class FFIBridge {
  TemperatureFunctionDart _getTemperature;
  // TODO: Add _getForecast declaration here
  ForecastFunctionDart _getForecast;
  // TODO: Add _getThreeDayForecast here
  ThreeDayForecastFunctionDart _getThreeDayForecast;



  FFIBridge() {
    // 1
    final dl = Platform.isAndroid
        ? DynamicLibrary.open('libweather.so')
        : DynamicLibrary.process();

    _getTemperature = dl
    // 2
        .lookupFunction<
    // 3
        TemperatureFunction,
    // 4
        TemperatureFunctionDart>('get_temperature');

    // TODO: Assign value to _getForecast
    _getForecast = dl
        .lookupFunction<ForecastFunction, ForecastFunctionDart>('get_forecast');

    // TODO: Assign value to _getThreeDayForecast here
    _getThreeDayForecast = dl.lookupFunction<ThreeDayForecastFunction,
        ThreeDayForecastFunctionDart>('get_three_day_forecast');
  }

  // 5
  double getTemperature() => _getTemperature();

// TODO: Add getForecast() here
  String getForecast() {
    final ptr = _getForecast();
    final forecast = ptr.toDartString();
    calloc.free(ptr);
    return forecast;
  }


// TODO: Add getThreeDayForecast() here
  ThreeDayForecast getThreeDayForecast(bool useCelsius) {
    return _getThreeDayForecast(useCelsius ? 1 : 0);
  }
}
