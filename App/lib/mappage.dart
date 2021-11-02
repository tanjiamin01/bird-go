import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemapstry/predictionpage.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'src/allBirds.dart';
import 'list of bird.dart';
import 'search.dart';
import 'src/locations.dart' as locations;
//import 'src/specificBirdGallery.dart';
import 'src/topThreeBirds.dart';
import 'package:googlemapstry/widget_copy/textfield_general_widget.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

StreamController<int> streamController = StreamController<int>();
StreamController<int> streamController2 = StreamController<int>.broadcast();

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
                heroTag: "btn1",
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
                heroTag: "btn2",
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
            child: SpecificBirdGallery(streamController2.stream)),
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

class SpecificBirdGallery extends StatefulWidget {
  //const SpecificBirdGallery({Key? key}) : super(key: key);
  const SpecificBirdGallery(this.stream);
  final Stream<int> stream;

  @override
  State<SpecificBirdGallery> createState() => _SpecificBirdGalleryState();
}

class _SpecificBirdGalleryState extends State<SpecificBirdGallery> {
  Stream<QuerySnapshot> all_bird_species = FirebaseFirestore.instance
      .collection('AllBirdInfo')
      .orderBy('rarity', descending: true)
      .snapshots();

  int birdIndex = 2;

  void mySetState(int index2) {
    setState(() {
      birdIndex = index2;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.stream.listen((index2) {
      mySetState(index2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: all_bird_species,
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot,
        ) {
          if (snapshot.hasError) {
            return Text('Error');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('...Loading...');
          }

          final data = snapshot.requireData;
          return SlidingUpPanel(
              minHeight: 220,
              maxHeight: 630,
              panel: Stack(
                children: <Widget>[
                  Column(
                    children: [
                      Icon(Icons.drag_handle),
                      Row(
                        children: <Widget>[
                          Container(
                            height: 200,
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                margin: EdgeInsets.all(10),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image(
                                        image: NetworkImage(
                                            data.docs[birdIndex]['imgurl']),
                                        fit: BoxFit.cover))),
                          ),
                          Container(
                            height: 200,
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(data.docs[birdIndex]['name'],
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xFF345071),
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                    data.docs[birdIndex]['sciname'],
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF75E6E7),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      for (int i = 0; i < data.docs[birdIndex]['rarity']; i++) Icon(Icons.star),
                                      // Icon(Icons.star),
                                      // Icon(Icons.star),
                                      Text('spotted 1h ago',
                                          style: TextStyle(
                                              fontSize: 15, color: Colors.grey))
                                    ],
                                  ),
                                  Text('Abundance: Rare'),
                                  Text('Status: Vistor'),
                                  Row(
                                    children: [
                                      Container(
                                          margin:
                                              EdgeInsets.fromLTRB(0, 10, 10, 0),
                                          child: Text('82%',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Color(0xFF75E6E7),
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(0, 10, 0, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('chance of appearing',
                                                style: TextStyle(
                                                    color: Color(0xFF3E9DAD))),
                                            Text('in this location',
                                                style: TextStyle(
                                                    color: Color(0xFF3E9DAD)))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                          text: 'More Info',
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              const url =
                                                  'https://en.wikipedia.org/wiki/Pied_kingfisher';
                                              if (await canLaunch(url)) {
                                                await launch(url);
                                              } else {
                                                throw 'Could not launch $url';
                                              }
                                            })
                                    ]),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    top: 220,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      margin: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Gallery',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF3E9DAD),
                                  fontWeight: FontWeight.bold)),
                          Container(
                              margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                              child: Text(
                                  'Photos by other users in the same location',
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey)))
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 210,
                    right: 0,
                    child: SizedBox(
                        height: 500,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Container(
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
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image(
                                      image:
                                          NetworkImage(data.docs[0]['imgurl']),
                                      fit: BoxFit.cover,
                                    )),
                              ),
                              Container(
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image(
                                        image: NetworkImage(
                                            data.docs[1]['imgurl']),
                                        fit: BoxFit.cover)),
                              ),
                              Container(
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image(
                                        image: NetworkImage(
                                            data.docs[2]['imgurl']),
                                        fit: BoxFit.cover)),
                              ),
                              Container(
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image(
                                        image: NetworkImage(
                                            data.docs[3]['imgurl']),
                                        fit: BoxFit.cover)),
                              ),
                              Container(
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image(
                                        image: NetworkImage(
                                            data.docs[4]['imgurl']),
                                        fit: BoxFit.cover)),
                              ),
                              Container(
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image(
                                        image: NetworkImage(
                                            data.docs[5]['imgurl']),
                                        fit: BoxFit.cover)),
                              ),
                              Container(
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image(
                                        image: NetworkImage(
                                            data.docs[6]['imgurl']),
                                        fit: BoxFit.cover)),
                              ),
                              Container(
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image(
                                        image: NetworkImage(
                                            data.docs[7]['imgurl']),
                                        fit: BoxFit.cover)),
                              ),
                              Container(
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image(
                                        image: NetworkImage(
                                            data.docs[8]['imgurl']),
                                        fit: BoxFit.cover)),
                              ),
                              Container(
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image(
                                        image: NetworkImage(
                                            data.docs[9]['imgurl']),
                                        fit: BoxFit.cover)),
                              ),
                              Container(
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image(
                                        image: NetworkImage(
                                            data.docs[10]['imgurl']),
                                        fit: BoxFit.cover)),
                              ),
                              Container(
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image(
                                        image: NetworkImage(
                                            data.docs[11]['imgurl']),
                                        fit: BoxFit.cover)),
                              ),
                            ],
                          ),
                        )),
                  ),
                ],
              ));
        });
  }
}

class AllBirds extends StatelessWidget {
  //const AllBirds({Key? key}) : super(key: key);

  Stream<QuerySnapshot> all_bird_species = FirebaseFirestore.instance
      .collection('AllBirdInfo')
      .orderBy('rarity', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: all_bird_species,
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot,
        ) {
          if (snapshot.hasError) {
            return Text('Error');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('...Loading...');
          }

          final data = snapshot.requireData;
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
                              streamController2.add(0);
                            },
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image(
                                  image: NetworkImage(data.docs[0]['imgurl']),
                                  fit: BoxFit.cover,
                                )),
                          ),
                        ),
                        Container(
                          child: InkWell(
                            onTap: () {
                              streamController.add(0);
                              streamController2.add(1);
                            },
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image(
                                    image: NetworkImage(data.docs[1]['imgurl']),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                        Container(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image(
                                  image: NetworkImage(data.docs[2]['imgurl']),
                                  fit: BoxFit.cover)),
                        ),
                        Container(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image(
                                  image: NetworkImage(data.docs[3]['imgurl']),
                                  fit: BoxFit.cover)),
                        ),
                        Container(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image(
                                  image: NetworkImage(data.docs[4]['imgurl']),
                                  fit: BoxFit.cover)),
                        ),
                        Container(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image(
                                  image: NetworkImage(data.docs[5]['imgurl']),
                                  fit: BoxFit.cover)),
                        ),
                        Container(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image(
                                  image: NetworkImage(data.docs[6]['imgurl']),
                                  fit: BoxFit.cover)),
                        ),
                        Container(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image(
                                  image: NetworkImage(data.docs[7]['imgurl']),
                                  fit: BoxFit.cover)),
                        ),
                        Container(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image(
                                  image: NetworkImage(data.docs[8]['imgurl']),
                                  fit: BoxFit.cover)),
                        ),
                        Container(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image(
                                  image: NetworkImage(data.docs[9]['imgurl']),
                                  fit: BoxFit.cover)),
                        ),
                        Container(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image(
                                  image: NetworkImage(data.docs[10]['imgurl']),
                                  fit: BoxFit.cover)),
                        ),
                        Container(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image(
                                  image: NetworkImage(data.docs[11]['imgurl']),
                                  fit: BoxFit.cover)),
                        ),
                      ],
                    ),
                  )
                ],
              ));
        });
  }
}
