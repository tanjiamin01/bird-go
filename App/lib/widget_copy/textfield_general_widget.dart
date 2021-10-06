import 'package:flutter/material.dart';
import 'package:googlemapstry/widget_copy/button_widget.dart';


import '../location copy.dart';
import '../photo_copy.dart';


class TextfieldGeneralWidget extends StatefulWidget {
  @override
  _TextfieldGeneralWidgetState createState() => _TextfieldGeneralWidgetState();
}

class _TextfieldGeneralWidgetState extends State<TextfieldGeneralWidget> {
  bool pressGeoON = false;
  final emailController = TextEditingController();
  final numberController = TextEditingController();
  String password = '';
  bool isPasswordVisible = false;

  // get key => null; // added this to fix button widget below

  @override
  void initState() {
    super.initState();

    emailController.addListener(() => setState(() {}));
  }
  
  @override
  void dispose() {
    emailController.dispose();
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
                    onPressed:() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UploadImageDemo()),
                      );
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
                    onPressed:() {
                      /*setState(() {
                        pressGeoON = !pressGeoON;
                      });*/
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GeoListenPage()),
                      );
                    },
                    icon: /*pressGeoON == true?*/ Icon(Icons.add_location_alt_rounded, size: 24), //: Icon(Icons.check_circle_outline_rounded, size: 24),
                    label: /* pressGeoON ==true?*/  Text("Upload Location"),// : Text("Upload Done"),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ButtonWidget(
                text: 'Submit',
                onClicked: () {
                  print('Email: ${emailController.text}');
                  print('Password: ${password}');
                  print('Number: ${numberController.text}');
                },
              ),
            ],
          ),
          ),
        ),
  );

  Widget buildEmail() => TextField(
        // controller: emailController,
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
    // controller: emailController,
    decoration: InputDecoration(
      enabledBorder: const OutlineInputBorder(
        // width: 0.0 produces a thin "hairline" border
        borderSide: const BorderSide(color: Colors.black38, width: 1.0),
      ),
      // hintText: 'name@example.com',
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
}
