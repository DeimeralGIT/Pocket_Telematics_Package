// ignore_for_file: file_names

double calculateAcceleration(double previousSpeed, double newSpeed, deltaTime) {
  //speed is in km/h
  //time is in milliseconds
  //method returns acceleration in m/s^2
  return ((newSpeed - previousSpeed) / (deltaTime)) * 27.777;
}

double convertVelocity(double velocity) {
  //gets velocity in m/s returns km/h
  return velocity * 3.6;
}

double calculateAverageVelocity(double distance, double time) {
  //gets distance in km and time in 100th of a second
  //returns in km/h
  return (distance / time) / 16.6;
}

double getAverageVelocity(List<double> velocityList) {
  return velocityList.reduce((a, b) => a + b) / velocityList.length;
}
