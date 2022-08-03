import 'package:google_maps_flutter/google_maps_flutter.dart';

class SaveModel {
  final String velocityData;
  final String angleList;
  final String accelerationList;
  final String polylineList;
  final String drivingSummary;
  final String bottomInfoText;
  final String grade;

  SaveModel({
    required this.velocityData,
    required this.angleList,
    required this.accelerationList,
    required this.polylineList,
    required this.drivingSummary,
    required this.bottomInfoText,
    required this.grade,
  });
}

String listDoubleToString(List<double> query) {
  return query.fold("", (previousValue, element) => previousValue += ",${element.toString()}");
}

List<double> stringToListDouble(String query) {
  return query.substring(1).split(',').map((e) => double.parse(e)).toList();
}

String latlngListToString(List<LatLng> query) {
  String result = "";
  for (int i = 0; i < query.length; i++) {
    result += "${query[i].latitude.toString()}'${query[i].longitude.toString()}";
    if (i != query.length - 1) result += ",";
  }
  return result;
}

List<LatLng> stringToLatLng(String query) {
  return query.split(",").getRange(1, query.split(",").length - 1).map((e) => LatLng(double.parse(e.split("'")[0]), double.parse(e.split("'")[1]))).toList();
}
