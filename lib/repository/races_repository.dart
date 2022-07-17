import 'dart:convert';

import 'package:f1_time_schedule/models/race.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RacesRepository {
  static const images_path = "assets/races_images";

  List<String> ext_races = [];
  static List<Race> races = [
    Race(
        image: "$images_path/bahrain.png",
        name: "BARHAIN - BAHRAIN INTERNATIONAL CIRCUIT",
        extRacerName: "Lewis Hamilton(Mercedes - 2020)",
        extHotLap: "1:27:260"),
    Race(
        image: "$images_path/jeddah.png",
        name: "ARABIA SAUDITA - JEDDAH STREET CIRCUIT",
        extRacerName: "Lewis Hamilton(Mercedes - 2021)",
        extHotLap: "1:27:510"),
    Race(
        image: "$images_path/australia.png",
        name: "AUSTRALIA - MELBOURNE GRAND PRIX CIRCUIT",
        extRacerName: "Michael Schumacher(Ferrari - 2004)",
        extHotLap: "1:24:125"),
    Race(
        image: "$images_path/imola_enzo_ferrari.png",
        name: "ITALIA - AUTODROMO ENZO E DINO FERRARI",
        extRacerName: "Valtteri Bottas(Mercedes - 2020)",
        extHotLap: "1:13:609"),
    // Race(
    //     image: "$images_path/",
    //     name: "USA - MIAMI INTERNATIONAL AUTODROME",
    //     extRacerName: "Charles Leclerc(Ferrari - 2022)",
    //     extHotLap: "1:28:795"),
    Race(
        image: "$images_path/spagna.png",
        name: "SPAGNA - CIRCUIT DE BARCELONA-CATALUNYA",
        extRacerName: "Lewis Hamilton(Mercedes - 2021)",
        extHotLap: "1:16:741"),
    Race(
        image: "$images_path/monaco.png",
        name: "MONACO - CIRCUIT DE MONACO",
        extRacerName: "Lewis Hamilton(Mercedes - 2019)",
        extHotLap: "1:10:166"),
    Race(
        image: "$images_path/azerbaijan.png",
        name: "AZERBAIJAN - BAKU CITY CIRCUIT",
        extRacerName: "Valtteri Bottas(Mercedes - 2019)",
        extHotLap: "1:40:495"),
    Race(
        image: "$images_path/canada.png",
        name: "CANADA - CIRCUIT GILLES VILLENEUVE",
        extRacerName: "Sebastian Vettel(Ferrari - 2019)",
        extHotLap: "1:10:240"),
    Race(
        image: "$images_path/gran-bretagna.png",
        name: "GRAN BRETAGNA - SILVERSTONE CIRCUIT",
        extRacerName: "Lewis Hamilton(Mercedes - 2020)",
        extHotLap: "1:24:303"),
    Race(
        image: "$images_path/francia.png",
        name: "FRANCIA - CIRCUIT PAUL RICARD",
        extRacerName: "Lewis Hamilton(Mercedes - 2019)",
        extHotLap: "1:28:319"),
    Race(
        image: "$images_path/ungheria.png",
        name: "UNGHERIA - HUNGARORING",
        extRacerName: "Lewis Hamilton(Mercedes - 2020)",
        extHotLap: "1:13:447"),
    Race(
        image: "$images_path/belgio_spa-francorchamps.png",
        name: "BELGIO - CIRCUIT DE SPA-FRANCORCHAMPS",
        extRacerName: "Lewis Hamilton(Mercedes - 2020)",
        extHotLap: "1:41:252"),
    Race(
        image: "$images_path/italia_monza.png",
        name: "ITALIA - AUTODROMO NAZIONALE DI MONZA",
        extRacerName: "Lewis Hamilton(Mercedes - 2020)",
        extHotLap: "1:18:887"),
    Race(
        image: "$images_path/singapore.png",
        name: "SINGAPORE - MARINA BAY STREET CIRCUIT",
        extRacerName: "Lewis Hamilton(Mercedes - 2018)",
        extHotLap: "1:36:015"),
    Race(
        image: "$images_path/giappone.png",
        name: "GIAPPONE - SUZUKA INTERNATIONAL RACING COURSE",
        extRacerName: "Sebastian Vettel(Ferrari - 2019)",
        extHotLap: "1:27:063"),
    Race(
        image: "$images_path/stati-uniti.png",
        name: "STATI UNITI - CIRCUIT OF THE AMERICAS",
        extRacerName: "Valtteri Bottas(Mercedes - 2019)",
        extHotLap: "1:32:029"),
    Race(
        image: "$images_path/messico.png",
        name: "MESSICO - AUTODROMO HERMANOS RODRIGUEZ",
        extRacerName: "Valtteri Bottas(Mercedes - 2021)",
        extHotLap: "1:17:774"),
    Race(
        image: "$images_path/brasile.png",
        name: "BRASILE - AUTODROMO JOSE' CARLOS PACE",
        extRacerName: "Lewis Hamilton(Mercedes - 2018)",
        extHotLap: "1:07:281"),
    Race(
        image: "$images_path/abu-dhabi.png",
        name: "ABU DHABI - YAS MARINA CIRCUIT",
        extRacerName: "Max Verstappen(RedBull - 2021)",
        extHotLap: "1:22:109"),
  ];

  void addLap({index, lapTime, localStorage}) {
    RacesRepository.races[index]
        .addLap(lap: lapTime, localStorage: localStorage);
  }

  void removeLap({index, localStorage}) {
    RacesRepository.races[index]
        .removeLap(index: index, localStorage: localStorage);
  }

  void addRace(
      {required SharedPreferences localStorage,
      image = "$images_path/kart.png",
      required name,
      extHotLap = "",
      extRacerName = "",
      external = 1}) {
    RacesRepository.races.add(Race(
      image: image,
      name: "ext_$name",
      extHotLap: extHotLap,
      extRacerName: extRacerName,
      external: external,
    ));

    String json =
        "{\"image\":\"$image\",\"name\":\"ext_$name\",\"extHotLap\":\"$extHotLap\",\"extRacerName\":\"$extRacerName\",\"external\":\"$external\"}";
    ext_races = localStorage.getStringList("ext_races") ?? [];
    ext_races.add(json);

    localStorage.setStringList("ext_races", ext_races);
  }

  void removeRace(Race race, localStorage) {
    RacesRepository.races
        .removeWhere((element) => element.name.compareTo(race.name) == 0);
    String json =
        "{\"image\":\"${race.image}\",\"name\":\"${race.name}\",\"extHotLap\":\"${race.extHotLap}\",\"extRacerName\":\"${race.extRacerName}\",\"external\":\"${race.external}\"}";
    ext_races = localStorage.getStringList("ext_races") ?? [];
    ext_races.removeWhere((element) =>
        jsonDecode(element)["name"].compareTo(jsonDecode(json)["name"]) == 0);
    localStorage.setStringList("ext_races", ext_races);
  }

  void initializeRaces({localStorage}) {
    for (int i = 0; i < races.length; i++) {
      RacesRepository.races[i].initializeLaps(localStorage: localStorage);
    }
  }

  void initializeExtRaces({required SharedPreferences localStorage}) {
    ext_races = [];
    Map json;

    ext_races.addAll(localStorage.getStringList("ext_races") ?? []);
    for (int i = 0; i < ext_races.length; i++) {
      json = jsonDecode(ext_races[i]);
      RacesRepository.races.add(Race(
        image: "${json["image"]}",
        name: "${json["name"]}",
        extHotLap: "${json["extHotLap"]}",
        extRacerName: "${json["extRacerName"]}",
        external: int.parse(json["external"]),
      ));
    }
  }
}
