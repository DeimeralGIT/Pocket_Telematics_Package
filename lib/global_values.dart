import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pocket_telematics/Data/driving_tracking_model.dart';

//{[time, position]}
Set<List<double>> velocityList = {};
//trajectory points
List<LatLng> polylineList = [];
//directions 0-360 degrees
List<double> angleList = [];
//acceleration
List<double> accelerationList = [];

//metrics
DateTime recordStartTime = DateTime.now();
DateTime recordEndTime = DateTime.now();
double notDrivingTime = 0.0;
double difference = 0.0;
double newVelocity = 0.0;
double velocity = 0;
double averageVelocity = 0.0;
double peakAverageVelocity = 0.0;
double highestVelocity = 0.0;
double highestAccuracy = 0.0;
double distance = 0.0;
double time = 0.0;
double timer = 0.0;

//trigger switches
bool initialPositionAvailable = false;
bool accuracyControl = true;

//directional variables
double corneringStartAngle = 0.0;
double corneringAngle = 0.0;
double straightDriveDistance = 0.0;
double cornerDriveDistance = 0.0;
const int directionSequenceLength = 6;
const int minimumConsideredAngle = 15;
const double minimumConsideredSpeed = 6.5;
List<double> maneuverSpeed = [];
int grade = 100;

//realtime driving details
List<String> directionContent = ["Driving Summary"];

//the periodic timer takes most of the memory and uses battery on updating UI element
//the periodic timer will not take action if the boolean value is false
bool activePeriodic = false;

//mock position implementation for future use
Position initialPosition =
    Position(longitude: 40.1872, latitude: 44.5152, timestamp: DateTime(2021), accuracy: 0.0, altitude: 0.0, heading: 0.0, speed: 0.0, speedAccuracy: 0.0);
Position position =
    Position(longitude: 0.0, latitude: 0.0, timestamp: DateTime(2021), accuracy: 0.0, altitude: 0.0, heading: 0.0, speed: 0.0, speedAccuracy: 0.0);

//recording parametres
bool recordingStarted = false;

//velocity will be added to velocity chain if it's > 20
//every time velocity is < 20 the List is reset
//once velocity chain reaches length of 6, recording will be triggered
List<double> velocityChain = [];
DrivingTrackingModel saveModel = DrivingTrackingModel(
  startDate: "",
  endDate: "",
  velocityData: "",
  angleList: "",
  accelerationList: "",
  polylineList: "",
  drivingSummary: "",
  overallStats: "",
  grade: "",
);
String bottomInfoText = "";
