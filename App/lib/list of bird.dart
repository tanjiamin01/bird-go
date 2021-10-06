import 'package:flutter/material.dart';
import 'bird info.dart';

class BirdList extends StatelessWidget {
  // const BirdList({Key? key}) : super(key: key);
  final bird_species = List<String>.generate(10000, (i) => "Bird $i");
  // final items = List<String>.generate(10000, (i) => "Item $i");


  Widget build(BuildContext context) {

    return ListView.builder(
      itemCount: bird_species.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(bird_species[index],
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
  }
}


