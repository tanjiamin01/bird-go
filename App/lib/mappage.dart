import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemapstry/predictionpage.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
//import 'src/allBirds.dart';
import 'list of bird.dart';
import 'search.dart';
import 'src/locations.dart' as locations;
import 'src/specificBirdGallery.dart';
import 'src/topThreeBirds.dart';
import 'package:googlemapstry/widget_copy/textfield_general_widget.dart';
import 'dart:async';

StreamController<int> streamController = StreamController<int>();

class MapPage extends StatefulWidget {
  const MapPage(this.stream);
  final Stream<int> stream;

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late BitmapDescriptor pinLocationIcon;
  // @Bryan
  final int num_species = 401;

  bool allBirdsWidgetIsVisible = false;
  bool topThreeBirdsWidgetIsVisible = true;
  bool specificBirdGalleryWidgetIsVisible = false;

  void mySetState(int index) {
    List booleanList = [true, false];
    setState(() {
      specificBirdGalleryWidgetIsVisible = booleanList[index];
      topThreeBirdsWidgetIsVisible = booleanList[index + 1];
      allBirdsWidgetIsVisible = booleanList[index + 1];
    });
  }

  // @Bryan
  void callbackFunction() {
    setState(() {
      allBirdsWidgetIsVisible = false;
      topThreeBirdsWidgetIsVisible = false;
      specificBirdGalleryWidgetIsVisible = true;
    });
  }

  @override
  void initState() {
    super.initState();
    setCustomMapPin();
    widget.stream.listen((index) {
      mySetState(index);
    });
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/marker.png');
  }

  final Map<String, Marker> _markers = {};

  Future<void> _onMapCreated(GoogleMapController controller) async {
    QuerySnapshot snap =
        await FirebaseFirestore.instance.collection('locations').get();

    setState(() {
      _markers.clear();
      for (var i = 0; i < snap.size; i++) {
        var map = (snap.docs[i].data() as LinkedHashMap)!
            .map((a, b) => MapEntry(a as String, b.toString() as String));
        final marker = Marker(
          markerId: MarkerId(map.putIfAbsent('name', () => 'Err')),
          position: LatLng(double.parse(map.putIfAbsent('lat', () => '0')),
              double.parse(map.putIfAbsent('lng', () => '0'))),
          icon: pinLocationIcon,
          onTap: () {
            setState(() {
              allBirdsWidgetIsVisible = false;
              specificBirdGalleryWidgetIsVisible = false;
              topThreeBirdsWidgetIsVisible = true;
            });
          },
          infoWindow: InfoWindow(
            title: map.putIfAbsent('name', () => 'Err'),
            snippet: map.putIfAbsent('address', () => 'Err'),
          ),
        );
        _markers[map.putIfAbsent('name', () => 'Err')] = marker;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
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
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color(0xFFFEAA9C))),
                    child:
                        Text('show all birds', style: TextStyle(fontSize: 16))),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        specificBirdGalleryWidgetIsVisible = true;
                        topThreeBirdsWidgetIsVisible = false;
                        allBirdsWidgetIsVisible = false;
                      });
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color(0xFFFEAA9C))),
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
                child: const Icon(Icons.file_upload_outlined)),
          ),
        ),
        Positioned(
          right: 10,
          bottom: 237,
          child: Builder(
            builder: (context) => FloatingActionButton(
                backgroundColor: Color(0xffFEAA9c),
                onPressed: () {
                  // change to map page
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PredPage()));
                },
                child: const Icon(Icons.lightbulb_outline_rounded)),
          ),
        ),
        Visibility(
            visible: specificBirdGalleryWidgetIsVisible,
            child: SpecificBirdGallery()),
        Visibility(visible: allBirdsWidgetIsVisible, child: AllBirds()),
        Visibility(
            visible: topThreeBirdsWidgetIsVisible, child: TopThreeBirds()),
        SearchPage(callbackFunction),
      ]),
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 155.0,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  // color: Colors.blue.shade100,
                  image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: AssetImage('assets/canva-photo-editor.png')),
                ),
                padding: const EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 5.0),
                child: Flexible(
                  child: new Text(
                    "ALL BIRDS IN SINGAPORE (${num_species})",
                    softWrap: true,
                    textAlign: TextAlign.left,
                    style: new TextStyle(fontSize: 30, color: Colors.white),
                    textDirection: TextDirection.ltr,
                  ),
                ),
              ),
            ),
            Expanded(child: BirdList()),
          ],
        ),
      ),
    );
  }
}

class AllBirds extends StatelessWidget {
  const AllBirds({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
        minHeight: 220,
        maxHeight: 450,
        panel: Stack(
          children: <Widget>[
            Column(
              children: [
                Icon(Icons.drag_handle),
                Container(
                    margin: EdgeInsets.all(10),
                    child: Center(
                        child: Text(
                      'All birds in NTU',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))),
              ],
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 3,
                children: <Widget>[
                  Container(
                    // padding: const EdgeInsets.all(8),
                    // color: Colors.teal[100],
                    child: InkWell(
                      onTap: () {
                        streamController.add(0);
                      },
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image(
                            image: AssetImage('assets/bird1.jpeg'),
                            fit: BoxFit.cover,
                          )),
                    ),
                  ),
                  Container(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image(
                            image: AssetImage('assets/bird2.jpeg'),
                            fit: BoxFit.cover)),
                  ),
                  Container(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image(
                            image: AssetImage('assets/bird3.jpeg'),
                            fit: BoxFit.cover)),
                  ),
                  Container(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image(
                            image: AssetImage('assets/bird4.jpeg'),
                            fit: BoxFit.cover)),
                  ),
                  Container(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image(
                            image: AssetImage('assets/bird5.jpeg'),
                            fit: BoxFit.cover)),
                  ),
                  Container(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image(
                            image: AssetImage('assets/bird6.jpeg'),
                            fit: BoxFit.cover)),
                  ),
                  Container(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image(
                            image: AssetImage('assets/bird7.jpeg'),
                            fit: BoxFit.cover)),
                  ),
                  Container(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image(
                            image: AssetImage('assets/bird8.jpeg'),
                            fit: BoxFit.cover)),
                  ),
                  Container(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image(
                            image: AssetImage('assets/bird9.jpeg'),
                            fit: BoxFit.cover)),
                  ),
                  Container(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image(
                            image: AssetImage('assets/bird9.jpeg'),
                            fit: BoxFit.cover)),
                  ),
                  Container(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image(
                            image: AssetImage('assets/bird9.jpeg'),
                            fit: BoxFit.cover)),
                  ),
                  Container(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image(
                            image: AssetImage('assets/bird9.jpeg'),
                            fit: BoxFit.cover)),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
