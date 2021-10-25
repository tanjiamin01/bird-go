import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemapstry/search.dart';
import 'src/allBirds.dart';
import 'src/locations.dart' as locations;
import 'src/specificBirdGallery.dart';
import 'src/topThreeBirds.dart';
import 'package:googlemapstry/widget_copy/textfield_general_widget.dart';

class PredPage extends StatefulWidget {
  const PredPage({Key? key}) : super(key: key);

  @override
  _PredPageState createState() => _PredPageState();
}

class _PredPageState extends State<PredPage> {
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
          icon:  BitmapDescriptor.defaultMarker,// pinLocationIcon,
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
              SearchPage(),
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
              SearchPage(),
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
              Positioned(
                left: 10,
                bottom: 237,
                child: Builder(
                  builder: (context) => FloatingActionButton(
                      backgroundColor: Color(0xffFEAA9c),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TextfieldGeneralWidget()));
                      },
                      child: const Icon(Icons.file_upload_outlined)
                  ),
                ),
              ),
              Positioned(
                right: 10,
                bottom: 237,
                child: Builder(
                  builder: (context) => FloatingActionButton(
                      backgroundColor: Color(0xffFEAA9c),
                      onPressed: () { // change to map page
                        Navigator.pop(context);

                      },
                      child: const Icon(Icons.remove_red_eye_outlined)
                  ),
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