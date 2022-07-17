import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class Race {
  String image;
  String name;
  String extHotLap;
  String extRacerName;
  String? personalHotLap;
  int external;
  List<String> laps = [];

  Race({
    required this.image,
    required this.name,
    required this.extHotLap,
    required this.extRacerName,
    this.external = 0,
  });

  initializeLaps({required SharedPreferences localStorage}) {
    laps = localStorage.getStringList(name) ?? [];
  }

  addLap({required lap, required SharedPreferences localStorage}) {
    laps.add(lap);
    localStorage.setStringList(name, laps);

    print(laps);
  }

  addLaps(
      {required List<String> laps, required SharedPreferences localStorage}) {
    this.laps.addAll(laps);
    localStorage.setStringList(name, laps);
  }

  removeLap({required int index, required SharedPreferences localStorage}) {
    laps.removeAt(index);
    localStorage.setStringList(name, laps);
  }

  removeLaps({required SharedPreferences localStorage}) {
    laps = [];
    localStorage.setStringList(name, laps);
  }

  List<String>? getLaps() {
    return laps;
  }

  getHotLap({required SharedPreferences localStorage}) {
    if (laps.length > 0) {
      laps.sort(((a, b) {
        var time1 = a.split(":");
        var time2 = b.split(":");
        if (int.parse(time1[0]) < int.parse(time2[0])) return -1;
        if (int.parse(time1[0]) > int.parse(time2[0])) return 1;
        if (int.parse(time1[1]) < int.parse(time2[1])) return -1;
        if (int.parse(time1[1]) > int.parse(time2[1])) return 1;
        if (int.parse(time1[2]) < int.parse(time2[2])) return -1;
        if (int.parse(time1[2]) > int.parse(time2[2])) return 1;
        return 0;
      }));
      personalHotLap = laps.first;
      return personalHotLap;
    }
    return '';
  }
}
