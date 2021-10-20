import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'src/allBirds.dart';
import 'src/locations.dart' as locations;
import 'src/specificBirdGallery.dart';
import 'src/topThreeBirds.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
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
    final googleOffices = await locations.getGoogleOffices();
    setState(() {
      _markers.clear();
      for (final office in googleOffices.offices) {
        final marker = Marker(
          markerId: MarkerId(office.name),
          position: LatLng(office.lat, office.lng),
          icon: pinLocationIcon,
          onTap: () {
            setState(() {
              allBirdsWidgetIsVisible = false;
              specificBirdGalleryWidgetIsVisible = false;
              topThreeBirdsWidgetIsVisible = true;
            });
          },
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
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: const CameraPosition(
                target: LatLng(1.3483, 103.6831),
                zoom: 16,
              ),
            markers: _markers.values.toSet(),
            ),
          ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 80, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            allBirdsWidgetIsVisible = true;
                            specificBirdGalleryWidgetIsVisible = false;
                            topThreeBirdsWidgetIsVisible = false;
                          });
                        },
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFFEAA9C))),
                        child: Text('show all birds',
                            style: TextStyle(fontSize: 16))),
                  ),
                  SizedBox(width:10),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            specificBirdGalleryWidgetIsVisible = true;
                            topThreeBirdsWidgetIsVisible = false;
                            allBirdsWidgetIsVisible = false;
                          });
                        },
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFFEAA9C))),
                        child: Text('show specific bird',
                            style: TextStyle(fontSize: 16))),
                  ),
                ],
              ),
            ),
            Visibility(
                visible: specificBirdGalleryWidgetIsVisible,
                child: SpecificBirdGallery()),
            Visibility(visible: allBirdsWidgetIsVisible, child: AllBirds()),
            Visibility(
                visible: topThreeBirdsWidgetIsVisible, child: TopThreeBirds()),
          ]
        )
    );
  }
}