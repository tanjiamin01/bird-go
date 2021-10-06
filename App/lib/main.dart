import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemapstry/widget_copy/textfield_general_widget.dart';
import 'src/locations.dart' as locations;
import 'mappage.dart';
import 'search.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
              child: const Icon(Icons.file_upload_outlined),
              backgroundColor: Color(0xffFEAA9c),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TextfieldGeneralWidget()));
              }),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            MapPage(),
            buildFloatingSearchBar(),
          ],
        ),
        drawer: Drawer(
          child: SafeArea(
            right: false,
            child: Center(
              child: Text('Drawer content'),
            ),
          ),
        ),
      ),
    );
  }
}
