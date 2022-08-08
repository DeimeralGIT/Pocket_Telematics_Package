import 'package:google_maps_flutter/google_maps_flutter.dart';

class DrivingTrackingModel {
  final String startDate;
  final String endDate;
  final String velocityData;
  final String angleList;
  final String accelerationList;
  final String polylineList;
  final String drivingSummary;
  final String overallStats;
  final String grade;

  DrivingTrackingModel({
    required this.startDate,
    required this.endDate,
    required this.velocityData,
    required this.angleList,
    required this.accelerationList,
    required this.polylineList,
    required this.drivingSummary,
    required this.overallStats,
    required this.grade,
  });

  factory DrivingTrackingModel.fromJson(Map<String, dynamic> json) {
    return DrivingTrackingModel(
      startDate: json["start_date"],
      endDate: json["end_date"],
      velocityData: json["velocity_data"],
      angleList: json["angle_list"],
      accelerationList: json["acceleration_list"],
      polylineList: json["poliline_list"],
      drivingSummary: json["driving_summary"],
      overallStats: json["overall_stats"],
      grade: json["grade"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "start_date": startDate,
      "end_date": endDate,
      "velocity_data": velocityData,
      "angle_list": angleList,
      "acceleration_list": accelerationList,
      "poliline_list": polylineList,
      "driving_summary": drivingSummary,
      "overall_stats": overallStats,
      "grade": grade,
    };
  }
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
