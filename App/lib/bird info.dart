import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';
import 'dart:async';
import 'package:transparent_image/transparent_image.dart';


class BirdInfo extends StatelessWidget {
  @override
  Widget build(BuildContext) {

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
          Padding(
            padding: EdgeInsets.all(0),
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: 'https://cdn.download.ams.birds.cornell.edu/api/v1/asset/202984001/1800',
              fit: BoxFit.fitWidth,// After image load
            ),
            // child: Image.asset(
            //   'assets/bird1.jpeg',
            // ),
          ),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: RichText(
              textDirection: TextDirection.ltr,
              text: TextSpan(
                children: [
                  TextSpan(
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                    text: "Bird 1 Name",
                    recognizer: TapGestureRecognizer()..onTap =  () async{
                      const url = "https://en.wikipedia.org/wiki/Bird";
                      if (await canLaunch(url))
                        await launch(url);
                      else
                        // can't launch url, there is some error
                        throw "Could not launch $url";
                    }
                    ),
                ],
              ),
            ),
          ),


          new SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: new Text(
                "This is the info of this bird\n Maybe include rarity, list of ALL sightings",
                style: new TextStyle(fontSize: 24, color: Colors.black),
                textDirection: TextDirection.ltr,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
