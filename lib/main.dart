import 'package:flutter/material.dart';
import 'package:projectsalesmaterial/states/approve_page.dart';
import 'package:projectsalesmaterial/states/home.dart';
import 'package:projectsalesmaterial/states/upload_main.dart';
import 'package:projectsalesmaterial/utility/myconstant.dart';

final Map<String, WidgetBuilder> map = {
  myconstant.routehomepage: (BuildContext context) => HomePage(),
  myconstant.routeUploadHome: (BuildContext context) => UploadHome(),
  myconstant.routeApprove: (BuildContext context) => approve_page(),

  // myconstant.routeContent:(BuildContext context) => myContentArea(),
};
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: map,
      initialRoute: myconstant.routehomepage,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
