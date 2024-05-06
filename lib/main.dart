

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch:Colors.yellow,
      ),
      debugShowCheckedModeBanner: false,
      home: FetchData(),
    );
  }
}
class FetchData extends StatefulWidget {
  const FetchData({super.key});

  @override
  State<FetchData> createState() => _FetchDataState();
}

class _FetchDataState extends State<FetchData> {

  var _latitude = '';
  var _longitude = '';
  var _address = '';

  Future _updatePosition() async {
    Position pos = await _determinePosition();
    List pm = await placemarkFromCoordinates(pos.latitude, pos.longitude);
    setState(() {
      _latitude = pos.latitude.toString();
      _longitude = pos.longitude.toString();
      _address = pm[0].toString();
    });
  }

  Future <Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }


    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Gps')),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 5,),
            Text(_latitude, style: TextStyle(color: Colors.black),),
            SizedBox(height: 5,),
            Text(_longitude, style: TextStyle(color: Colors.black),),
            SizedBox(height: 5,),
            Text(_address, style: TextStyle(color: Colors.orangeAccent),),
            SizedBox(height: 5,),
            ElevatedButton(onPressed: () {
              _updatePosition();
            },
                child: Text(
                  'Get', style: TextStyle(color: Colors.orangeAccent),))
          ],
        ),
      ),
      backgroundColor: Colors.lightGreen[200],
    );
  }
}