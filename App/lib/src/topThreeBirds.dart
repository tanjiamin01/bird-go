import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';


void main() => runApp(TopThreeBirds());

class TopThreeBirds extends StatelessWidget {
  const TopThreeBirds({Key? key}) : super(key: key);
  static const TextStyle birdname_sytle = TextStyle(fontSize: 12, color: Colors.black);
  static const TextStyle spotted_sytle = TextStyle(fontSize: 12, color: Colors.grey);
  static const Icon star = Icon(Icons.star, size: 20);


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
                  Text('Pied Kingfisher', style: birdname_sytle,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      star,
                      star,
                      star,
                      // Icon(Icons.star),
                      // Icon(Icons.star),
                      // Icon(Icons.star),
                    ],
                  ),
                  Text('spotted 1h ago', style: spotted_sytle),
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
                  Text('Peacock', style: birdname_sytle),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Icon(Icons.star),
                      // Icon(Icons.star),
                      star,
                      star,
                    ],
                  ),
                  Text('spotted 4h ago', style: spotted_sytle),
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
                  Text('Javan Pond Heron', style: birdname_sytle),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      star,
                      star,
                      star,
                      star,
                      // Icon(Icons.star),
                      // Icon(Icons.star),
                      // Icon(Icons.star),
                      // Icon(Icons.star),
                    ],
                  ),
                  Text('spotted 3h ago', style: spotted_sytle),
                ],
              )),
            ],
          ),
        ],
      ),
    );
  }
}
