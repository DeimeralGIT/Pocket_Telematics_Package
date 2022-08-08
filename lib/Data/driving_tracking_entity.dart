class DrivingTrackingEntity {
  final String startDate;
  final String endDate;
  final String velocityData;
  final String angleList;
  final String accelerationList;
  final String polylineList;
  final String drivingSummary;
  final String bottomInfoText;
  final String grade;
  DrivingTrackingEntity({
    required this.startDate,
    required this.endDate,
    required this.velocityData,
    required this.angleList,
    required this.accelerationList,
    required this.polylineList,
    required this.drivingSummary,
    required this.bottomInfoText,
    required this.grade,
  });

  @override
  List<Object?> get props => [
        startDate,
        endDate,
        velocityData,
        angleList,
        accelerationList,
        polylineList,
        drivingSummary,
        bottomInfoText,
        grade,
      ];
}
