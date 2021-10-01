import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemapstry/widget_copy/textfield_general_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'src/locations.dart' as locations;
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

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
              Positioned(
                  top: 480,
                  right: 10,
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          specificBirdGalleryWidgetIsVisible = true;
                          topThreeBirdsWidgetIsVisible = false;
                          allBirdsWidgetIsVisible = false;
                        });
                      },
                      child: Text('show specific bird'))),
              Positioned(
                  top: 430,
                  right: 10,
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          allBirdsWidgetIsVisible = true;
                          specificBirdGalleryWidgetIsVisible = false;
                          topThreeBirdsWidgetIsVisible = false;
                        });
                      },
                      child: Text('show all birds'))),
              Positioned(
                  top: 380,
                  right: 10,
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          topThreeBirdsWidgetIsVisible = true;
                          allBirdsWidgetIsVisible = false;
                          specificBirdGalleryWidgetIsVisible = false;
                        });
                      },
                      child: Text('show top three birds'))),
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

class TopThreeBirds extends StatelessWidget {
  const TopThreeBirds({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      minHeight: 220,
      maxHeight: 220,
      panel: Column(
        children: [
          Icon(Icons.drag_handle),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  child: Column(
                children: [
                  Container(
                    height: 130,
                    width: MediaQuery.of(context).size.width * 0.33,
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        margin: EdgeInsets.all(10),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image(
                                image: AssetImage('assets/bird4.jpeg'),
                                fit: BoxFit.cover))),
                  ),
                  Text('Pied Kingfisher'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.star),
                      Icon(Icons.star),
                      Icon(Icons.star),
                    ],
                  ),
                  Text('spotted 1h ago', style: TextStyle(color: Colors.grey)),
                ],
              )),
              Expanded(
                  child: Column(
                children: [
                  Container(
                    height: 130,
                    width: MediaQuery.of(context).size.width * 0.33,
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        margin: EdgeInsets.all(10),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image(
                                image: AssetImage('assets/bird8.jpeg'),
                                fit: BoxFit.cover))),
                  ),
                  Text('Peacock'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.star),
                      Icon(Icons.star),
                    ],
                  ),
                  Text('spotted 4h ago', style: TextStyle(color: Colors.grey)),
                ],
              )),
              Expanded(
                  child: Column(
                children: [
                  Container(
                    height: 130,
                    width: MediaQuery.of(context).size.width * 0.33,
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        margin: EdgeInsets.all(10),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image(
                                image: AssetImage('assets/bird9.jpeg'),
                                fit: BoxFit.cover))),
                  ),
                  Text('Javan Pond Heron'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.star),
                      Icon(Icons.star),
                      Icon(Icons.star),
                      Icon(Icons.star),
                    ],
                  ),
                  Text('spotted 3h ago', style: TextStyle(color: Colors.grey)),
                ],
              )),
            ],
          ),
        ],
      ),
    );
  }
}

class AllBirds extends StatelessWidget {
  const AllBirds({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
        minHeight: 190,
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
            Grid()
          ],
        ));
  }
}

class SpecificBirdGallery extends StatelessWidget {
  const SpecificBirdGallery({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
        minHeight: 190,
        maxHeight: 450,
        panel: Stack(
          children: <Widget>[
            Column(
              children: [
                Icon(Icons.drag_handle),
                Row(
                  children: <Widget>[
                    Container(
                      height: 170,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          margin: EdgeInsets.all(10),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image(
                                  image: AssetImage('assets/bird4.jpeg'),
                                  fit: BoxFit.cover))),
                    ),
                    Container(
                      height: 170,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Pied Kingfisher',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Color(0xFF345071),
                                    fontWeight: FontWeight.bold)),
                            Text(
                              'Ceryle rudis',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF75E6E7),
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.star),
                                Icon(Icons.star),
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
                                    margin: EdgeInsets.fromLTRB(0, 10, 10, 0),
                                    child: Text('82%',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Color(0xFF75E6E7),
                                            fontWeight: FontWeight.bold))),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
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
              top: 200,
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
                            style: TextStyle(fontSize: 10, color: Colors.grey)))
                  ],
                ),
              ),
            ),
            Positioned(
              top: 180,
              right: 0,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Grid2()
              ),
            ),
          ],
        ));
  }
}

class Grid extends StatelessWidget {
  const Grid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                  image: AssetImage('assets/bird1.jpeg'),
                  fit: BoxFit.cover,
                )),
          ),
          Container(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                    image: AssetImage('assets/bird2.jpeg'), fit: BoxFit.cover)),
          ),
          Container(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                    image: AssetImage('assets/bird3.jpeg'), fit: BoxFit.cover)),
          ),
          Container(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                    image: AssetImage('assets/bird4.jpeg'), fit: BoxFit.cover)),
          ),
          Container(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                    image: AssetImage('assets/bird5.jpeg'), fit: BoxFit.cover)),
          ),
          Container(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                    image: AssetImage('assets/bird6.jpeg'), fit: BoxFit.cover)),
          ),
          Container(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                    image: AssetImage('assets/bird7.jpeg'), fit: BoxFit.cover)),
          ),
          Container(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                    image: AssetImage('assets/bird8.jpeg'), fit: BoxFit.cover)),
          ),
          Container(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                    image: AssetImage('assets/bird9.jpeg'), fit: BoxFit.cover)),
          ),
          Container(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                    image: AssetImage('assets/bird9.jpeg'), fit: BoxFit.cover)),
          ),
          Container(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                    image: AssetImage('assets/bird9.jpeg'), fit: BoxFit.cover)),
          ),
          Container(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                    image: AssetImage('assets/bird9.jpeg'), fit: BoxFit.cover)),
          ),
        ],
      ),
    );
  }
}

class Grid2 extends StatelessWidget {
  const Grid2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  image: AssetImage('assets/bird1.jpeg'),
                  fit: BoxFit.cover,
                )),
          ),
          Container(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                    image: AssetImage('assets/bird2.jpeg'), fit: BoxFit.cover)),
          ),
          Container(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                    image: AssetImage('assets/bird3.jpeg'), fit: BoxFit.cover)),
          ),
          Container(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                    image: AssetImage('assets/bird4.jpeg'), fit: BoxFit.cover)),
          ),
          Container(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                    image: AssetImage('assets/bird5.jpeg'), fit: BoxFit.cover)),
          ),
          Container(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                    image: AssetImage('assets/bird6.jpeg'), fit: BoxFit.cover)),
          ),
          Container(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                    image: AssetImage('assets/bird7.jpeg'), fit: BoxFit.cover)),
          ),
          Container(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                    image: AssetImage('assets/bird8.jpeg'), fit: BoxFit.cover)),
          ),
          Container(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                    image: AssetImage('assets/bird9.jpeg'), fit: BoxFit.cover)),
          ),
          Container(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                    image: AssetImage('assets/bird9.jpeg'), fit: BoxFit.cover)),
          ),
          Container(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                    image: AssetImage('assets/bird9.jpeg'), fit: BoxFit.cover)),
          ),
          Container(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                    image: AssetImage('assets/bird9.jpeg'), fit: BoxFit.cover)),
          ),
        ],

        appBar: AppBar(
          title: const Text('Google Office Locations'),
          backgroundColor: Color(0xfffeaa9c),
        ),
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
