import 'package:flutter/material.dart';
import 'bird info.dart';

import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BirdList extends StatelessWidget {
  // const BirdList({Key? key}) : super(key: key);
  // final bird_species = List<String>.generate(10000, (i) => "Bird $i");

  Stream<QuerySnapshot> all_bird_species =
      FirebaseFirestore.instance.collection('AllBirdInfo').snapshots();

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

        return ListView.builder(
          // itemCount: bird_species.length,
          itemCount: data.size,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                data.docs[index]['name'],
                style: new TextStyle(fontSize: 15, color: Colors.black),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BirdInfo()),
                );
              },
            );
          },
        );
      },
    );
  }
}
