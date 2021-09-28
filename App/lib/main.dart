import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemapstry/widget_copy/textfield_general_widget.dart';
import 'src/locations.dart' as locations;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}




class _MyAppState extends State<MyApp> {
  late BitmapDescriptor pinLocationIcon;

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
          backgroundColor: Color(0xfffeaa9c),
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
              child: const Icon(Icons.file_upload_outlined),
              backgroundColor: Color(0xffFEAA9c),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => TextfieldGeneralWidget()));
              }

          ),
        ),

       /*   floatingActionButton: FloatingActionButton(

          onPressed: () {

           Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TextfieldGeneralWidget()),
            );

          },
          child: const Icon(Icons.file_upload_outlined),
          backgroundColor: Color(0xffFEAA9c),

        ), */
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: const CameraPosition(
            target: LatLng(0, 0),
            zoom: 2,
          ),
          markers: _markers.values.toSet(),
        ),
      ),
    );
  }
}





