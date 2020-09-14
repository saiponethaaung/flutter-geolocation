import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  SharedPreferences sh;
  List<String> history = [];

  @override
  void initState() {
    super.initState();
    this.initFunc();
  }

  void initFunc() async {
    sh = await SharedPreferences.getInstance();
    history = sh.getStringList('locations') ?? [];
    this.setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location History'),
        centerTitle: true,
      ),
      body: ListView.separated(
        // padding: EdgeInsets.all(16.0),
        separatorBuilder: (context, index) => Divider(),
        itemCount: history.length,
        itemBuilder: (context, index) {
          var location = jsonDecode(history[index]);

          return ListTile(
            title: Text('Record ${index + 1}'),
            subtitle: Text(
                'Lat: ${location['lat']} | Lng: ${location['lng']}\nTimestamp ${location['timestamp']}'),
            onTap: () async {
              var map =
                  'geo:${location['lat']},${location['lng']}?z=15&q=${location['lat']},${location['lng']}';
              if (await canLaunch(map)) {
                launch(map);
              } else {
                var url =
                    "https://www.google.com/maps/search/?q=${location['lat']},${location['lng']}";
                print('open location: $url');
                if (await canLaunch(url)) {
                  launch(url);
                }
              }
            },
          );
        },
      ),
    );
  }
}
