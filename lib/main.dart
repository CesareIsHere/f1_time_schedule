import 'package:f1_time_schedule/pages/homepage.dart';
import 'package:f1_time_schedule/repository/races_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late SharedPreferences _localStorage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _storageInitializer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'F1: time schedule',
      theme: ThemeData(
        primarySwatch: Colors.red,
        brightness: Brightness.dark,
      ),
      home: _isLoading
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : HomePage(localStorage: _localStorage),
    );
  }

  _storageInitializer() async {
    _localStorage = await SharedPreferences.getInstance();
    RacesRepository().initializeExtRaces(localStorage: _localStorage);
    RacesRepository().initializeRaces(localStorage: _localStorage);
    setState(() {
      _isLoading = false;
    });
  }
}
