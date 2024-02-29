import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Define a stateful widget named ISSPageState
class ISSPage extends StatefulWidget {
  const ISSPage({Key? key}) : super(key: key);

  @override
  _ISSPageState createState() => _ISSPageState();
}

// Define the state class for ISSPage, inheriting from State<StatefulWidget>
class _ISSPageState extends State<ISSPage> {
  // ignore: unused_field
  Future<LatLng>? _issPositionFuture;
  LatLng currentIssPosition = const LatLng(0, 0);
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    _issPositionFuture = _getISSLocation();
    _updateTimer = Timer.periodic(const Duration(seconds: 5), (_) => _updateISSLocation());
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  Future<LatLng> _getISSLocation() async {
    final apiUrl = Uri.parse('http://api.open-notify.org/iss-now.json');

    try {
      final response = await http.get(apiUrl);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final issLatitude = double.parse(data['iss_position']['latitude']);
        final issLongitude = double.parse(data['iss_position']['longitude']);
        return LatLng(issLatitude, issLongitude);
      } else {
        throw Exception('Failed to load ISS location');
      }
    } catch (e) {
      print('Error: $e');
      rethrow; // Rethrow the error for the FutureBuilder to handle
    }
  }

  void _updateISSLocation() async {
    final newPosition = await _getISSLocation();
    setState(() {
      currentIssPosition = newPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "ISS",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: currentIssPosition,
              initialZoom: 3,
              minZoom: 3,
              maxZoom: 10,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: currentIssPosition,
                    child: const Icon(Icons.satellite_alt_outlined, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
