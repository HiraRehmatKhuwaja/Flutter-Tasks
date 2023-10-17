import 'dart:html';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Position? _curentPosition;
  String? _currentAddress;

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("enable location service")));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Permission Denied")));
        return false;
      }
      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
                Text("Permission is denied go to setting and on location")));
        return false;
      }
    }
    return true;
  }

  Future<void> _getCurrentLocation() async {
    final bool permission = await _handlePermission();
    if (!permission) {
      return;
    }
    try {
      final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _curentPosition = position;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getAddressFromCoorindates(Position position) async {
    final List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    final place = placemark[0];
    setState() {
      _currentAddress =
          " ${place.name}, ${place.street},${place.country}, ${place.subAdministrativeArea}";
    }

    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('LAT: ${_curentPosition?.latitude ?? " "}'),
            Text('LNG: ${_curentPosition?.longitude ?? " "}'),
            Text(
              'ADDRESS: ${_currentAddress ?? ""}',
            ),
            const SizedBox(height: 32),
            ElevatedButton(onPressed: _getCurrentLocation, child: Text("save"))
          ],
        ),
      ),
    );
  }
}