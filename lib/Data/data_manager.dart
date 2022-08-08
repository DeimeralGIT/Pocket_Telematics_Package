import 'dart:convert';
import 'dart:io' as io;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:pocket_telematics/Data/driving_tracking_model.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<io.File?> get _localFile async {
  final path = await _localPath;
  File('$path/driving_tracking.json').create(recursive: true);
  io.File policy = io.File('$path/driving_tracking.json');
  return policy;
}

addDrivingData(DrivingTrackingModel saveModel) async {
  final file = await _localFile;
  readDrivingData().then((currentContent) {
    currentContent.addEntries([
      MapEntry(saveModel.startDate, saveModel.toJson()),
    ]);
    file!.writeAsString(json.encode(currentContent));
  });
}

Future<Map<String, dynamic>> readDrivingData() async {
  try {
    final file = await _localFile;
    var contents;
    if (file != null) {
      contents = await file.readAsString();
    }
    return contents != null ? jsonDecode(contents) : {};
  } catch (e) {
    return {};
  }
}
