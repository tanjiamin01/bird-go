import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'src/allBirds.dart';
import 'package:googlemapstry/widget_copy/textfield_general_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'src/locations.dart' as locations;
import 'package:url_launcher/url_launcher.dart';
import 'src/specificBirdGallery.dart';
import 'src/topThreeBirds.dart';

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // shld use future builder here instead
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late BitmapDescriptor pinLocationIcon;

  bool allBirdsWidgetIsVisible = false;
  bool topThreeBirdsWidgetIsVisible = true;
  bool specificBirdGalleryWidgetIsVisible = false;

  @override
  void initState() {
    super.initState();
    setCustomMapPin();
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/marker.png');
  }

  final Map<String, Marker> _markers = {};
  Future<void> _onMapCreated(GoogleMapController controller) async {
    DatabaseReference _testRef =
        FirebaseDatabase.instance.reference().child("test");
    _testRef.set("Hello world ${Random().nextInt(100)}");

    final googleOffices = await locations.getGoogleOffices();
    setState(() {
      _markers.clear();
      for (final office in googleOffices.offices) {
        final marker = Marker(
          markerId: MarkerId(office.name),
          position: LatLng(office.lat, office.lng),
          icon: pinLocationIcon,
          infoWindow: InfoWindow(
            title: office.name,
            snippet: office.address,
          ),
        );
        _markers[office.name] = marker;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Google Office Locations'),
            backgroundColor: Colors.green[700],
          ),
          body: Stack(
            children: <Widget>[
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: const CameraPosition(
                  target: LatLng(0, 0),
                  zoom: 2,
                ),
                markers: _markers.values.toSet(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          topThreeBirdsWidgetIsVisible = true;
                          allBirdsWidgetIsVisible = false;
                          specificBirdGalleryWidgetIsVisible = false;
                        });
                      },
                      child: Text('show top three birds', style: TextStyle(fontSize: 12))),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          allBirdsWidgetIsVisible = true;
                          specificBirdGalleryWidgetIsVisible = false;
                          topThreeBirdsWidgetIsVisible = false;
                        });
                      },
                      child: Text('show all birds', style: TextStyle(fontSize: 12))),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          specificBirdGalleryWidgetIsVisible = true;
                          topThreeBirdsWidgetIsVisible = false;
                          allBirdsWidgetIsVisible = false;
                        });
                      },
                      child: Text('show specific bird', style: TextStyle(fontSize: 12))),
                ],
              ),
              Visibility(
                  visible: specificBirdGalleryWidgetIsVisible,
                  child: SpecificBirdGallery()),
              Visibility(visible: allBirdsWidgetIsVisible, child: AllBirds()),
              Visibility(
                  visible: topThreeBirdsWidgetIsVisible,
                  child: TopThreeBirds()),
            ],
          )),
    );
  }
}