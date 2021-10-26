
import 'dart:io';

import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:googlemapstry/widget_copy/button_widget.dart';
import'package:firebase_storage/firebase_storage.dart';
import'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import '../location copy.dart';
import '../photo_copy.dart';


class TextfieldGeneralWidget extends StatefulWidget {
  @override
  _TextfieldGeneralWidgetState createState() => _TextfieldGeneralWidgetState();
}

class _TextfieldGeneralWidgetState extends State<TextfieldGeneralWidget> {
  bool pressGeoON = false;
  final NameController = TextEditingController();
  final DescriptionController = TextEditingController();
  final numberController = TextEditingController();
  String password = '';
  bool isPasswordVisible = false;
  Location location = new Location();
  var position;
  String url = "";
  CollectionReference _birdss =
  FirebaseFirestore.instance.collection('birds');

  // get key => null; // added this to fix button widget below

  @override
  void initState() {
    super.initState();

    NameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    NameController.dispose();
    numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Material(
    child: Container(

      decoration: BoxDecoration(

        image: DecorationImage(

          fit:BoxFit.fill,
          image: AssetImage('assets/canva-photo-editor.png'),
          // image: AssetImage('assets/uploadbg1.png'),
          // image: AssetImage('assets/uploadbg2.png'),
        ),
      ),


      child: Center( child: ListView(
        padding: EdgeInsets.all(32),
        children: [
          IconButton(
            alignment: Alignment.topLeft,
            color: Colors.white,
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 35.0),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Text("UPLOAD YOUR SIGHTING",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800,

            ),  ),
          const SizedBox(height: 30),
          buildEmail(),
          const SizedBox(height: 24),
          description(),
          const SizedBox(height: 24),
          // buildNumber(),
          // const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xffFEAA9C),
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,

                  ),
                ),
                onPressed:() async{
                  await uploadImage();
                  /* Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UploadImageDemo()),*/
                },
                icon: Icon(Icons.add_photo_alternate , size: 24),
                label: Text("Photo"),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: /* pressGeoON == true?*/ Color(0xffFEAA9C), // : Color(0xff75E6E7),
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed:() async{
                  var pos = await location.getLocation();
                  setState(() {
                    position = pos;
                  });
                  /*Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GeoListenPage()),
                      );*/
                },
                icon: /*pressGeoON == true?*/ Icon(Icons.add_location_alt_rounded, size: 24), //: Icon(Icons.check_circle_outline_rounded, size: 24),
                label: /* pressGeoON ==true?*/  Text("Upload Location"),// : Text("Upload Done"),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ButtonWidget(
            text: 'Submit',
            onClicked: () async{
              final String? name = NameController.text;
              final String? description = DescriptionController.text;
              if (name != null && position != null && url != null){
                //var pos = await location.getLocation();
                await _birdss.add({"name": NameController.text, "timestamp": Timestamp.now(), "lat": position.latitude, 'lng': position.longitude, 'imgurl': url, 'description': description});
              }
              print('Email: ${NameController.text}');
              //print('Password: ${password}');
              print('Description: ${DescriptionController.text}');
            },
          ),
        ],
      ),
      ),
    ),
  );

  Widget buildEmail() => TextField(
    controller: NameController,
    decoration: InputDecoration(
      enabledBorder: const OutlineInputBorder(
        // width: 0.0 produces a thin "hairline" border
        borderSide: const BorderSide(color: Colors.black38, width: 1.0),
      ),

      // hintText: 'name@example.com',
      labelText: 'Name of Bird Species',
      labelStyle: TextStyle(
        // fontWeight: FontWeight.bold,
          color: Color(0xffFEAA9C)),
      filled: true,
      fillColor: Colors.white,
      // prefixIcon: Icon(Icons.mail),
      // icon: Icon(Icons.mail),
      //  suffixIcon: emailController.text.isEmpty
      //    ? Container(width: 0)
      //     : IconButton(
      //        icon: Icon(Icons.close),
      //      onPressed: () => emailController.clear(),
      //   ),

      border: OutlineInputBorder(),
    ),
    keyboardType: TextInputType.text,
    textInputAction: TextInputAction.done,

  );
  // autofocus: true,


  Widget description() => TextField(
    controller: DescriptionController,
    decoration: InputDecoration(
      enabledBorder: const OutlineInputBorder(
        // width: 0.0 produces a thin "hairline" border
        borderSide: const BorderSide(color: Colors.black38, width: 1.0),
      ),
      hintText: 'Example: Corner of Carpark C, on highest branch of tallest tree.',
      labelText: 'Specific Description of Location',
      labelStyle: TextStyle(
        // fontWeight: FontWeight.bold,
          color: Color(0xffFEAA9C)),
      filled: true,
      fillColor: Colors.white,
      // prefixIcon: Icon(Icons.mail),
      // icon: Icon(Icons.mail),
      //  suffixIcon: emailController.text.isEmpty
      //    ? Container(width: 0)
      //     : IconButton(
      //        icon: Icon(Icons.close),
      //      onPressed: () => emailController.clear(),
      //   ),
      border: OutlineInputBorder(),
    ),
    keyboardType: TextInputType.text,
    textInputAction: TextInputAction.done,
    // autofocus: true,
  );

  /* Widget buildPassword() => TextField(
        onChanged: (value) => setState(() => this.password = value),
        onSubmitted: (value) => setState(() => this.password = value),
        decoration: InputDecoration(
          hintText: 'Your Password...',
          labelText: 'Password',
          errorText: 'Password is wrong',
          suffixIcon: IconButton(
            icon: isPasswordVisible
                ? Icon(Icons.visibility_off)
                : Icon(Icons.visibility),
            onPressed: () =>
                setState(() => isPasswordVisible = !isPasswordVisible),
          ),
          border: OutlineInputBorder(),
        ),
        obscureText: isPasswordVisible,
      ); */

  /* Widget buildNumber() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Number', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: numberController,
            decoration: InputDecoration(
              hintText: 'Enter number...',
              hintStyle: TextStyle(color: Colors.white70),
              filled: true,
              fillColor: Colors.black,
              border: OutlineInputBorder(),
            ),
            style: TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
          ),
        ],
      );*/
  uploadImage() async{
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();

    //Select Image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    var file = File(image!.path);

    if (image != null){
      var snapshot = await _storage.ref().child(image.name).putFile(file);

      var downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        url = downloadUrl;
      });
    } else{
      print("NO IMAGE RECEIVED");
    }


    //Upload to Firebase
  }
}
