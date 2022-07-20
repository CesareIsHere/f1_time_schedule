// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:auto_size_text/auto_size_text.dart';
import 'package:f1_time_schedule/repository/races_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.localStorage}) : super(key: key);

  SharedPreferences localStorage;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('F1: Time Schedule'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: body(),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('v1.0.0'),
              const SizedBox(width: 10),
              const Text('©2022 Emiliano Cesare'),
            ],
          ),
        ),
      ),
    );
  }

  Widget body() {
    return Container(
        decoration: BoxDecoration(
          color: Colors.black54,
        ),
        child: Stack(
          children: [
            ListView.builder(
                padding: const EdgeInsets.only(
                    bottom: kFloatingActionButtonMargin + 68),
                itemBuilder: ((context, index) => GestureDetector(
                    onTap: () => showDialog(
                        context: context,
                        builder: (context) => lapsListDialog(index)),
                    child: circuitInfo(context, index))),
                itemCount: RacesRepository.races.length),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: FloatingActionButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => addCircuitDialog());
                  },
                  backgroundColor: Colors.red.shade100,
                  child: Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget circuitInfo(context, index) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.14,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoSizeText(
                RacesRepository.races[index].name,
                minFontSize: 6,
                maxLines: 1,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              ListTile(
                leading: Image(
                  width: 100,
                  image: AssetImage(RacesRepository.races[index].image),
                ),
                title: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Record hotlap:",
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          "Your hotlap:",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                    Column(
                      children: [
                        Text(RacesRepository.races[index].extHotLap,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            )),
                        SizedBox(width: 25),
                        Text(
                            RacesRepository.races[index].getHotLap(
                                    localStorage: widget.localStorage) ??
                                "",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                  ],
                ),
                trailing: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    color: Colors.black54,
                    child: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => addLapDialog(index),
                          );
                        },
                        icon: Icon(Icons.add)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget addLapDialog(index) {
    TextEditingController minuteController = TextEditingController();
    TextEditingController secondsController = TextEditingController();
    TextEditingController millisecondsController = TextEditingController();
    return Dialog(
      insetPadding: EdgeInsets.all(0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height * 0.20,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                timeField(controller: minuteController, maxLen: 2),
                SizedBox(width: 5),
                Text(":"),
                SizedBox(width: 5),
                timeField(controller: secondsController, maxLen: 2),
                SizedBox(width: 5),
                Text(":"),
                SizedBox(width: 5),
                timeField(controller: millisecondsController, maxLen: 3),
              ],
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () => setState(() {
                if (minuteController.text != "" &&
                    secondsController.text != "" &&
                    millisecondsController.text != "") {
                  Navigator.pop(context);
                  RacesRepository.races[index].addLap(
                      lap:
                          "${minuteController.text}:${secondsController.text}:${millisecondsController.text}",
                      localStorage: widget.localStorage);
                }
              }),
              child: Text(
                "ADD TIME",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget lapsListDialog(raceIndex) {
    return Dialog(
      insetPadding: EdgeInsets.all(0),
      child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AutoSizeText(
                  RacesRepository.races[raceIndex].name,
                  minFontSize: 6,
                  maxLines: 1,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              AutoSizeText(
                "Record: ${RacesRepository.races[raceIndex].extHotLap}",
                minFontSize: 6,
                maxLines: 1,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              AutoSizeText(
                "Made by: ${RacesRepository.races[raceIndex].extRacerName}",
                minFontSize: 6,
                maxLines: 1,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Text("YOUR LAPS",
                  style: TextStyle(
                      fontSize: 18,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.separated(
                      itemBuilder: ((context, index) => Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  RacesRepository.races[raceIndex].laps[index],
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                IconButton(
                                    onPressed: () => setState(() {
                                          Navigator.pop(context);
                                          RacesRepository.races[raceIndex]
                                              .removeLap(
                                                  index: index,
                                                  localStorage:
                                                      widget.localStorage);
                                        }),
                                    icon: Icon(
                                      Icons.cancel_outlined,
                                      color: Colors.red,
                                    ))
                              ],
                            ),
                          )),
                      separatorBuilder: (context, index) => Divider(
                            color: Colors.black,
                          ),
                      itemCount: RacesRepository.races[raceIndex].laps.length),
                ),
              ),
              Visibility(
                visible: RacesRepository.races[raceIndex].external == 1
                    ? true
                    : false,
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          Navigator.pop(context);
                          RacesRepository().removeRace(
                              RacesRepository.races[raceIndex],
                              widget.localStorage);
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.remove_circle),
                          Text(" Remove circuit"),
                        ],
                      )),
                ),
              )
            ],
          )),
    );
  }

  Widget addCircuitDialog() {
    TextEditingController circuitNameController = TextEditingController();
    TextEditingController racerNameController = TextEditingController();
    TextEditingController minuteController = TextEditingController();
    TextEditingController secondsController = TextEditingController();
    TextEditingController millisecondsController = TextEditingController();
    return Dialog(
      insetPadding: EdgeInsets.all(0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.45,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("ADD CIRCUIT",
                style: TextStyle(
                    fontSize: 18,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: circuitNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Circuit Name",
                  hintText: "ITALY - AUTODROMO DI MONZA",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: racerNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Hotlap: racer's name",
                  hintText: "Lewis Hamilton(Mercedes - 2020)",
                ),
              ),
            ),
            Text("Hotlap: set time"),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                timeField(controller: minuteController, maxLen: 2),
                SizedBox(width: 5),
                Text(":"),
                SizedBox(width: 5),
                timeField(controller: secondsController, maxLen: 2),
                SizedBox(width: 5),
                Text(":"),
                SizedBox(width: 5),
                timeField(controller: millisecondsController, maxLen: 3),
              ],
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () => setState(() {
                if (minuteController.text != "" &&
                    secondsController.text != "" &&
                    millisecondsController.text != "" &&
                    circuitNameController.text != "" &&
                    racerNameController.text != "") {
                  Navigator.pop(context);
                  setState(() {
                    RacesRepository().addRace(
                        localStorage: widget.localStorage,
                        name: circuitNameController.text,
                        extRacerName: racerNameController.text,
                        extHotLap:
                            "${minuteController.text}:${secondsController.text}:${millisecondsController.text}");
                  });
                }
              }),
              child: Text(
                "ADD CIRCUIT",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget timeField({required controller, required maxLen}) {
    return SizedBox(
      width: 60,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: maxLen,
        decoration: InputDecoration(
          counterText: "",
          border: OutlineInputBorder(),
          hintText: maxLen == 2 ? "00" : "000",
        ),
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
