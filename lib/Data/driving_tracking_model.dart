import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pocket_telematics/Data/driving_tracking_entity.dart';

class DrivingTrackingModel extends DrivingTrackingEntity {
  DrivingTrackingModel({
    required startDate,
    required endDate,
    required distance,
    required velocityData,
    required angleList,
    required accelerationList,
    required polylineList,
    required drivingSummary,
    required overallStats,
    required grade,
  }) : super(
          startDate: startDate,
          endDate: endDate,
          distance: distance,
          velocityData: velocityData,
          angleList: angleList,
          accelerationList: accelerationList,
          polylineList: polylineList,
          drivingSummary: drivingSummary,
          overallStats: overallStats,
          grade: grade,
        );

  factory DrivingTrackingModel.fromJson(Map<String, dynamic> json) {
    return DrivingTrackingModel(
      startDate: json["start_date"],
      endDate: json["end_date"],
      distance: json["distance"],
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
