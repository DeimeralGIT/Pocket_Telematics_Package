class DrivingTrackingEntity {
  final String startDate;
  final String endDate;
  final String distance;
  final String velocityData;
  final String angleList;
  final String accelerationList;
  final String polylineList;
  final String drivingSummary;
  final String overallStats;
  final String grade;
  DrivingTrackingEntity({
    required this.startDate,
    required this.endDate,
    required this.distance,
    required this.velocityData,
    required this.angleList,
    required this.accelerationList,
    required this.polylineList,
    required this.drivingSummary,
    required this.overallStats,
    required this.grade,
  });

  @override
  List<Object?> get props => [
        startDate,
        endDate,
        distance,
        velocityData,
        angleList,
        accelerationList,
        polylineList,
        drivingSummary,
        overallStats,
        grade,
      ];
}
