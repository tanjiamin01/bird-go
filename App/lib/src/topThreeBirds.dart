import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';


void main() => runApp(TopThreeBirds());

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
