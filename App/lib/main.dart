import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemapstry/widget_copy/textfield_general_widget.dart';
import 'src/locations.dart' as locations;
import 'mappage.dart';
import 'search.dart';
import 'src/specificBirdGallery.dart';
import 'src/topThreeBirds.dart';
import 'src/allBirds.dart';

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
            Positioned(
              top: 100,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
            ),
              Visibility(
                  visible: specificBirdGalleryWidgetIsVisible,
                  child: SpecificBirdGallery()),
              Visibility(visible: allBirdsWidgetIsVisible, child: AllBirds()),
              Visibility(
                  visible: topThreeBirdsWidgetIsVisible,
                  child: TopThreeBirds()),
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
