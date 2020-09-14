import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SharedPreferences sh;
  List<String> history = [];
  double lat = 0.0;
  double lng = 0.0;

  @override
  void initState() {
    super.initState();
    this.initFunc();
  }

  void initFunc() async {
    sh = await SharedPreferences.getInstance();
    history = sh.getStringList('locations') ?? [];
  }

  void loadLocation() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      child: SimpleDialog(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 15.0,
              right: 15.0,
            ),
            child: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  width: 10,
                ),
                Text('Loading...'),
              ],
            ),
          )
        ],
      ),
    );
    bool checkLocationService = await isLocationServiceEnabled();

    if (!checkLocationService) {
      Navigator.pop(context);
      showDialog(
        context: context,
        child: AlertDialog(
          content: Text('Enable a location service!'),
          actions: [
            FlatButton(
              child: Text('Close'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return;
    }

    LocationPermission permission = await checkPermission();
    if (permission == LocationPermission.denied) {
      LocationPermission permissionRequest = await requestPermission();
      if (permissionRequest == LocationPermission.denied) {
        Navigator.pop(context);
        showDialog(
          context: context,
          child: AlertDialog(
            content: Text('Location permission is required!'),
            actions: [
              FlatButton(
                child: Text('Close'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
        return;
      }
    }
    Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    this.lat = position.latitude;
    this.lng = position.longitude;

    String info = jsonEncode(
      {
        'lat': lat,
        'lng': lng,
        'timestamp': DateTime.now().toLocal().toString(),
      },
    );

    history.add(info);

    print(history);

    await sh.setStringList('locations', history);

    this.setState(() {});
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offline Geo Locator'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Lat: $lat'),
            Text('Lng: $lng'),
            RaisedButton(
              child: Text('Get Location'),
              onPressed: () => this.loadLocation(),
            ),
            RaisedButton(
              child: Text('Show History'),
              onPressed: () => Navigator.pushNamed(context, '/history'),
            )
          ],
        ),
      ),
    );
  }
}
