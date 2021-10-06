/*import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:textfield_example/photo.dart';
// import 'package:textfield_example/widget/textfield_border_widget.dart';
// import 'package:textfield_example/widget/textfield_focus_widget.dart';

import 'widget_copy/textfield_general_widget.dart';
// import 'package:textfield_example/widget/textfield_general_widget.dart';
// import 'location.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'hello';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    theme: ThemeData(primaryColor: Color(0xFFFEAA9C)),
    home: MainPage(title: 'UPLOAD YOUR SIGHTING'),
  );
}

class MainPage extends StatefulWidget {
  final String title;

  const MainPage({
    required this.title,
  });

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    /*appBar: AppBar(
          title: Text(widget.title,
          style: TextStyle(
            color: Colors.white,
          )),

        ), */
    body: buildPages(),

    /* bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          selectedItemColor: Colors.cyan,
          items: [
            BottomNavigationBarItem(
              icon: Text('Boo'),
              title: Text('General'),
            ),
            BottomNavigationBarItem(
              icon: Text('TextField'),
              title: Text('Borders'),
            ),
            BottomNavigationBarItem(
              icon: Text('TextField'),
              title: Text('Focus'),
            ),
            BottomNavigationBarItem(
              icon: Text('location'),
              title: Text('lalala'),
            ),
            BottomNavigationBarItem(
              icon: Text('photo'),
              title: Text('lalala'),
            ),
          ],
          onTap: (int index) => setState(() => this.index = index),
        ), */

  );

  Widget buildPages() {
    //  switch (index) {
    //    case 0:
    return TextfieldGeneralWidget();
    /*   case 1:
        return TextfieldBorderWidget();
      case 2:
        return TextfieldFocusWidget();
      case 3:
        return GeoListenPage();
      case 4:
        return UploadImageDemo();
      default:
        return Container();
    }*/
  }
}
*/

