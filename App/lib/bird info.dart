import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';
import 'dart:async';
import 'package:transparent_image/transparent_image.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class BirdInfo extends StatelessWidget {

  // BirdInfo(QueryDocumentSnapshot<Object?> bird);

  BirdInfo({Key? key, required this.bird}) : super(key: key);

  final QueryDocumentSnapshot bird;


  // DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('locations').doc('SCIBIRDNAME; COMMONNAME').get();



  @override
  Widget build(BuildContext) {

    Stream<QuerySnapshot> _occurrenceStream =
    FirebaseFirestore.instance.collection('locations').where('name', isEqualTo: bird.get('name')).snapshots();

    // DocumentSnapshot documentSnapshot =
    // FirebaseFirestore.instance.collection('locations').doc(bird.get('name')).get().then((DocumentSnapshot documentSnapshot) {
    //   if (documentSnapshot.exists) {
    //     return documentSnapshot;
    //     // print('Document data: ${documentSnapshot.data()}');
    //   }
    //   // else {
    //   // print('Document does not exist on the database');
    //   // }
    // }) as DocumentSnapshot<Object?>;

    // final double img_width = 256;
    // final double img_height = 256;

    return new Container(
      decoration: new BoxDecoration(
        color: Colors.amber.shade100,
      ),
      child: new Column(
        textDirection: TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          //IMAGE
          Padding(
            padding: EdgeInsets.all(0),
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: bird.get('imgurl'),
              // image: 'https://cdn.download.ams.birds.cornell.edu/api/v1/asset/202984001/1800',
              fit: BoxFit.fitWidth,// After image load
            ),
            // child: Image.asset(
            //   'assets/bird1.jpeg',
            // ),
          ),

          // //COMMON NAME
          // Padding(
          //   padding: const EdgeInsets.all(12.0),
          //   child: RichText(
          //     textDirection: TextDirection.ltr,
          //     text: TextSpan(
          //       children: [
          //         TextSpan(
          //           style: TextStyle(
          //             fontSize: 30,
          //             fontWeight: FontWeight.bold,
          //             color: Colors.black,
          //             // decoration: TextDecoration.underline,
          //           ),
          //           text: bird.get("name"),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),

          //COMMON NAME
          Row(
            children: <Widget>[
              Expanded(
                child: RichText(
                  textDirection: TextDirection.ltr,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          // decoration: TextDecoration.underline,
                        ),
                        text: bird.get('name'),
                      ),
                    ],
                  ),
                ),
              ),

              RichText(
                text:TextSpan(
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blue,
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.underline,
                    ),
                    text: bird.get("sciname"),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        // const url = "https://en.wikipedia.org/wiki/Bird";
                        final url = bird.get("wikiurl");
                        if (await canLaunch(url))
                          await launch(url);
                        else
                          // can't launch url, there is some error
                          throw "Could not launch $url";
                      }),
              ),
            ],
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _occurrenceStream,
              builder: (
                  context,
                  AsyncSnapshot<QuerySnapshot> snapshot,
                  ) {
                if (snapshot.hasError) {
                  return Text('Error');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('...Loading...');
                }

                final bird_locations = snapshot.requireData;

                if (bird_locations.size > 0) {
                  // print('${bird_locations.size} occurrences');
                  return new Scaffold( body: Column(children: [
                    Text('${bird_locations.size} occurrences'),
                    Expanded(child:ListView.builder(
                      itemCount: bird_locations.size,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            bird_locations.docs[index]['address'],
                            style: new TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        );
                      },
                    ),
                    ),
                  ],
                  )
                  );
                }

                else {
                  return Text('There are no occurrences for bird :(');
                }

                // return new Scaffold( body: ListView.builder(
                //   itemCount: bird_locations.size,
                //   itemBuilder: (context, index) {
                //     return ListTile(
                //       title: Text(
                //         bird_locations.docs[index]['address'],
                //         style: new TextStyle(fontSize: 15, color: Colors.black),
                //       ),
                //     );
                //   },
                // ),
                // );
              },
            ),

            // //SCI NAME
            // Padding(
            //   padding: const EdgeInsets.all(12.0),
            //   child: RichText(
            //     textDirection: TextDirection.ltr,
            //     text: TextSpan(
            //       children: [
            //         TextSpan(
            //           style: TextStyle(
            //             fontSize: 18,
            //             // fontWeight: FontWeight.bold,
            //             color: Colors.blue,
            //             fontStyle: FontStyle.italic,
            //             decoration: TextDecoration.underline,
            //           ),
            //           text: bird.get("sciname"),
            //           recognizer: TapGestureRecognizer()..onTap =  () async{
            //             // const url = "https://en.wikipedia.org/wiki/Bird";
            //             final url = bird.get("wikiurl");
            //             if (await canLaunch(url))
            //               await launch(url);
            //             else
            //               // can't launch url, there is some error
            //               throw "Could not launch $url";
            //           }
            //           ),
            //       ],
            //     ),
            //   ),
            // ),


            // new SingleChildScrollView(
            //   child: Padding(
            //     padding: const EdgeInsets.all(12.0),
            //     child: new Text(
            //       "This is the info of this bird\n Maybe include rarity, list of ALL sightings",
            //       style: new TextStyle(fontSize: 24, color: Colors.black),
            //       textDirection: TextDirection.ltr,
            //     ),
            //   ),
            // ),
          ),
        ],
      ),
    );
  }
}
